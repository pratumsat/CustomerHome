//
//  AdvFile.swift
//  FaceCameraSwift
//
//  Created by admin on 2/26/18.
//  Copyright © 2018 M. All rights reserved.
//

import Foundation

class FileManagerAsset {
    static func mkdir(path:NSString)  {
        do {
            let fm:FileManager = FileManager.default
            try fm.createDirectory(atPath: String(path), withIntermediateDirectories: true, attributes: nil)
        } catch {
            printRed("mkdir \(error)")
        }
    }
    static func move(path:NSString,newPath:NSString) throws {
        do {
            let fm:FileManager = FileManager.default
            try fm.moveItem(atPath: String(path), toPath: String(newPath) )
        } catch {
            printRed("move \(error)")
        }
    }
    static func rm(path:NSString)
    {
        do {
            let fm:FileManager = FileManager.default
            try fm.removeItem(atPath: path as String)
        } catch {
            printRed("rm \(error)")
        }
    }
    
    static func getPath(_ dirPath:NSString,_ fileName:NSString) -> NSString {
        return dirPath.appendingPathComponent( (fileName as String) ) as NSString
    }
    
//    static func getSearchImagePath(path:NSString,_ fileName:NSString) -> NSString?
//    {
//        let fm = FileManager.default
//        var found:NSString? = nil
//        let anyImage:Array = ["jpg","png"];
//        do {
//            let list = try fm.contentsOfDirectory(atPath: path as String)
//
//            if let first = list.first(where: { (str) -> Bool in
//                if (str.hasPrefix(fileName as String))
//                {
//                    let pass = anyImage.first(where: { (ext) -> Bool in
//                        return (str as NSString).pathExtension.lowercased().hasPrefix(ext)
//                    })
//                    return pass != nil
//                }
//                else
//                {
//                    return false;
//                }
//            })
//            {
//                found = path.appendingPathComponent(first) as NSString;
//            }
//        } catch {
//            printRed("getSearchImagePath \(error)")
//        }
//        return found
//    }
}

struct Environment {
    static func variable(named name: String) -> String? {
        let processInfo = ProcessInfo.processInfo
        guard let value = processInfo.environment[name] else {
            return nil
        }
        return value
    }
}

func convenientLangCompair( interLang:String?,altLang:String? ) -> String?
{
//    switch UserDefaultService.getLang() {
//    case "th":
        return altLang
//    default:
//        return interLang
//    }
}
