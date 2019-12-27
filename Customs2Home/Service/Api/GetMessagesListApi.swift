//
//  GetMessagesListApi.swift
//  Customs2Home
//
//  Created by warodom on 29/11/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import RxSwift
import Alamofire
import Foundation
import RxAlamofire
import ObjectMapper

class GetMessagesListApi: BaseAPI<BaseRequest_MessagesList, BaseResponse_MessagesList> {
    
    override func createUrlReq(_ encRequest: EncRequest) -> URLRequestConvertible {
        return Router.getMessagesList( encRequest.request).apiModel
    }
    
    override func callService(request: BaseRequest_MessagesList) -> Observable<BaseResponse_MessagesList> {
        return super.execute(request)
    }
}
