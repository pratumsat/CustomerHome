//
//  CheckVersion.swift
//  Customs2Home
//
//  Created by warodom on 4/12/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import Foundation
import ObjectMapper

struct CheckCurrentVersion: Mappable {
    var currentVersion: Bool?
    var status: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        currentVersion <- map["currentVersion"]
        status <- map["statusCd"]
    }
}
