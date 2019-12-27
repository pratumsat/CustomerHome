//
//  UploadDeclareApi.swift
//  Customs2Home
//
//  Created by warodom on 2/12/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import Foundation
import RxAlamofire
import ObjectMapper

class UploadDeclareApi: BaseAPI<BaseRequest_upload, BaseRespones_Upload> {
    
    override func createUrlReqNoSecurity(_ encRequest: [String : Any]) -> URLRequestConvertible {
        return Router.uploadDeclareFile(encRequest).apiModel
    }
    
//    override func callServiceUpload(request: BaseRequest_upload, fileURL:URL) -> Observable<BaseRespones_Upload> {
//        return super.executeUploadNoSecurity(request.toJSON(), fileURL)
//    }
}
