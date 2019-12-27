//
//  BaseRequestLogin.swift
//  Customs2Home
//
//  Created by thanawat on 11/20/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//

import Foundation
import ObjectMapper

struct BaseRequestLogin : Mappable {
    var reqDtm : String?
    var imei : String?
    var loginReq : LoginReq?
    var langCode: String?
    var reqBy: String?
    
    init() {

    }
    
    init(loginReq: LoginReq) {
        self.reqDtm = Date().DateToServerFormatString()
        self.reqBy = KeyChainService.userId ?? GeneratorRandomComponent().getUniqueId()
        self.imei = GeneratorRandomComponent().getUniqueId()
        self.langCode = "EN"
        self.loginReq = loginReq
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        reqDtm <- map["reqDtm"]
        imei <- map["imei"]
        langCode <- map["langCode"]
        loginReq <- map["loginReq"]
        reqBy <- map["reqBy"]
    }
    
}
