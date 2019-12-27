//
//  deleteDeclareApi.swift
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

class DeleteDeclareApi: BaseAPI<BaseRequestDeleteDeclareReq, DeleteDeclate> {
    
    override func createUrlReq(_ encRequest: EncRequest) -> URLRequestConvertible {
        return Router.deleteDeclareList( encRequest.request).apiModel
    }
    
    override func callService(request: BaseRequestDeleteDeclareReq) -> Observable<DeleteDeclate> {
        return super.execute(request)
    }
}


