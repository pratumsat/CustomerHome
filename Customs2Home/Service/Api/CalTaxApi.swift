//
//  CalTaxApi.swift
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

class CalTaxApi: BaseAPI<BaseRequestCalTax, CalTax> {
    
    override func createUrlReq(_ encRequest: EncRequest) -> URLRequestConvertible {
        return Router.getCalTax( encRequest.request).apiModel
    }
    
    override func callService(request: BaseRequestCalTax) -> Observable<CalTax> {
        return super.execute(request)
    }
}
