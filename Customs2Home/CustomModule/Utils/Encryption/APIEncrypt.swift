//
//  APIEncrypt.swift
//  VRT Mobile
//
//  Created by Kemin Suenggittawisuthi on 20/6/2562 BE.
//  Copyright © 2562 Kemin Suenggittawisuthi. All rights reserved.
//

import Foundation
import Alamofire
import CryptoSwift

class APIEncrypt {
    
    private let keyGenerator: GeneratorRandomComponent
    private var aes: AES!
    private var aesForData: AES!
    var passwordsave : String! = "jXn2r5u8x/A?D(G+KaPdSgVkYp3s6v9y"
    var ivsave : String! = "TOKENSERVICESC01"
    var randomKeyData : String!
    var key: String!
    
    init(keyGenerator: GeneratorRandomComponent = GeneratorRandomComponent()) {
        self.keyGenerator = keyGenerator
    }
    
    func encrypt(parameters: Parameters) -> Parameters {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            let jsonString = String(data: jsonData, encoding: .utf8)
            //            let password: String = keyGenerator.randomString(defaultLength: AES.blockSize)
            //            let password: String = "uTZ1M9AGPQcpjFBBS2c14Mkl12OE2DRK"
            let aesKey = "jXn2r5u8x/A?D(G+KaPdSgVkYp3s6v9y"
            
            //            let aesKey = password2.padding(toLength: 32, withPad: "0", startingAt: 0)
            //            printRed(aesKey)
            //            passwordsave = password
            passwordsave = aesKey
            //            printYellow("random ", Array(password.utf8))
            //            let iv: String = keyGenerator.randomString(defaultLength: AES.blockSize)
            let iv: String = "TOKENSERVICESC01"
            let salt: String = keyGenerator.randomString(defaultLength: AES.blockSize)
            ivsave = iv
            let password_to_string: Array<UInt8> = Array(salt.utf8)
            let password_to_iv: Array<UInt8> = Array(iv.utf8)
            //            let value = AES.randomIV(AES.blockSize)
            //            printGreen(value)
            //            let password: String = "2646120059527717"
            //            let iv: String = "22f2684d5cffb309e74f25b992ec7c5a"
            //            let salt: String = "0c9f4b2635d4fc3c82e7a5ab8154ecea"
            //            let password_to_string = Data(hex: salt)
            //            print("Secret Key : \(password)")
            //            let password_to_string = Array<UInt8>(hex: "0c9f4b2635d4fc3c82e7a5ab8154ecea")
            //            print("salt hex : \(password_to_string)")
            try setRandomKey(randomKey: aesKey, iv: iv, salt: salt)
            
            let queryParams = jsonString
            let key = encryptedKey(key: aesKey)
            //            print("Pubilc + Secret Key : \(key)")
            let encryptedParams = try aes.encrypt(queryParams!.utf8.map {$0}).toBase64()
            let data = "\(password_to_iv.toHexString())::\(password_to_string.toHexString())::\(encryptedParams!)"
            let data2 = (data).data(using: String.Encoding.utf8)
            let base64 = data2!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            
            let data3 = (encryptedParams!).data(using: String.Encoding.utf8)
            let base644 = data3!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            return [
                "value": encryptedParams!,
                "key": key
            ]
        } catch {
            return [:]
        }
    }
    
    private func setRandomKey(randomKey: String, iv: String, salt: String) throws {
        //        let iv: Array<UInt8> = AES.randomIV(AES.blockSize)
        //        print("AES Block size : \(AES.blockSize)")
        
        let randomKeyEncrypt: Array<UInt8> = Array(randomKey.utf8)
        //        let saltEncrypt: Array<UInt8> = Array(salt.utf8)
        let ivEncrypt: Array<UInt8> = Array(iv.utf8)
        
        //        let keys = try PKCS5.PBKDF2(password: randomKeyEncrypt, salt: saltEncrypt, iterations: 1000,keyLength: 16, variant: .sha1).calculate()
        //        let keyss = try HKDF(password: randomKeyEncrypt, salt: saltEncrypt, variant: .sha1).calculate()
        //        printGreen("randomkey count", randomKeyEncrypt.count)
        //        print("Secret Key + Encrypt : \(keys.toHexString())")
        //        print("Secret Key + Encrypt : \(keys)")
        //        print("Count Secret Key + Encrypt : \(keys.count)")
        //        printRed("RandomKey : \(randomKeyEncrypt)")
        //        printRed("RandomKey hex : \(randomKeyEncrypt.toHexString())")
        //        printRed("RandomKey base64 : \(randomKeyEncrypt.toBase64())")
        //        printRed("Salt : \(saltEncrypt)")
        //        print("Count Salt : \(saltEncrypt.count)")
        //        printRed("IV : \(ivEncrypt)")
        //        print("Count IV : \(ivEncrypt.count)")
        //        guard let aes = try? AES(key: keys, blockMode: CBC(iv: ivEncrypt), padding: Padding.pkcs7) else {
        //            print("THROW ERROR INVALIDKEYSIZE")
        //            throw AES.Error.invalidKeySize
        //        }
        let gcm = GCM(iv: ivEncrypt, mode: .combined)
        guard let aes = try? AES(key: randomKeyEncrypt, blockMode: gcm, padding: .noPadding) else {
            print("THROW ERROR INVALIDKEYSIZE")
            throw AES.Error.invalidKeySize
        }
        self.aes = aes
    }
    
    private func encryptedKey(key: String) -> String {
        let rsaEncrypt = RSAEncrypt()
        return rsaEncrypt.encrypt(string: key)
    }
    
    func decrypt(cipherText: String) -> String? {
        //        printRed("cipherText : \(cipherText)")
        //        guard let data = decodeFromDecrypt(value: cipherText) else {return cipherText}
        //        printBlue(data)
        //        if data == [""]{
        //            return ""
        //        } else {
        //            guard let decryptedText = try? aesDecrypt(data: data[2], salt: data[1], iv: data[0]) else {return ""}
        //            guard let decryptedText = try? aesDecrypt(data: data[0], salt: "", iv: "") else {return ""}
        guard let decryptedText = try? aesDecrypt(data: cipherText, salt: "", iv: "") else {return ""}
        //            printRed("DecryptedText : \(decryptedText)")
        return decryptedText
        //        }
        
    }
    
    func decodeFromDecrypt(value: String) -> [String]? {
        guard let decodedData = Data(base64Encoded: value) else {return nil}
        guard let decodedString = String(data: decodedData, encoding: .utf8) else {return nil}
        
        let data = decodedString.components(separatedBy: "::")
        //        print("split data : \(data)")
        
        return data
    }
    
    func aesDecrypt(data:String, salt: String, iv: String) throws -> String {
        //        let saltEncrypt = Array<UInt8>(hex: salt)
        //        let ivEncrypt = Array<UInt8>(hex: iv)
        let randomKeydecrypt: Array<UInt8> = Array(passwordsave.utf8)
        //        let saltEncrypt: Array<UInt8> = Array(ivsave.utf8)
        let ivEncrypt: Array<UInt8> = Array(ivsave.utf8)
        
        //        print("Salt : \(saltEncrypt)")
        //        print("IV : \(ivEncrypt)")
        //        print("Random Key : \(randomKeydecrypt)")
        //        print("Salt Count : \(saltEncrypt.count)")
        //        print("IV Count : \(ivEncrypt.count)")
        //        print("Random KeymCount : \(randomKeydecrypt.count)")
        //        printKhem(data)
        //        let keys = try PKCS5.PBKDF2(password: randomKeydecrypt, salt: saltEncrypt, iterations: 1000,keyLength: 16, variant: .sha1).calculate()
        //        guard let dec = try? AES(key: keys, blockMode: CBC(iv: ivEncrypt), padding: Padding.pkcs7) else {
        //            print("THROW ERROR INVALIDKEYSIZE")
        //            throw AES.Error.invalidKeySize
        //        }
        let gcm = GCM(iv: ivEncrypt, mode: .combined)
        guard let dec = try? AES(key: randomKeydecrypt, blockMode: gcm, padding: .noPadding) else {
            print("THROW ERROR INVALIDKEYSIZE")
            throw AES.Error.invalidKeySize
        }
        guard let dataDec = try? data.decryptBase64ToString(cipher: dec) else { return "" }
        
        
        return dataDec
    }
    
    func encryptDataStorage(data : String) -> String {
        randomKeyData = "uTZ1M9AGPQcpjFBBS2c14Mkl12OE2DRK"
        let randomKeyEncrypt: Array<UInt8> = Array(randomKeyData.utf8)
        let ivEncrypt: Array<UInt8> = Array("TOKENSERVICESC01".utf8)
        
        let gcm = GCM(iv: ivEncrypt, mode: .combined)
        guard let aes = try? AES(key: randomKeyEncrypt, blockMode: gcm, padding: .noPadding) else {
            print("THROW ERROR INVALIDKEYSIZE")
            return ""
        }
        self.aesForData = aes
        guard let value = try? aesForData.encrypt(data.utf8.map {$0}).toBase64() else {return ""}
        return value
    }
    
    func decryptDataStorage(data: String) -> String? {
        randomKeyData = "uTZ1M9AGPQcpjFBBS2c14Mkl12OE2DRK"
        let randomKeyEncrypt: Array<UInt8> = Array(randomKeyData.utf8)
        let ivEncrypt: Array<UInt8> = Array("TOKENSERVICESC01".utf8)
        
        let gcm = GCM(iv: ivEncrypt, mode: .combined)
        guard let aes = try? AES(key: randomKeyEncrypt, blockMode: gcm, padding: .noPadding) else {
            print("THROW ERROR INVALIDKEYSIZE")
            return nil
        }
        guard let dataDec = try? data.decryptBase64ToString(cipher: aes) else { return nil }
        
        return dataDec
    }
    
    
    
}


extension Data {
    public init(hex: String) {
        self.init( Array<UInt8>(hex: hex))
    }
}


