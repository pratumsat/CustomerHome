//
//  PostFCMTokenApi.swift
//  Customs2Home
//
//  Created by warodom on 26/11/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import Foundation
import RxAlamofire
import ObjectMapper

class PostFCMTokenApi: BaseAPI<BaseRequest_FCMToken, Logout> {
    
    override func createUrlReq(_ encRequest: EncRequest) -> URLRequestConvertible {
        return Router.uploadFCMToken(encRequest.request).apiModel
    }
    
    override func callService(request: BaseRequest_FCMToken) -> Observable<Logout> {
        return super.execute(request)
    }
}
