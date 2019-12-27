//
//  EncryptionHandler.swift
//  VRT Mobile
//
//  Created by Kemin Suenggittawisuthi on 20/6/2562 BE.
//  Copyright © 2562 Kemin Suenggittawisuthi. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class EncryptionHandler {
    
    private var enc: APIEncrypt
    
    init(){
        self.enc = APIEncrypt()
    }
    
    func getParameters(request : [String: Any]) -> Parameters {
        return enc.encrypt(parameters: request)
    }
    
    func getResultString (result : String ) -> String? {
//        printRed("String in decrypt", result)
//        print("Result string : \(result)")
        let data = result.data(using: .utf8)!
        do {
            // data we are getting from network request
            let decoder = JSONDecoder()
            let response = try decoder.decode(DecryptValue.self, from: data)
//            printRed("value",response.value) //Output - EMT
//            print(enc.decrypt(cipherText: response.value))
            return enc.decrypt(cipherText: response.value)
        } catch { print(error)
            return enc.decrypt(cipherText: "")}
        
    }
    
    func getDataEncrypt(data : String) -> String {
        return enc.encryptDataStorage(data: data)
    }
    
    func getDataDecrypt(data : String) -> String? {
        return enc.decryptDataStorage(data: data)
    }
}
