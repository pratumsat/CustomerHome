//
//  PostRegisterApi.swift
//  Customs2Home
//
//  Created by warodom on 20/11/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import Foundation
import RxAlamofire
import ObjectMapper

class PostRegisterApi: BaseAPI<BaseRequest_Register, Response_Register> {
    
    override func createUrlReq(_ encRequest: EncRequest) -> URLRequestConvertible {
        return Router.postRegister( encRequest.request).apiModel
    }
    
    override func callService(request: BaseRequest_Register) -> Observable<Response_Register> {
        return super.execute(request)
    }
}
