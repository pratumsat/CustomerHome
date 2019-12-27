//
//  GetPayInSlipApi.swift
//  Customs2Home
//
//  Created by warodom on 19/12/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import RxSwift
import Alamofire
import Foundation
import RxAlamofire
import ObjectMapper

class GetPayInSlipApi: BaseAPI<BaseRequest_Payinslip, BaseResponse_Payinslip> {
    
    override func createUrlReq(_ encRequest: EncRequest) -> URLRequestConvertible {
        return Router.getPayinslip( encRequest.request).apiModel
    }
    
    override func callService(request: BaseRequest_Payinslip) -> Observable<BaseResponse_Payinslip> {
        return super.execute(request)
    }
}
