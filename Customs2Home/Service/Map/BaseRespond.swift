//
//  BaseRespond.swift
//  Customs2Home
//
//  Created by Wittawas Mukdaprasert on 24/10/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import Foundation
import ObjectMapper

protocol BaseRespond: Mappable {
    var statusCd : String? { get set }
    var statusDescTH : String? { get set }
    var statusDescEN : String? { get set }
}
