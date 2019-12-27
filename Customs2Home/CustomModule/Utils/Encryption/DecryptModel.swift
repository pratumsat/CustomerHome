//
//  DecryptModel.swift
//  VRT Mobile
//
//  Created by Kemin Suenggittawisuthi on 8/7/2562 BE.
//  Copyright © 2562 Kemin Suenggittawisuthi. All rights reserved.
//

import Foundation

struct DecryptValue : Codable {
    let value: String
    private enum CodingKeys : String, CodingKey {
        case value
    }
}
