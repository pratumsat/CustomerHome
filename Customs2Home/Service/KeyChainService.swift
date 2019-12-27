//
//  KeyChainService.swift
//  VRT Mobile
//
//  Created by Kemin Suenggittawisuthi on 20/6/2562 BE.
//  Copyright © 2562 Kemin Suenggittawisuthi. All rights reserved.
//

import Foundation
import Security

// Constant Identifiers
let DataRepoKeyChain = "DataRepoKeyChain"

/**
 *  User defined keys for new entry
 *  Note: add new keys for new secure item and use them in load and save methods
 */
let _userId = "userId"
let _email = "email"

let _cardId = "cardId"
let _touristId = "touristId"
let _refreshToken = "refreshToken"
let _accessToken = "accessToken"
let _pin = "pin"
let _passportNo = "passportNo"
let _tokenFirebase = "tokenFirebase"
let _rememberMe = "rememberMe"
let _notibadge = "notiBadge_\(KeyChainService.userId ?? "")"

// Arguments for the keychain queries
let kSecClassValue = NSString(format: kSecClass)
let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
let kSecValueDataValue = NSString(format: kSecValueData)
let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
let kSecAttrServiceValue = NSString(format: kSecAttrService)
let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
let kSecReturnDataValue = NSString(format: kSecReturnData)
let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)
let encryptionHandler = EncryptionHandler.init()

class KeyChainService: NSObject {
    
    class var isRemember:Bool?{
        get{
            let value = self.load(service: _rememberMe)
            let result = value == "1"
            return result
        }
        set{
            if let isRemember = newValue
            {
                self.save(service: _rememberMe, data: isRemember ? "1":"0")
            }
            else
            {
                self.delete(service: _rememberMe)
            }
        }
    }
    
    class func setEmail(data: String) {
        self.save(service: _email, data: encryptionHandler.getDataEncrypt(data: data))
    }
    
    //    class func getEmail() -> String? {
    //        return encryptionHandler.getDataDecrypt(data: toString(self.load(service: _email)))
    //    }
    
    static var email: String? {
        return encryptionHandler.getDataDecrypt(data: toString(self.load(service: _email)))
    }
    
    class func deleteEmail() {
        self.delete(service: _email)
    }
    
    class func setNotiBadge(data: String) {
        self.save(service: _notibadge, data: encryptionHandler.getDataEncrypt(data: data))
    }
    
    static var notiBadge: String? {
        return encryptionHandler.getDataDecrypt(data: toString(self.load(service: _notibadge)))
    }
    
    class func deleteNotiBadge() {
        self.delete(service: _notibadge)
    }
    
    class func setUserId(data: String) {
        self.save(service: _userId, data: encryptionHandler.getDataEncrypt(data: data))
    }
    
//    class func getUserId() -> String? {
//        return encryptionHandler.getDataDecrypt(data: toString(self.load(service: _userId)))
//    }
    
    static var userId: String? {
        return encryptionHandler.getDataDecrypt(data: toString(self.load(service: _userId)))
    }
    
    class func deleteUserId() {
        self.delete(service: _userId)
    }
    
    class func setTouristId(touristID: String) {
        self.save(service: _touristId, data: encryptionHandler.getDataEncrypt(data: touristID))
    }
    
    class func getTouristId() -> String? {
        return encryptionHandler.getDataDecrypt(data: toString(self.load(service: _touristId)))
    }
    
    class func deleteTouristId() {
        self.delete(service: _touristId)
    }
    
    class func setCardId(cardID: String) {
        self.save(service: _cardId, data: encryptionHandler.getDataEncrypt(data: cardID))
    }
    
    class func getCardId() -> String? {
        return encryptionHandler.getDataDecrypt(data:  toString(self.load(service: _cardId)))
    }
    
    class func deleteCardId() {
        self.delete(service: _cardId)
    }
    
    class func setRefreshToken(refToken: String) {
        self.save(service: _refreshToken, data: encryptionHandler.getDataEncrypt(data: refToken))
    }
    
//    class func getRefreshToken() -> String? {
//        return encryptionHandler.getDataDecrypt(data:  toString(self.load(service: _refreshToken)))
//    }
    
    static var refreshToken: String? {
        return encryptionHandler.getDataDecrypt(data:  toString(self.load(service: _refreshToken)))
    }
    
    class func deleteRefreshToken() {
        self.delete(service: _refreshToken)
    }
    
    class func setAccessToken(AcsToken: String) {
        self.save(service: _accessToken, data: encryptionHandler.getDataEncrypt(data: AcsToken))
    }
    
//    class func getAccessToken() -> String? {
//        return encryptionHandler.getDataDecrypt(data: toString(self.load(service: _accessToken)))
//    }
    
    static var accessToken: String? {
        return encryptionHandler.getDataDecrypt(data: toString(self.load(service: _accessToken)))
    }
    
    class func deleteAccessToken() {
        self.delete(service: _accessToken)
    }
    
    class func setPIN(PIN: String) {
        self.save(service: _pin, data: encryptionHandler.getDataEncrypt(data: PIN))
    }
    
    class func getPIN() -> String? {
        return encryptionHandler.getDataDecrypt(data: toString(self.load(service: _pin)))
    }
    
    class func deletePIN() {
        self.delete(service: _pin)
    }
    
    class func setPassportNo(PassportNo: String) {
        self.save(service: _passportNo, data: encryptionHandler.getDataEncrypt(data: PassportNo))
    }
    
    class func getPassportNo() -> String? {
        return encryptionHandler.getDataDecrypt(data: toString(self.load(service: _passportNo)))
    }
    
    class func deletePassportNo() {
        self.delete(service: _passportNo)
    }
    
    class func setTokenFirebase(TokenFirebase: String) {
        self.save(service: _tokenFirebase, data: encryptionHandler.getDataEncrypt(data: TokenFirebase))
    }
    
    class func getTokenFirebase() -> String? {
        return encryptionHandler.getDataDecrypt(data: toString(self.load(service: _tokenFirebase)))
    }
    
    class func deleteTokenFirebase() {
        self.delete(service: _tokenFirebase)
    }
    
//    static func clearKeyChainWhenLogout() {
//        self.deleteTouristId()
//        self.deleteCardId()
//        self.deleteRefreshToken()
//        self.deleteAccessToken()
//        self.deletePassportNo()
//        self.deletePIN()
//        self.deleteTokenFirebase()
//    }
    
    private class func delete(service: String) {
        // Instantiate a new default keychain query
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, DataRepoKeyChain], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue])
        
        // Delete any existing items
        SecItemDelete(keychainQuery as CFDictionary)
    }
    
    private class func save(service: String, data: String) {
        let dataFromString: Data = data.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue), allowLossyConversion: false)!
        
        // Instantiate a new default keychain query
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, DataRepoKeyChain, dataFromString], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])
        
        // Delete any existing items
        SecItemDelete(keychainQuery as CFDictionary)
        
        // Add the new keychain item
        SecItemAdd(keychainQuery as CFDictionary, nil)
    }
    
    private class func load(service: String) -> String? {
        // Instantiate a new default keychain query
        // Tell the query to return a result
        // Limit our results to one item
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, DataRepoKeyChain, kCFBooleanTrue!, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
        
        var dataTypeRef: AnyObject?
        
        // Search for the keychain items
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var contentsOfKeychain: NSString? = nil
        
        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? NSData {
                contentsOfKeychain = NSString(data: retrievedData as Data, encoding: String.Encoding.utf8.rawValue)
            }
        } else {
            //print("Nothing was retrieved from the keychain. Status code \(status)")
        }
        
        return contentsOfKeychain as String?
    }
    
}

