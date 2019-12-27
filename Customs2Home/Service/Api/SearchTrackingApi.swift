//
//  SearchTrackingApi.swift
//  Customs2Home
//
//  Created by thanawat on 12/11/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//

import RxSwift
import Alamofire
import Foundation
import RxAlamofire
import ObjectMapper

class SearchTrackingApi: BaseAPI<BaseRequestTrackingReq, Tracking> {
    
    override func createUrlReq(_ encRequest: EncRequest) -> URLRequestConvertible {
        return Router.tracking( encRequest.request).apiModel
    }
    
    override func callService(request: BaseRequestTrackingReq) -> Observable<Tracking> {
        return super.execute(request)
    }
}

