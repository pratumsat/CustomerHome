//
//  GetExchangeRateApi.swift
//  Customs2Home
//
//  Created by warodom on 8/10/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import RxSwift
import Alamofire
import Foundation
import RxAlamofire
import ObjectMapper

class GetExchangeRateApi: BaseAPI<BaseRequest, ExchangeRate> {
    
    override func createUrlReq(_ encRequest: EncRequest) -> URLRequestConvertible {
        return Router.getExchangeRateList( encRequest.request).apiModel
    }
    
    override func callService(request: BaseRequest) -> Observable<ExchangeRate> {
        return super.execute(request)
    }
    
    override func createUrlReqNoSecurity(_ encRequest: [String : Any]) -> URLRequestConvertible {
        return Router.getExchangeRateList(encRequest).apiModel
    }
    
    override func callServiceNoSecurity(request: BaseRequest) -> Observable<ExchangeRate> {
        return super.executeNoSecurity(request.toJSON(), true)
    }
    
}
