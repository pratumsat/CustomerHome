//
//  UserDefaultService.swift
//  VRT Mobile
//
//  Created by Kemin Suenggittawisuthi on 20/6/2562 BE.
//  Copyright © 2562 Kemin Suenggittawisuthi. All rights reserved.
//

import Foundation
import ObjectMapper

public class UserDefaultService {
    
    public static func setMerchantModel(value: AnyObject) {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: value)
        UserDefaults.standard.set(encodedData, forKey: "merchantModel")
    }
    
    public static func getMerchantModel() -> AnyObject? {
        guard let merchantModel = UserDefaults.standard.object(forKey: "merchantModel") as? Data else { return nil }
        let decodeData = NSKeyedUnarchiver.unarchiveObject(with: merchantModel )
        return decodeData as AnyObject
    }
    
    // MARK: Province Version
    class func setProvinceVersion(date: String) {
         UserDefaults.standard.set(date, forKey: "province")
    }
    
    class func clearProvinceVersion(date: String) {
        UserDefaults.standard.removeObject(forKey: "province")
    }
    
    class var getProvinceVersion: String? {
        return UserDefaults.standard.string(forKey: "province")
    }
    
    // MARK: tariff Version
    class func setTariffVersion(date: String) {
        UserDefaults.standard.set(date, forKey: "tariff")
    }
    
    class func clearTariffVersion(date: String) {
        UserDefaults.standard.removeObject(forKey: "tariff")
    }
    
    class var getTariffVersion: String? {
        return UserDefaults.standard.string(forKey: "tariff")
    }
    
    // MARK: Exchangerate Version
    
    class func setExchangeRateVersion(date: String) {
        UserDefaults.standard.set(date, forKey: "exchangerate")
    }
    
    class func clearExchangeRateVersion(date: String) {
        UserDefaults.standard.removeObject(forKey: "exchangerate")
    }
    
    class var getExchangeRateVersion: String? {
        return UserDefaults.standard.string(forKey: "exchangerate")
    }
    
    
    public static func clearMerchantModel() {
        UserDefaults.standard.removeObject(forKey: "merchantModel")
    }
    
    public static func clearMerchantId() {
        UserDefaults.standard.removeObject(forKey: "merchantId")
    }
    
    public static func saveMerchantId(merchantId: String) {
        UserDefaults.standard.set(merchantId, forKey: "merchantId")
    }
    
    public static func getMerchantId() -> String? {
        return UserDefaults.standard.string(forKey: "merchantId")
    }
    
    public static func setMerchantOwnerFlag(ownerFlag: String) {
        UserDefaults.standard.set(ownerFlag, forKey: "ownerFlag")
    }
    
    public static func getMerchantOwnerFlag() -> String? {
        return UserDefaults.standard.string(forKey: "ownerFlag")
    }
    
    public static func clearMerchantOwnerFlag() {
        UserDefaults.standard.removeObject(forKey: "ownerFlag")
    }
    // MARK: - AppVersion
    
    public static func saveTimeStampAppVersion(timestamp: UInt64) {
        UserDefaults.standard.set(timestamp, forKey: "timestampAppVersion")
    }
    
    public static func clearTimeStampAppVersion() {
        UserDefaults.standard.removeObject(forKey: "timestampAppVersion")
    }
    
    public static func getTimeStampAppVersion() -> UInt64? {
        guard let storedTimestamp = UserDefaults.standard.object(forKey: "timestampAppVersion") else { return nil }
        guard let timestamp = storedTimestamp as? UInt64 else { return nil }
        return timestamp
    }
    
    // MARK: - Promptpay
    
    public static func saveTimeStampPromptpay(timestamp: UInt64) {
        UserDefaults.standard.set(timestamp, forKey: "timestampPromptpay")
    }
    
    public static func clearTimeStampPromptpay() {
        UserDefaults.standard.removeObject(forKey: "timestampPromptpay")
    }
    
    public static func getTimeStampPromptpay() -> UInt64? {
        guard let storedTimestamp = UserDefaults.standard.object(forKey: "timestampPromptpay") else { return nil }
        guard let timestamp = storedTimestamp as? UInt64 else { return nil }
        return timestamp
    }
    
    // MARK: - FCMToken
    
    public static func saveTimeStampFCMToken(timestamp: UInt64) {
        UserDefaults.standard.set(timestamp, forKey: "timestampFCMToken")
    }
    
    public static func clearTimeStampFCMToken() {
        UserDefaults.standard.removeObject(forKey: "timestampFCMToken")
    }
    
    public static func getTimeStampFCMToken() -> UInt64? {
        guard let storedTimestamp = UserDefaults.standard.object(forKey: "timestampFCMToken") else { return nil }
        guard let timestamp = storedTimestamp as? UInt64 else { return nil }
        return timestamp
    }
    
    // MARK: - PersonalAccessInfo
    
    public static func saveTimeStampPersonalAccessInfo(timestamp: UInt64) {
        UserDefaults.standard.set(timestamp, forKey: "timestampPersonalAccessInfo")
    }
    
    public static func clearTimeStampPersonalAccessInfo() {
        UserDefaults.standard.removeObject(forKey: "timestampPersonalAccessInfo")
    }
    
    public static func getTimeStampPersonalAccessInfo() -> UInt64? {
        guard let storedTimestamp = UserDefaults.standard.object(forKey: "timestampPersonalAccessInfo") else { return nil }
        guard let timestamp = storedTimestamp as? UInt64 else { return nil }
        return timestamp
    }
    
    // MARK: - APP ID
    public static func saveAppId() {
        let appId = GeneratorRandomComponent().randomString(defaultLength: 56)
        UserDefaults.standard.set(appId, forKey: "appId")
    }
    
    public static func clearAppId() {
        UserDefaults.standard.removeObject(forKey: "appId")
    }
    
    public static func getAppId() -> String? {
        return UserDefaults.standard.string(forKey: "appId")
    }
    
    // MARK: - OTP Request Timestamp
    
    public static func setRequestOTPTimestamp(userId: UInt64)  {
        UserDefaults.standard.set(userId, forKey: "RequestOTPTimestamp")
    }
    
    public static func setRequestOTPTimestampMerchant(userId: UInt64)  {
        UserDefaults.standard.set(userId, forKey: "RequestOTPTimestampMerchant")
    }
    
    public static func clearRequestOTPTimestamp()  {
        UserDefaults.standard.removeObject(forKey: "RequestOTPTimestamp")
    }
    
    public static func getRequestOTPTimestamp() -> UInt64? {
        guard let time = UserDefaults.standard.string(forKey: "RequestOTPTimestamp") else {
            return nil
        }
        return UInt64(time)
    }
    
    public static func getRequestOTPTimestampMerchant() -> UInt64? {
        guard let time = UserDefaults.standard.string(forKey: "RequestOTPTimestampMerchant") else {
            return nil
        }
        return UInt64(time)
    }
    
    public static func clearRequestOTPTimestampMerchant() {
        UserDefaults.standard.removeObject(forKey: "RequestOTPTimestampMerchant")
    }
    // MARK: - Login pin Timestamp
    public static func setLoginPinTimestamp(userId: UInt64) {
        UserDefaults.standard.set(userId, forKey: "LoginPinTimestamp")
    }
    
    public static func clearLoginPinTimestamp() {
        UserDefaults.standard.removeObject(forKey: "LoginPinTimestamp")
    }
    
    public static func getLoginPinTimestamp() -> UInt64?{
        guard let time = UserDefaults.standard.string(forKey: "LoginPinTimestamp") else {
            return nil
        }
        return UInt64(time)
    }
    
    // MARK: - Language
    
    public static func setLang(_ lang: String)  {
        UserDefaults.standard.set(lang, forKey: "lang")
    }
    
    public static func clearLang()  {
        UserDefaults.standard.removeObject(forKey: "lang")
    }
    
    public static func getLang() -> String? {
        guard let lang = UserDefaults.standard.string(forKey: "lang") else {
            return Locale.current.languageCode
        }
        return lang
    }
    
    // MARK: - User Logout/Login flag
    
    public static func setLoginFlag(_ isLogin: Bool) {
        UserDefaults.standard.set(isLogin, forKey: "loginFlag")
    }
    
    public static func clearLoginFlag() {
        UserDefaults.standard.removeObject(forKey: "loginFlag")
    }
    
    public static func isLogin() -> Bool {
        return UserDefaults.standard.bool(forKey: "loginFlag")
    }
    
    public static func clearUserDefaultWhenLogout() {
        clearLoginFlag()
        clearMerchantId()
        clearTimeStampFCMToken()
        clearTimeStampPromptpay()
        clearTimeStampAppVersion()
        clearTimeStampPersonalAccessInfo()
        clearRequestOTPTimestamp()
        clearLoginPinTimestamp()
        clearMerchantOwnerFlag()
        clearRequestOTPTimestampMerchant()
    }
}

//MARK: - Utilities
public extension UserDefaultService {
    public static func hasTutorialFlag(key: String) -> Bool {
        if let _ = UserDefaults.standard.object(forKey: key) {
            return UserDefaults.standard.bool(forKey: key)
        } else {
            return false
        }
    }
    
    
    public static func stampTutorialFlag(key: String) {
        UserDefaults.standard.set(true, forKey: key)
    }
}

