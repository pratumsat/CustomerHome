//
//  GetProvince.swift
//  Customs2Home
//
//  Created by warodom on 21/11/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import Foundation
import RxAlamofire
import ObjectMapper

class GetProvince: BaseAPI<BaseRequest_Province, Response_Province> {
    
    override func createUrlReq(_ encRequest: EncRequest) -> URLRequestConvertible {
        return Router.getProvince( encRequest.request).apiModel
    }
    
    override func callService(request: BaseRequest_Province) -> Observable<Response_Province> {
        return super.execute(request, true)
    }
    
    override func createUrlReqNoSecurity(_ encRequest: [String : Any]) -> URLRequestConvertible {
        return Router.getProvince( encRequest).apiModel
    }
    
    override func callServiceNoSecurity(request: BaseRequest_Province) -> Observable<Response_Province> {
        return super.executeNoSecurity(request.toJSON(), true)
    }
}
