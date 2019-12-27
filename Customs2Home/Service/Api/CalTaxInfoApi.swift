//
//  CalTaxInfoApi.swift
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

class CalTaxInfoApi: BaseAPI<BaseRequest, CalTaxInfo> {
    
    override func createUrlReq(_ encRequest: EncRequest) -> URLRequestConvertible {
        return Router.getCalTaxInfo( encRequest.request).apiModel
    }
    
    override func callService(request: BaseRequest) -> Observable<CalTaxInfo> {
        return super.execute(request)
    }
}

