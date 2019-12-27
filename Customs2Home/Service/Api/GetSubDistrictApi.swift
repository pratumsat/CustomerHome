//
//  GetSubDistrictApi.swift
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

class GetSubDistrictApi: BaseAPI<BaseRequest_SubDistrict, BaseResponse_SubDistrict> {
    
    override func createUrlReq(_ encRequest: EncRequest) -> URLRequestConvertible {
        return Router.getSubDistrict( encRequest.request).apiModel
    }
    
    override func callService(request: BaseRequest_SubDistrict) -> Observable<BaseResponse_SubDistrict> {
        return super.execute(request)
    }
    
    override func createUrlReqNoSecurity(_ encRequest: [String : Any]) -> URLRequestConvertible {
        return Router.getSubDistrict( encRequest).apiModel
    }
    
    override func callServiceNoSecurity(request: BaseRequest_SubDistrict) -> Observable<BaseResponse_SubDistrict> {
        return super.executeNoSecurity(request.toJSON())
    }
}
