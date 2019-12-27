//
//  Rounter.swift
//  Customs2Home
//
//  Created by Wittawas Mukdaprasert on 1/10/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

enum Router  {
    case getExchangeRateList(_ parameters:Parameters)
    case getTariffByName(_ parameters:Parameters)
    case getTariffList(_ parameters:Parameters)
    case getCalCostIf(_ parameters:Parameters)
    case getCalTax(_ parameters:Parameters)
    case getCalTaxInfo(_ parameters:Parameters)
    case getContactUs(_ parameters:Parameters)
    case getFaq(_ parameters:Parameters)
    case postRegister(_ parameter:Parameters)
    case Login(_ parameters:Parameters)
    case gettermandcond(_ parameters:Parameters)
    case getProvince(_ parameters:Parameters)
    case getDistrict(_ parameters:Parameters)
    case getSubDistrict(_ parameters:Parameters)
    case generateOTP(_ parameters:Parameters)
    case verifyOTP(_ parameters:Parameters)
    case forgetPassword(_ parameters:Parameters)
    case forgetPasswordConfirm(_ parameters:Parameters)
    case generateotp(_ parameters:Parameters)
    case refreshtoken(_ parameters:Parameters)
    case uploadFCMToken(_ parameters:Parameters)
    case logout(_ parameters:Parameters)
    case userdetail(_ parameters:Parameters)
    case getDeclareList(_ parameters:Parameters)
    case getMessagesList(_ parameters:Parameters)
    case uploadDeclareFile(_ parameters:Parameters)
    case addEditDeclare(_ parameters:Parameters)
    case deleteDeclareList(_ parameters:Parameters)
    case deleteMsgList(_ parameters:Parameters)
    case tracking(_ parameters:Parameters)
    case getQRCode(_ parameters:Parameters)
    case declaredetail(_ parameters:Parameters)
    case getPaymentdetailcreditcard(_ parameters:Parameters)
    case getPayinslip(_ parameters:Parameters)
    case msgdetail(_ parameters:Parameters)
    case msgRead(_ parameters:Parameters)
    var apiModel:ApiModel {
        switch self {
        case .getExchangeRateList(let parameters):
            return ApiModel(path: "appc2hservice/masterdataapi/v1/getexchangeratelist", method: .post, parameters)
        case .getTariffByName(let parameters):
            return ApiModel(path: "appc2hservice/masterdataapi/v1/gettariffbyname", method: .post, parameters)
        case .getTariffList(let parameters):
            return ApiModel(path: "appc2hservice/masterdataapi/v1/gettarifflist", method: .post, parameters)
        case .getCalCostIf(let parameters):
            return ApiModel(path: "appc2hservice/declarationapi/v1/calcostif", method: .post, parameters)
        case .getCalTax(let parameters):
            return ApiModel(path: "appc2hservice/declarationapi/v1/caltax", method: .post, parameters)
        case .getCalTaxInfo(let parameters):
            return ApiModel(path: "appc2hservice/masterdataapi/v1/getcaltaxinfo", method: .post, parameters)
        case .getContactUs(let parameters):
            return ApiModel(path: "appc2hservice/masterdataapi/v1/getcontactus", method: .post, parameters)
        case .getFaq(let parameters):
            return ApiModel(path: "appc2hservice/masterdataapi/v1/getfaq", method: .post, parameters)
        case .postRegister(let parameters):
            return ApiModel(path: "appc2hservice/usermanagementapi/v1/register", method: .post, parameters)
        case .Login(let parameters):
            return ApiModel(path: "appc2hservice/authenticateapi/v1/login", method: .post, parameters)
        case .gettermandcond(let parameters):
            return ApiModel(path: "appc2hservice/usermanagementapi/v1/gettermandcond", method: .post, parameters)
        case .getProvince(let parameters):
            return ApiModel(path: "appc2hservice/apploadconfigapi/v1/provinceddl", method: .post, parameters)
        case .getDistrict(let parameters):
            return ApiModel(path: "appc2hservice/apploadconfigapi/v1/districtddl", method: .post, parameters)
        case .getSubDistrict(let parameters):
            return ApiModel(path: "appc2hservice/apploadconfigapi/v1/subdistrictddl", method: .post, parameters)
        case .generateOTP(let parameters):
            return ApiModel(path: "appc2hservice/usermanagementapi/v1/generateotp", method: .post, parameters)
        case .verifyOTP(let parameters):
            return ApiModel(path: "appc2hservice/usermanagementapi/v1/verifyotp", method: .post, parameters)
        case .forgetPassword(let parameters):
            return ApiModel(path: "appc2hservice/usermanagementapi/v1/forgetpassword", method: .post, parameters)
        case .forgetPasswordConfirm(let parameters):
            return ApiModel(path: "appc2hservice/usermanagementapi/v1/forgetpasswordconfirm", method: .post, parameters)
        case .generateotp(let parameters):
            return ApiModel(path: "appc2hservice/usermanagementapi/v1/generateotp", method: .post, parameters)
        case .refreshtoken(let parameters):
            return ApiModel(path: "appc2hservice/authenticateapi/v1/refreshtoken", method: .post, parameters)
        case .uploadFCMToken(let parameters):
            return ApiModel(path: "appc2hservice/authenticateapi/v1/fcmupdate", method: .post, parameters,
                            authen: KeyChainService.accessToken ?? "")
        case .logout(let parameters):
            return ApiModel(path: "appc2hservice/authenticateapi/v1/logout", method: .post, parameters,
                            authen: KeyChainService.accessToken ?? "")
        case .userdetail(let parameters):
            return ApiModel(path: "appc2hservice/usermanagementapi/v1/userdetail", method: .post, parameters,
                            authen: KeyChainService.accessToken ?? "")
        case .getDeclareList(let parameter):
            return ApiModel(path: "appc2hservice/declareapi/v1/declarelist", method: .post, parameter,
                            authen: KeyChainService.accessToken ?? "")
        case .getMessagesList(let parameter):
            return ApiModel(path: "appc2hservice/inboxapi/v1/msglist", method: .post, parameter,
                            authen: KeyChainService.accessToken ?? "")
        case .uploadDeclareFile(let parameter):
            return ApiModel(path: "appc2hservice/filemanagerapi/v1/upload", method: .post, parameter, authen: KeyChainService.accessToken ?? "")
        case .addEditDeclare(let parameter):
            return ApiModel(path: "appc2hservice/declareapi/v1/addedit", method: .post, parameter,
                            authen: KeyChainService.accessToken ?? "")
        case .deleteDeclareList(let parameter):
            return ApiModel(path: "appc2hservice/declareapi/v1/delete", method: .post, parameter,
                            authen: KeyChainService.accessToken ?? "")
        case .deleteMsgList(let parameter):
            return ApiModel(path: "appc2hservice/inboxapi/v1/msgdel", method: .post, parameter,
                            authen: KeyChainService.accessToken ?? "")
        case .tracking(let parameter):
            return ApiModel(path: "appc2hservice/declareapi/v1/tracking", method: .post, parameter,
                            authen: KeyChainService.accessToken ?? "")
        case .getQRCode(let parameter):
            return ApiModel(path: "appc2hservice/client/payment/v1/getQRCode", method: .post, parameter,
                            authen: KeyChainService.accessToken ?? "")
        case .declaredetail(let parameter):
            return ApiModel(path: "appc2hservice/declareapi/v1/declaredetail", method: .post, parameter,
                            authen: KeyChainService.accessToken ?? "")
        case .getPaymentdetailcreditcard(let parameter):
            return ApiModel(path: "appc2hservice/client/payment/v1/getpaymentdetailcreditcard", method: .post, parameter,
                            authen: KeyChainService.accessToken ?? "")
        case .getPayinslip(let parameter):
            return ApiModel(path: "appc2hservice/client/payment/v1/getPayInSlip", method: .post, parameter,
                            authen: KeyChainService.accessToken ?? "")
        case .msgdetail(let parameter):
            return ApiModel(path: "appc2hservice/inboxapi/v1/msgdetail", method: .post, parameter,
                            authen: KeyChainService.accessToken ?? "")
        case .msgRead(let parameter):
            return ApiModel(path: "appc2hservice/inboxapi/v1/msgread", method: .post, parameter,
                            authen: KeyChainService.accessToken ?? "")
        }
    }
}

struct ApiModel:URLRequestConvertible {
    #if UAT
    let base:String = "https://c2h-test.customs.go.th:34110/"
    #else
    let base:String = "https://c2h.customs.go.th:14110/"
    #endif
    
    var path:String
    var method: Alamofire.HTTPMethod
    var parameters:Parameters?
    var authen:String!
    
    var absPath:String {
        return base + path
    }
    
    init (path:String,method:Alamofire.HTTPMethod,_ parameters:Parameters? = nil,authen:String = "")
    {
        self.path = path
        self.method = method
        self.parameters = parameters
        self.authen = authen
    }
    
    func asURLRequest() throws -> URLRequest {
        let model = self
        let url = URL(string: model.absPath )!
        var mutableURLRequest = URLRequest(url: url)
        let parturl = URL(string: self.path)
        
        mutableURLRequest.httpMethod = model.method.rawValue
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.setValue(model.authen, forHTTPHeaderField: "Authorization")
        mutableURLRequest.setValue(Utils.getIPAddress(), forHTTPHeaderField: "ip")
        mutableURLRequest.setValue("ios", forHTTPHeaderField: "src")
        mutableURLRequest.setValue((Date().DateToString(format: "YYYYMMdd"))+(GeneratorRandomComponent().getUniqueId() ?? ""), forHTTPHeaderField: "reqID")
        mutableURLRequest.setValue("Importer", forHTTPHeaderField: "reqChannel")
        mutableURLRequest.setValue(Date().DateToString(format: "YYYY-MM-dd HH:MM:ss.s"), forHTTPHeaderField: "reqDtm")
        mutableURLRequest.setValue(parturl?.lastPathComponent, forHTTPHeaderField: "Service")
        let jsonData = model.parameters.map({ return try? JSONSerialization.data(withJSONObject: $0 , options: .prettyPrinted) })
        mutableURLRequest.httpBody = jsonData!
        return mutableURLRequest
    }
}
