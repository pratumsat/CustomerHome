//
//  BaseRequestDeleteMsgReq.swift
//  Customs2Home
//
//  Created by thanawat on 12/9/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//


import Foundation
import ObjectMapper

struct BaseRequestDeleteMsgReq : Mappable {
    var reqDtm : String?
    var reqBy : String?
    var langCode : String?
    var imei : String?
    var msgdelReq : MsgdelReq?
    
    init?(map: Map) {
        
    }
    init(msgdelReq : MsgdelReq?) {
        self.reqDtm = Date().DateToServerFormatString()
        self.reqBy = KeyChainService.userId ?? GeneratorRandomComponent().getUniqueId()
        self.imei = GeneratorRandomComponent().getUniqueId()
        self.langCode = "th"
        self.msgdelReq = msgdelReq
    }
    
    mutating func mapping(map: Map) {
        
        reqDtm <- map["reqDtm"]
        reqBy <- map["reqBy"]
        langCode <- map["langCode"]
        imei <- map["imei"]
        msgdelReq <- map["msgdelReq"]
    }
    
}
