//
//  GetForgotPasswordApi.swift
//  Customs2Home
//
//  Created by thanawat on 11/22/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import Foundation
import RxAlamofire
import ObjectMapper

class GetForgotPasswordApi: BaseAPI<BaseRequestForgotPassword, ForgotPassword> {
    
    override func createUrlReq(_ encRequest: EncRequest) -> URLRequestConvertible {
        return Router.forgetPassword( encRequest.request).apiModel
    }
    
    override func callService(request: BaseRequestForgotPassword) -> Observable<ForgotPassword> {
        return super.execute(request)
    }
}
