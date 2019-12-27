//
//  GetTermAndCondApi.swift
//  Customs2Home
//
//  Created by thanawat on 11/21/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//

import RxSwift
import Alamofire
import Foundation
import RxAlamofire
import ObjectMapper

class GetTermAndCondApi: BaseAPI<BaseRequest, TermAndCon> {
    
    override func createUrlReq(_ encRequest: EncRequest) -> URLRequestConvertible {
        return Router.gettermandcond( encRequest.request).apiModel
    }
    
    override func callService(request: BaseRequest) -> Observable<TermAndCon> {
        return super.execute(request)
    }
}
