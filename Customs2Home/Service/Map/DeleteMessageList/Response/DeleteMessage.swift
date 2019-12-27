//
//  DeleteMessage.swift
//  Customs2Home
//
//  Created by thanawat on 12/9/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//

import Foundation
import ObjectMapper

struct DeleteMessage : Mappable ,BaseRespond {
    var statusCd : String?
    var statusDescTH : String?
    var statusDescEN : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        statusCd <- map["statusCd"]
        statusDescTH <- map["statusDescTH"]
        statusDescEN <- map["statusDescEN"]
    }
    
}

