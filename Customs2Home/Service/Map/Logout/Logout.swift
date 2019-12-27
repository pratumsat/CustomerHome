//
//  Logout.swift
//  Customs2Home
//
//  Created by thanawat on 11/26/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//

import Foundation
import ObjectMapper

struct Logout : Mappable ,BaseRespond {
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

