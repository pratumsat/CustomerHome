//
//  GetContactApi.swift
//  Customs2Home
//
//  Created by warodom on 11/10/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import RxSwift
import Alamofire
import Foundation
import RxAlamofire
import ObjectMapper

class GetContactApi: BaseAPI<BaseRequest, Contact> {
    
    override func createUrlReq(_ encRequest: EncRequest) -> URLRequestConvertible {
        return Router.getContactUs( encRequest.request).apiModel
    }
    
    override func callService(request: BaseRequest) -> Observable<Contact> {
        return super.execute(request)
    }
}
