//
//  GetTaRiffByNameApi.swift
//  Customs2Home
//
//  Created by warodom on 10/10/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import RxSwift
import Alamofire
import Foundation
import RxAlamofire
import ObjectMapper

class GetTaRiffByNameApi: BaseAPI<BaseRequestTaRiff, TariffbyName> {
    
    override func createUrlReq(_ encRequest: EncRequest) -> URLRequestConvertible {
        return Router.getTariffByName( encRequest.request).apiModel
    }
    
    override func callService(request: BaseRequestTaRiff) -> Observable<TariffbyName> {
        return super.execute(request)
    }
}

