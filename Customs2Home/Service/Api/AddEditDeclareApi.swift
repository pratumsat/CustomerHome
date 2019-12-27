//
//  AddEditDeclareApi.swift
//  Customs2Home
//
//  Created by thanawat on 12/2/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//

import RxSwift
import Alamofire
import Foundation
import RxAlamofire
import ObjectMapper

class AddEditDeclareApi: BaseAPI<BaseRequestDeclareAddEdit, AddEditDeclare> {
    
    override func createUrlReq(_ encRequest: EncRequest) -> URLRequestConvertible {
        return Router.addEditDeclare( encRequest.request).apiModel
    }
    
    override func callService(request: BaseRequestDeclareAddEdit) -> Observable<AddEditDeclare> {
        return super.execute(request)
    }
}

