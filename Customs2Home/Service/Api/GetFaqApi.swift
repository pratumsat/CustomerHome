//
//  GetFaqApi.swift
//  Customs2Home
//
//  Created by thanawat on 10/16/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//
import RxSwift
import Alamofire
import Foundation
import RxAlamofire
import ObjectMapper

class GetFaqApi: BaseAPI<BaseRequest, Faq> {
    
    override func createUrlReq(_ encRequest: EncRequest) -> URLRequestConvertible {
        return Router.getFaq( encRequest.request).apiModel
    }
    
    override func callService(request: BaseRequest) -> Observable<Faq> {
        return super.execute(request)
    }
}
