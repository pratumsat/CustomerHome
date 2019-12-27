//
//  BaseAPI.swift
//  VRT Mobile
//
//  Created by Kemin Suenggittawisuthi on 20/6/2562 BE.
//  Copyright © 2562 Kemin Suenggittawisuthi. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import RxSwift
import RxAlamofire

typealias EncRequest = (encHandler: EncryptionHandler, request: [String: Any])

open class BaseAPI<Request: BaseMappable, Response: BaseMappable> {
    
    fileprivate let sessionManager: SessionManager
    let serverTrustPolicies: [String: ServerTrustPolicy] = [
        "c2h-test.customs.go.th": ServerTrustPolicy.pinCertificates( certificates: ServerTrustPolicy.certificates(),
                                                                     validateCertificateChain: true,
                                                                     validateHost: true
            
        ),
        "c2h.customs.go.th": ServerTrustPolicy.pinCertificates( certificates: ServerTrustPolicy.certificates(),
                                                                     validateCertificateChain: true,
                                                                     validateHost: true
            
        )
    ]
    
    init() {
        sessionManager = SessionManager(
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        sessionManager.retrier = self as? RequestRetrier
    }
    
    func callService(request: Request) -> Observable<Response> {
        preconditionFailure("Call service must be overridden")
    }
    
    func callServiceNoSecurity(request: Request) -> Observable<Response> {
        preconditionFailure("Call service must be overridden")
    }
    
    func callServiceUpload(request: Request, fileURL:URL) -> Observable<Response> {
         preconditionFailure("Call service must be overridden")
    }
    
    func createUrlReq(_ encRequest: EncRequest) -> URLRequestConvertible {
        preconditionFailure("Create url request must be overridden")
    }
    
    func createUrlReqNoSecurity(_ encRequest: [String:Any]) -> URLRequestConvertible {
        preconditionFailure("Create url request must be overridden")
    }
    
    //    func execute(_ request: [String: Any], _ catchData: Bool = false) -> Observable<Response> {
    //        return Observable.just(request)
    //            .map { request in self.encryptRequest(request) }
    //            .flatMapLatest { encRequest in self.requestRxAlamofire(encRequest,catchData) }
    //            .catchError({ throw self.translaterToKError(error: $0) })
    //            .map { response in try self.verifyHttpStatusCode(response) }
    //            .flatMapLatest { response in try self.translateResponse(response.1) }
    //            .map({ jsonObject in try self.verifyRespond(  jsonObject )  })
    //    }
    
    func execute(_ request: Request, _ catchData: Bool = false) -> Observable<Response> {
        return Observable.just(request)
            .map { request in self.encryptRequest(request.toJSON()) }
            .flatMapLatest { encRequest in self.requestRxAlamofire(encRequest) }
            .catchError({ throw self.translaterToKError(error: $0) })
            .map { response in try self.verifyHttpStatusCode(response) }
            .flatMapLatest { response in try self.translateResponse(response.1) }
            .map({ jsonObject in try self.verifyRespond(  jsonObject )  })
            .retryWhen({[unowned self] (error) -> Observable<Request> in
                return error.flatMap({ (error) -> Observable<Request> in
                    //guard ((error as? KError) != nil) && attempts <= 1 else { return .error(error)  }
                    guard let k_error = error as? KError else { return .error(error)  }
                    let msg = k_error.getMessage.message ?? ""
                    let code = k_error.getMessage.codeString ?? ""
                    
                    var observable = Observable.just(request)
                    
                    if code.contains("J006") {
                        observable = self.renewToken(request: request)
                    }else if code.contains("J015") || code.contains("J016"){
                        TokenModel.clearTokenData()
                        TokenModel.showAlertForceLogin(msg: msg)
                        return .error(error)
                    }else{
                        return .error(error)
                    }
                    return observable
                })
                
            })
    }
    
    private func requestRxAlamofire(_ encRequest: EncRequest) -> Observable<(HTTPURLResponse, String)> {
        let urlReq = createUrlReq(encRequest)
        let request = self.sessionManager.rx.request(urlRequest: urlReq)
            .flatMap { dataRequest in dataRequest.rx.responseString() }
            .map { response in try self.decryptResponse(response, encHandler: encRequest.encHandler) }
        #if OFFLINE
        return loadBackupData(request: urlReq, requestObservable: request)
            .catchError({ _ in  return request })
            .do(onNext:  { response in backupCacheData(data: response) } )
        #else
        return request
        #endif
        
        
    }
    
    func executeNoSecurity(_ request: [String: Any], _ catchData: Bool = false) -> Observable<Response> {
        return Observable.just(request)
            .flatMapLatest { encRequest in self.requestRxAlamofireNoSecurity(encRequest,catchData) }
            .catchError({ throw self.translaterToKError(error: $0) })
            .map { response in try self.verifyHttpStatusCode(response) }
            .flatMapLatest { response in try self.translateResponse(response.1) }
            .map({ jsonObject in try self.verifyRespond(  jsonObject )  })
    }
    private func checkVersion(request: URLRequestConvertible, response:(HTTPURLResponse, String),catchData: Bool) -> Observable<(HTTPURLResponse, String)>{
        guard catchData else { return Observable.just(response)}
        let checkVersion = Mapper<CheckCurrentVersion>().map(JSONString: response.1)
        if (checkVersion?.currentVersion ?? false) {
           return loadBackupDataCatchData(request: request)
        } else {
            //delete catch file 
            if let path = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false),
                let lastPath = request.urlRequest?.url?.lastPathComponent {
                let fullPath = path.appendingPathComponent( lastPath+".json" )
                do {
                    try FileManager.default.removeItem(at: fullPath)
                } catch {
                    printRed(error)
                }
            }
            return loadBackupDataCatchData(request: request)
                .catchError({ _ in  return Observable.just(response)})
                .do(onNext:  { response in backupCacheDataForSomeService(data: response) } )
        }
    }
    private func requestRxAlamofireNoSecurity(_ encRequest: [String: Any], _ catchData: Bool = false) -> Observable<(HTTPURLResponse, String)> {
        let urlReq = createUrlReqNoSecurity(encRequest)
        let request = self.sessionManager.rx.request(urlRequest: urlReq)
            .flatMap { dataRequest in dataRequest.rx.responseString(encoding: .utf8) }
            .map { data in self.checkVersion(request: urlReq, response: data, catchData: catchData)  }
        #if OFFLINE
        return loadBackupData(request: urlReq, requestObservable: request)
            .catchError({ _ in  return request })
            .do(onNext:  { response in backupCacheData(data: response) } )
        #else
        return request.switchLatest()
        #endif
    }
    
    private func encryptRequest(_ request: [String: Any]) -> (encHandler: EncryptionHandler, request: [String: Any]) {
        let encryptionHandler = EncryptionHandler.init()
        let encryptRequest = encryptionHandler.getParameters(request: request)
        return (encryptionHandler, encryptRequest)
    }
    
    private func verifyHttpStatusCode(_ response: (HTTPURLResponse, String)) throws -> (HTTPURLResponse, String)  {
        switch response.0.statusCode {
        case 200:
            return response
        default:
            throw KError.httpRespondError(response.0)
        }
    }
    
    private func translaterToKError( error:Error ) -> KError
    {
        if let error = error as? KError {
            return error
        }
        else if let error = error as? URLError {
            return KError.httpError(error)
        }
        else
        {
            fatalError("Can't handle error")
        }
    }
    
    func decryptResponse(_ response: (HTTPURLResponse, String), encHandler: EncryptionHandler) throws -> (HTTPURLResponse, String) {
        guard let decryptResponse = encHandler.getResultString(result: response.1) else {
            throw KError.internalError(-2002)
        }
        return (response.0, decryptResponse)
    }
    
    func translateResponse(_ httpResponse: String) throws -> Observable<Response> {
        guard let jsonObj = Mapper<Response>().map(JSONString: httpResponse) else {
            throw KError.internalError(-2000)
        }
        return Observable.just(jsonObj )
    }
    
    func verifyRespond( _ jsonObj: Response ) throws -> Response  {
        guard let baseRespond = jsonObj as? BaseRespond else {
            throw KError.internalError(-2001)
        }
        guard baseRespond.statusCd == "0000" else { throw KError.httpServiceError(baseRespond) }
        //expire access token code =  ATJ
        return jsonObj
    }
    
    func renewToken(request:Request) -> Observable<Request> {
        return TokenModel.instance().getRefreshToken().map({ (respond) in
            return request
        })
    }
    //    func verifyRespond (Mapper)
    
    
}

