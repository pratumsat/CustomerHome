//
//  GetLogoutApi.swift
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

class GetLogoutApi: BaseAPI<BaseRequest, Logout> {
    
    override func createUrlReq(_ encRequest: EncRequest) -> URLRequestConvertible {
        return Router.logout( encRequest.request).apiModel
    }
    
    override func callService(request: BaseRequest) -> Observable<Logout> {
        return super.execute(request)
    }
}
