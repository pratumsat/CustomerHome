//
//  RSAEncrypt.swift
//  VRT Mobile
//
//  Created by Kemin Suenggittawisuthi on 20/6/2562 BE.
//  Copyright © 2562 Kemin Suenggittawisuthi. All rights reserved.
//

import Foundation
import SwiftyRSA

class RSAEncrypt {
    
    private let publicKeyFile: String
    
    init(publicKeyFile: String = "MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAh57vaaCZ5Hl9YON3pCLFiZPl+/d35+l1D5YhGbAERfrANbubDP/ZMTO0KTQRZviDCcONxS0yYd0ebf4uiXzXDiYPRKIQ6dL2rijmkxjtG0dok5So803D89e7HDLeil0B3+aDhXHdAhWFIp3k1cwxC68id5aj9Z/OHGzlfy0MDR7Rhx1r26SFZ0FeIl1s4uTV594sHunppdyxDyxJuigsT+30uXUJZb5kvEO4vKmdsUCQpdxkUZl6ktrcWTItfJPJyGy8OGuhkRMn5lqm5F5TjvNVmQ9kKtTqxRaieACacNS0SE4PrOLvFznWr/KztPyntAuvphCX/xhiKlgzCLTwKXFSAmVCDhllzlfjkW0qRmG1g4YlPfHq5+/NitJ8hnw6N3FbADPLmukBpqUOczF6genhC/5efrXIl6XcDgtkbRFpUaO6ASWPi/oEJaUXm3zq1eXa2hrT9bS1IqDXnropQ26EkP+wiu/Y4P74lfBtyYKMQgGNuS1BioY3PW52DEYvRzj6V/uEU/aK4sSVkGlT23ad8uu78MonOJ0TxkDrjrue5MT4Gkig9yBfuxHiRAzx67X3GvJtD++5vjQNtFeRl0mjvRZaAViuvqE43hlCszW3wY0qI4YpAiops5WkuF8IECqPiUl+U+751ZBaf4yX0P7MOIz4tIIHvHIAExK3HAMCAwEAAQ==") {
        self.publicKeyFile = publicKeyFile
    }
    
    func encrypt(string: String) -> String {
        do {
            let publicKey = try getPublicKey()
//            print("Public Key : \(publicKey)")
            let clearMessage = try createClearMessage(from: string)
//            print("Clear Message : \(clearMessage)")
            let cipherText = try clearMessage.encrypted(with: publicKey, padding: .PKCS1)
//            print(cipherText.data)
//            print(cipherText.base64String)
            return cipherText.base64String
        } catch {
            return ""
        }
    }
    
    private func getPublicKey() throws -> PublicKey {
        //        let bundle = Bundle(for: type(of: self))
//        print("Public Key File : \(publicKeyFile)")
        //        guard let publicKey = try? PublicKey(pemNamed: publicKeyFile, in: bundle) else {
        //            print("ERROR GET PUBLICKEY")
        //            throw SwiftyRSAError.stringToDataConversionFailed
        //        }
        guard let publicKey = try? PublicKey(pemEncoded: publicKeyFile) else {
            print("ERROR GET PUBLICKEY")
            throw SwiftyRSAError.stringToDataConversionFailed
        }
        return publicKey
    }
    
    private func createClearMessage(from string: String) throws -> ClearMessage {
        guard let message = try? ClearMessage(string: string, using: .utf8) else {
            print("ERROR CREATE CLEAR MESSAGE")
            throw SwiftyRSAError.stringToDataConversionFailed
        }
        return message
    }
    
}

