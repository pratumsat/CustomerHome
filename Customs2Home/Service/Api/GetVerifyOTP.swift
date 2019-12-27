//
//  GetVerifyOTP.swift
//  Customs2Home
//
//  Created by thanawat on 11/21/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//

import RxSwift
import Alamofire
import Foundation
import RxAlamofire
import ObjectMapper

class GetVerifyOTP: BaseAPI<BaseRequestVerifyOTP, VerifyOTPResp> {
    
    override func createUrlReq(_ encRequest: EncRequest) -> URLRequestConvertible {
        return Router.verifyOTP( encRequest.request).apiModel
    }
    
    override func callService(request: BaseRequestVerifyOTP) -> Observable<VerifyOTPResp> {
        return super.execute(request)
    }
}
