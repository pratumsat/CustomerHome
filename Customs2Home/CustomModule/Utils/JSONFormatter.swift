//
//  JSONFormatter.swift
//  VRT Mobile
//
//  Created by Kemin Suenggittawisuthi on 20/6/2562 BE.
//  Copyright © 2562 Kemin Suenggittawisuthi. All rights reserved.
//

import Foundation

class JSONFormatter {
    
    static let instance = JSONFormatter()
    
    func getPrettyJSON(_ dic: [String: Any]) -> String {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted) else {
            return "Unable to convert dictionary to json string"
        }
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            return "Unable to convert dictionary to json string"
        }
        return jsonString
    }
    
}


