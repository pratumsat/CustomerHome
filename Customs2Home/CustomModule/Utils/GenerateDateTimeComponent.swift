//
//  GenerateDateTimeComponent.swift
//  VRT Mobile
//
//  Created by Kemin Suenggittawisuthi on 20/6/2562 BE.
//  Copyright © 2562 Kemin Suenggittawisuthi. All rights reserved.
//

import Foundation

struct GeneratorDateFormatComponent {
    var dateString: String!
    
    init(dateString: String) {
        self.dateString = dateString
    }
    
    init() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        self.init(dateString: dateFormatter.string(from: Date()))
    }
    
}

