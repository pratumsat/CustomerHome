//
//  GetQRcodeApi.swift
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

class GetQRCodeApi: BaseAPI<BaseRequestQrCodeReq, BaseRespone_QRcode> {
    
    override func createUrlReq(_ encRequest: EncRequest) -> URLRequestConvertible {
        return Router.getQRCode( encRequest.request).apiModel
    }
    
    override func callService(request: BaseRequestQrCodeReq) -> Observable<BaseRespone_QRcode> {
        return super.execute(request)
    }
}

