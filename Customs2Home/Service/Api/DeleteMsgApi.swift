//
//  DeleteMsgApi.swift
//  Customs2Home
//
//  Created by thanawat on 12/9/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//

import RxSwift
import Alamofire
import Foundation
import RxAlamofire
import ObjectMapper

class DeleteMsgApi: BaseAPI<BaseRequestDeleteMsgReq, DeleteMessage> {
    
    override func createUrlReq(_ encRequest: EncRequest) -> URLRequestConvertible {
        return Router.deleteMsgList( encRequest.request).apiModel
    }
    
    override func callService(request: BaseRequestDeleteMsgReq) -> Observable<DeleteMessage> {
        return super.execute(request)
    }
}


