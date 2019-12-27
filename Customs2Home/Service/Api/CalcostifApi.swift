//
//  CalcostifApi.swift
//  Customs2Home
//
//  Created by warodom on 16/10/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import RxSwift
import Alamofire
import Foundation
import RxAlamofire
import ObjectMapper

class CalcostifApi: BaseAPI<BaseRequestCalCostIf, CalCostIf> {
    
    override func createUrlReq(_ encRequest: EncRequest) -> URLRequestConvertible {
        return Router.getCalCostIf( encRequest.request).apiModel
    }
    
    override func callService(request: BaseRequestCalCostIf) -> Observable<CalCostIf> {
        return super.execute(request)
    }
}
