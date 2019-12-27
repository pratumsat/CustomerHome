//
//  BaseRequest_upload.swift
//  Customs2Home
//
//  Created by warodom on 2/12/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import Foundation
import ObjectMapper

struct BaseRequest_upload : Mappable {
    var reqDtm : String?
    var imei : String?
    var reqBy : String?
    var langCode : String?
    var description : String?
    var action : String?
    var key : String?
    var refid : Int?
    let date = Date()
    
    init?(map: Map) {
        
    }
    
    init() {
//        YYYY-MM-DD HH:MI:SS.SSS
         reqDtm = date.DateToServerFormatString()
//        reqDtm = "2016-07-28 15:15:15.4"
        imei = GeneratorRandomComponent().getUniqueId()
        reqBy = KeyChainService.userId ?? GeneratorRandomComponent().getUniqueId()
        langCode = "th"
        description = "PAYMENT_SLIP"
        action = "declare"
        key = "EW5241365TH"
        refid = 123

    }
    
    mutating func mapping(map: Map) {
        
        reqDtm <- map["reqDtm"]
        imei <- map["imei"]
        reqBy <- map["reqBy"]
        langCode <- map["langCode"]
        description <- map["description"]
        action <- map["action"]
        key <- map["key"]
        refid <- map["refId"]
        
    }
    
}
