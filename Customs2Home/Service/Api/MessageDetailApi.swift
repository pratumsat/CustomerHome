//
//  MessageDetailApi.swift
//  Customs2Home
//
//  Created by thanawat on 12/23/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//

import RxSwift
import Alamofire
import Foundation
import RxAlamofire
import ObjectMapper

class MessageDetailApi: BaseAPI<BaseRequestMsgdetailReq, Msgdetail> {
    
    override func createUrlReq(_ encRequest: EncRequest) -> URLRequestConvertible {
        return Router.msgdetail( encRequest.request).apiModel
    }
    
    override func callService(request: BaseRequestMsgdetailReq) -> Observable<Msgdetail> {
        return super.execute(request)
    }
}
