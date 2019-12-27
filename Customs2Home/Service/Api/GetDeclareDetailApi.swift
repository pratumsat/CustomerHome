//
//  GetDeclareDetailApi.swift
//  Customs2Home
//
//  Created by thanawat on 12/16/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//

import RxSwift
import Alamofire
import Foundation
import RxAlamofire
import ObjectMapper

class GetDeclareDetailApi: BaseAPI<BaseRequestDeclareDetailReq, DeclareResponse> {
    
    override func createUrlReq(_ encRequest: EncRequest) -> URLRequestConvertible {
        return Router.declaredetail( encRequest.request).apiModel
    }
    
    override func callService(request: BaseRequestDeclareDetailReq) -> Observable<DeclareResponse> {
        return super.execute(request)
    }
}

