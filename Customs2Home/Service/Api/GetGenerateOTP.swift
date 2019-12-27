//
//  GetGenerateOTP.swift
//  Customs2Home
//
//  Created by thanawat on 11/22/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//

import RxSwift
import Alamofire
import Foundation
import RxAlamofire
import ObjectMapper

class GetGenerateOTP: BaseAPI<BaseRequestGenerateOtp, GenerateOtp> {
    
    override func createUrlReq(_ encRequest: EncRequest) -> URLRequestConvertible {
        return Router.generateotp( encRequest.request).apiModel
    }
    
    override func callService(request: BaseRequestGenerateOtp) -> Observable<GenerateOtp> {
        return super.execute(request)
    }
}
