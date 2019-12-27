//
//  EmptyMap.swift
//  Customs2Home
//
//  Created by Wittawas Mukdaprasert on 1/10/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import Foundation
import ObjectMapper

struct EmptyMap : Mappable {
    init() {
        
    }
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
    }
    
}
