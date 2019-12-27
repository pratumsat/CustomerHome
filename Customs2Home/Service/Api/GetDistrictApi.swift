//
//  GetDistrictApi.swift
//  Customs2Home
//
//  Created by warodom on 22/11/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import Foundation
import RxAlamofire
import ObjectMapper

class GetDistrictApi: BaseAPI<BaseRequest_District, Response_District> {
    
    override func createUrlReq(_ encRequest: EncRequest) -> URLRequestConvertible {
        return Router.getDistrict( encRequest.request).apiModel
    }
    
    override func callService(request: BaseRequest_District) -> Observable<Response_District> {
        return super.execute(request)
    }
    
    override func createUrlReqNoSecurity(_ encRequest: [String : Any]) -> URLRequestConvertible {
        return Router.getDistrict( encRequest).apiModel
    }
    
    override func callServiceNoSecurity(request: BaseRequest_District) -> Observable<Response_District> {
        return super.executeNoSecurity(request.toJSON())
    }
}

