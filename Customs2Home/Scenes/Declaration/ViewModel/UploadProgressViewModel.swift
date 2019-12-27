//
//  UploadProgressViewModel.swift
//  Customs2Home
//
//  Created by thanawat on 12/4/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import RxAlamofire
import Alamofire
import ObjectMapper

class UploadProgressViewModel: BaseViewModel<UploadProgressViewModel>,ViewModelProtocol {

    typealias M = UploadProgressViewModel
    typealias T = UploadProgressViewController
    static var obj_instance: UploadProgressViewModel?
   
    
    override init() {
        super.init()
    }
    
    var processRelay = BehaviorRelay<Double>(value: 0.0)
    
    func transform(input: Input) -> Output {
        processRelay.accept(0)
        let commonDispose = [Disposable]()

        let responds = input.onLoadView
  
        var itemsObs:[Observable<BaseRespones_Upload>] = []
        
        responds.forEach {  (model) in
            let uploadImage = self.uploadImage(model: model)
            itemsObs.append(uploadImage)
        }
        let itemCount = Float(responds.count)
        var queue:Float = 0.0
        let uploaded = Observable.concat(itemsObs)
            .do(onNext: { (event) in
                queue += 1
            })
        
        
        
        let process = processRelay.filter({ $0 > 0 }).map({  (queue + Float($0)) / itemCount })
        return UploadProgressViewModel.Output(uploaded: uploaded,
                                              process: process,
                                              commonDispose: CompositeDisposable(disposables: commonDispose) )
    }
    
    
    func uploadImage(model:(id:String, tracking:String, type:String,  image:Data))  ->  Observable<BaseRespones_Upload>{
        let url = (Router.uploadDeclareFile([:]).apiModel.base)+(Router.uploadDeclareFile([:]).apiModel.path)
        return Observable<BaseRespones_Upload>.create({ observer in
            let parameters: [String:String] = [
                "reqDtm":"2016-07-28 15:15:15.4",
                "reqBy":"49",
                "langCode":"th",
                "description": model.type,
                "action":"declare",
                "key": model.tracking,
                "refId": model.id
            ]
            let headers =  ["Content-Type" : "application/json",
                            "src" : "ios" ,
                            "reqID" : "20190131000000000001",
                            "reqChannel" : "Importer",
                            "reqDtm" : "2016-07-28 15:15:15.4",
                            "Service" : "upload",
                            "Authorization" : KeyChainService.accessToken ?? ""
            ]
            Alamofire.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(model.image, withName: "uploadFile",
                                         fileName: "\(Date().dateAndTimetoString()).jpg",
                                         mimeType: "image/jpg")

                for (key, value) in parameters {
                    multipartFormData.append((value.data(using: .utf8))!, withName: key)
                }}, to: url, method: .post, headers: headers,
                    encodingCompletion: {[unowned self] encodingResult in
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.uploadProgress { progress in
                              //  printBlue(progress.fractionCompleted)
                                self.processRelay.accept(progress.fractionCompleted)
                            }
                            
                            upload.responseJSON { [weak self] response in
                                guard self != nil else { return }
                                
                                guard response.result.error == nil else {
                                    observer.onError(response.result.error!)
                                    return
                                }
                                
                                if let response = Mapper<BaseRespones_Upload>().map(JSON: (response.result.value as! NSDictionary) as! [String : Any]){
                                    observer.onNext(response)
                                }
                                
                                observer.onCompleted()
                            }
                        case .failure(let encodingError):
                            observer.onError(encodingError)
                        }
            })
            return Disposables.create();
        })
    }
    
    func fecthdata() -> Driver<[KTableCellSection]> {
        
        guard let loadingScreen = self.loadingScreen
            else {return .just([])}
        
        let service = Observable.just(true)
        let loading = loadingScreen.observeLoading(service)
        .map({ [unowned self] respond -> [KTableCellSection] in
            return self.parser( respond)
        })
        .subscribeOn(MainScheduler.asyncInstance)
        .observeOn(MainScheduler.instance)
        .asDriver(onErrorJustReturn: [])
        return loading
        
    }
    
    func parser(_ respond:Bool) -> [KTableCellSection]
    {
        let sections = [KTableCellSection]()
        return sections
    }
    
    private func applyCellTable( byName name:String, cellArray:inout [KTableCellModel]) -> KTableCellModel
    {
        let count = cellArray.count
        let cell =  KTableCellModel(identity: count, cellIden: name)
        cellArray.append( cell )
        return cell
    }
    
}

extension UploadProgressViewModel {
    struct Input {
        let onLoadView: [(id:String, tracking:String, type:String,  image:Data)]
    }
    
    struct Output {
        let uploaded: Observable<BaseRespones_Upload>
        let process: Observable<Float>
        let commonDispose: CompositeDisposable
    }
}
