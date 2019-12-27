//
//  GetPaymentdetailcreditcardApi.swift
//  Customs2Home
//
//  Created by warodom on 17/12/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import RxSwift
import Alamofire
import Foundation
import RxAlamofire
import ObjectMapper

class GetPaymentdetailcreditcardApi: BaseAPI<BaseRequest_Paymentdetailcreditcard, BaseResponse_Paymentdetailcreditcard> {
    
    override func createUrlReq(_ encRequest: EncRequest) -> URLRequestConvertible {
        return Router.getPaymentdetailcreditcard( encRequest.request).apiModel
    }
    
    override func callService(request: BaseRequest_Paymentdetailcreditcard) -> Observable<BaseResponse_Paymentdetailcreditcard> {
        return super.execute(request)
    }
}

