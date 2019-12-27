//
//  GenerateReqIDComponent.swift
//  VRT Mobile
//
//  Created by Kemin Suenggittawisuthi on 20/6/2562 BE.
//  Copyright © 2562 Kemin Suenggittawisuthi. All rights reserved.
//

import Foundation
import AdSupport
import UIKit

class GeneratorRandomComponent {
    
    public func randomString(defaultLength: Int) -> String {
        let letters: NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomString: NSMutableString = NSMutableString(capacity: defaultLength)
        for _ in 0 ... defaultLength - 1 {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        return randomString as String
    }
    
//    public func u() -> String? {
//        guard let uuid = UIDevice.current.identifierForVendor?.uuidString else { return nil }
//        return uuid
//    }
    
    
    public func getUniqueId() -> String? {
        let identifierManager = ASIdentifierManager.shared()
        guard identifierManager.isAdvertisingTrackingEnabled else { return nil }
        let deviceId = identifierManager.advertisingIdentifier.uuidString
        return deviceId
    }
    
}
