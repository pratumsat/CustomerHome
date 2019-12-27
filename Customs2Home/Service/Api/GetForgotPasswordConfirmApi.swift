//
//  GetForgotPasswordConfirm.swift
//  Customs2Home
//
//  Created by thanawat on 11/25/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import Foundation
import RxAlamofire
import ObjectMapper

class GetForgotPasswordConfirmApi: BaseAPI<BaseRequestForgetPasswordConfirm, ForgetPasswordConfirm> {
    
    override func createUrlReq(_ encRequest: EncRequest) -> URLRequestConvertible {
        return Router.forgetPasswordConfirm( encRequest.request).apiModel
    }
    
    override func callService(request: BaseRequestForgetPasswordConfirm) -> Observable<ForgetPasswordConfirm> {
        return super.execute(request)
    }
}
