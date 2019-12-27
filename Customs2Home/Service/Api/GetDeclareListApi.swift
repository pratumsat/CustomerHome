//
//  GetDeclareListApi.swift
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

class GetDeclareListApi: BaseAPI<BaseRequest_Declarelist, BaseResponse_DeclareList> {
    
    override func createUrlReq(_ encRequest: EncRequest) -> URLRequestConvertible {
        return Router.getDeclareList( encRequest.request).apiModel
    }
    
    override func callService(request: BaseRequest_Declarelist) -> Observable<BaseResponse_DeclareList> {
        return super.execute(request)
    }
}
