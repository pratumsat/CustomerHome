//
//  BaseRequest_Province.swift
//  Customs2Home
//
//  Created by warodom on 21/11/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import Foundation
import ObjectMapper

struct BaseRequest_Province : Mappable {
    var reqDtm: String?
    var imei: String?
    var reqBy: String?
    var langCode : String?
    var version : String?
    
    init?(map: Map) {
        
    }
    
    init(version: String) {
        reqDtm = Date().DateToServerFormatString()
        imei = GeneratorRandomComponent().getUniqueId()
        reqBy = KeyChainService.userId ?? GeneratorRandomComponent().getUniqueId()
        langCode = "TH"
        self.version = version
    }

    
    mutating func mapping(map: Map) {
        reqDtm <- map["reqDtm"]
        imei <- map["imei"]
        reqBy <- map["reqBy"]
        langCode <- map["langCode"]
        version <- map["version"]
    }
}
