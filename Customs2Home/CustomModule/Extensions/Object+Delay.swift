//
//  Object+Delay.swift
//  VRT Mobile
//
//  Created by Wittawas Mukdaprasert on 22/7/2562 BE.
//  Copyright © 2562 Kemin Suenggittawisuthi. All rights reserved.
//

import Foundation

extension NSObject
{
    func delay(delay:Double,  closure:@escaping ()->Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds( Int(delay * 1000) ) , execute: closure)
    }
    
}
