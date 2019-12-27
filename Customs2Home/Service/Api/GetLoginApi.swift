//
//  GetLoginApi.swift
//  Customs2Home
//
//  Created by thanawat on 11/20/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//
import RxSwift
import Alamofire
import Foundation
import RxAlamofire
import ObjectMapper

class GetLoginApi: BaseAPI<BaseRequestLogin, Login> {
    
    override func createUrlReq(_ encRequest: EncRequest) -> URLRequestConvertible {
        return Router.Login( encRequest.request).apiModel
    }
    
    override func callService(request: BaseRequestLogin) -> Observable<Login> {
        return super.execute(request)
    }
}
