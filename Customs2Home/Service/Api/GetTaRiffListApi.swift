//
//  GetTaRiffListApi.swift
//  Customs2Home
//
//  Created by warodom on 9/10/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import RxSwift
import Alamofire
import Foundation
import RxAlamofire
import ObjectMapper

class GetTaRiffListApi: BaseAPI<BaseRequest, Tariff> {
    
    override func createUrlReq(_ encRequest: EncRequest) -> URLRequestConvertible {
        return Router.getTariffList( encRequest.request).apiModel
    }
    
    override func callService(request: BaseRequest) -> Observable<Tariff> {
        return super.execute(request)
    }
    
    override func createUrlReqNoSecurity(_ encRequest: [String : Any]) -> URLRequestConvertible {
         return Router.getTariffList( encRequest ).apiModel
    }
    
    override func callServiceNoSecurity(request: BaseRequest) -> Observable<Tariff> {
          return super.executeNoSecurity(request.toJSON(),true)
    }
}

