//
//  GetRefreshTokenApi.swift
//  Customs2Home
//
//  Created by thanawat on 11/27/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//
import Foundation
import RxSwift
import Alamofire
import Foundation
import RxAlamofire
import ObjectMapper

class GetRefreshTokenApi: BaseAPI<BaseRequestRefreshToken, RefreshToken> {
    
    override func createUrlReq(_ encRequest: EncRequest) -> URLRequestConvertible {
        return Router.refreshtoken( encRequest.request).apiModel
    }
    
    override func callService(request: BaseRequestRefreshToken) -> Observable<RefreshToken> {
        return super.execute(request)
    }
}
