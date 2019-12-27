//
//  MsgReadApi.swift
//  Customs2Home
//
//  Created by thanawat on 12/24/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//

import RxSwift
import Alamofire
import Foundation
import RxAlamofire
import ObjectMapper

class MsgReadApi: BaseAPI<BaseRequestMsgreadReq, MsgReadRespond> {
    
    override func createUrlReq(_ encRequest: EncRequest) -> URLRequestConvertible {
        return Router.msgRead( encRequest.request).apiModel
    }
    
    override func callService(request: BaseRequestMsgreadReq) -> Observable<MsgReadRespond> {
        return super.execute(request)
    }
}
