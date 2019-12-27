//
//  InstanceProtocol.swift
//  VRT Mobile
//
//  Created by Wittawas Mukdaprasert on 1/8/2562 BE.
//  Copyright © 2562 Kemin Suenggittawisuthi. All rights reserved.
//

import UIKit
protocol InstanceProtocol {
    associatedtype T:UIViewController
    associatedtype M:NSObject
    
    var viewControl:T? { get set }
    static var obj_instance:M? { get set }
    static func instance() -> M
}
