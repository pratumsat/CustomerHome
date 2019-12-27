//
//  UIDeviceExtension.swift
//  KPayCustomer
//
//  Created by Piyawut on 12/22/2560 BE.
//  Copyright © 2560 KTB. All rights reserved.
//

import Foundation
import UIKit
extension UIDevice {
  static private let pathEArray = ["/private/var/lib/apt", // file existing
    "/Applications/Cydia.app",
    "/Library/MobileSubstrate/MobileSubstrate.dylib",
    "/bin/bash",
    "/usr/sbin/sshd",
    "/usr/bin/ssh",
    "/etc/apt",
    "/electra/libjailbreak.dylib",
    "/Applications/Flex.app",
    "/Applications/Sileo.app",
    "/Library/Frameworks/CydiaSubstrate.framework",
    "/electra",
    "/Applications/RockApp.app",
    "/Applications/Icy.app",
    "/Applications/WinterBoard.app",
    "/Applications/SBSettings.app",
    "/Applications/MxTube.app",
    "/Applications/IntelliScreen.app",
    "/Applications/FakeCarrier.app",
    "/Applications/blackra1n.app",
    "/Applications/IntelliScreen.app",
    "/Applications/FakeCarrier.app",
    "/var/mobile/Library/Sileo/sileo.sqlite3",
    "/var/mobile/Library/Cydia/metadata.cb0",
    "eletra"]
  
  static private let pathOArray = ["cydia://package/com.example.package"] // can open scheme
  
  static private let pathCOArray = ["/Applications/Cydia.app", // can open app
    "/Library/MobileSubstrate/MobileSubstrate.dylib",
    "/bin/bash",
    "/usr/sbin/sshd",
    "/usr/bin/ssh",
    "/etc/apt",
    "/Applications/Flex.app",
    "/Applications/Sileo.app",
    "/Library/Frameworks/CydiaSubstrate.framework",
    "/Applications/RockApp.app",
    "/Applications/Icy.app",
    "/Applications/WinterBoard.app",
    "/Applications/SBSettings.app",
    "/Applications/MxTube.app",
    "/Applications/IntelliScreen.app",
    "/Applications/FakeCarrier.app",
    "/Applications/blackra1n.app",
    "/Applications/IntelliScreen.app",
    "/Applications/FakeCarrier.app",
    "/var/mobile/Library/Sileo/sileo.sqlite3",
    "/var/mobile/Library/Cydia/metadata.cb0",
    "eletra"]
  
  static private let tweakPath = [ // can open tweak
    "/Library//zzzzLiberty.dylib",
    "/Library//SSLKillSwitch2.dylib",   // disable SSL certificate validation
    "/Library//tsProtector.dylib",
    "/electra/libjailbreak.dylib"]  // bypass jailbreak
  
  
  
  
  func isJailbreak() -> Bool {
    #if arch(i386) || arch(x86_64)
    return false
    #else
    if UIDevice.setupFirstState() ||
      UIDevice.setupSecondState() {
      return true
    }
    
    if UIDevice.canWriteFile() {
      return true
    }
    
    return false
    #endif
  }
  
  static private func canWriteFile() -> Bool {
    var canWrite = true
    let testWriteText = "Jailbreak test"
    let testWritePath = "/private/jailbreaktest.txt"
    do {
      try testWriteText.write(toFile: testWritePath, atomically: true, encoding: String.Encoding.utf8)
    } catch {
      canWrite = false
    }
    
    do {
      try FileManager.default.removeItem(atPath: testWritePath)
    } catch {
      
    }
    return canWrite
  }
  
  static private func setupFirstState() -> Bool {
    let fileManager = FileManager.default
    for path in pathEArray {
      if fileManager.fileExists(atPath: path) {
        return true
      }
    }
    
    for path in pathOArray {
      guard let url = URL(string: path) else { continue }
      
      if UIApplication.shared.canOpenURL(url) {
        return true
      }
    }
    //
    for path in pathCOArray {
      if canOpen(path: path) {
        return true
      }
    }
    
    // Check TweakInject
    if fileManager.fileExists(atPath: "/Library/TweakInject/") {
      return true
    }
    
    for path in tweakPath {
      if canOpen(path: path) {
        return true
      }
    }
    
    return false
  }
  
  static private func setupSecondState() -> Bool {
    do {
      let path = "/private/" + NSUUID().uuidString
      let fileManager = FileManager.default
      try "Trying".write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
      try fileManager.removeItem(atPath: path)
      return true
    } catch {
      return false
    }
  }
  
  private static func canOpen(path: String) -> Bool {
    let file = fopen(path, "r")
    guard file != nil else { return false }
    fclose(file)
    return true
  }
  
  func isIPhoneX() -> Bool {
    return userInterfaceIdiom == .phone
      && UIScreen.main.nativeBounds.height == 2436
  }
  
  func isIPhoneXPlus() -> Bool {
    return userInterfaceIdiom == .phone
      && UIScreen.main.nativeBounds.height == 2688
  }
  
  func isIphone5() -> Bool {
    return userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 1136
  }
  
  func isIphone5OrUnder() -> Bool {
    return userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height <= 1136
  }
}
