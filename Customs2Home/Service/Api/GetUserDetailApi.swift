//
//  GetUserDetailApi.swift
//  Customs2Home
//
//  Created by thanawat on 11/26/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import Foundation
import RxAlamofire
import ObjectMapper

class GetUserDetail: BaseAPI<BaseRequest, UserDetail> {
    
    override func createUrlReq(_ encRequest: EncRequest) -> URLRequestConvertible {
        return Router.userdetail( encRequest.request).apiModel
    }
    
    override func callService(request: BaseRequest) -> Observable<UserDetail> {
        return super.execute(request)
    }
}
