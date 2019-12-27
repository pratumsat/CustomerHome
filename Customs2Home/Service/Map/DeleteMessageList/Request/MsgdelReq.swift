//
//  MsgdelReq.swift
//  Customs2Home
//
//  Created by thanawat on 12/9/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//

import Foundation
import ObjectMapper

struct MsgdelReq : Mappable {
    var msgId : [Int]?
    
    init?(map: Map) {
        
    }
    init(msgId:[Int]?) {
        self.msgId = msgId
    }
    
    mutating func mapping(map: Map) {
        
        msgId <- map["msgId"]
    }
    
}

