//
//  OfflineMode.swift
//  Customs2Home
//
//  Created by Wittawas Mukdaprasert on 10/10/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import RxSwift
import RxAlamofire

// Disclaimer
// This path is use for debug only by activate define flag "OFFLINE" in build phase
// there are not compile in release product
#if OFFLINE
func backupCacheData(data:(HTTPURLResponse, String))
{
    guard let path = Environment.variable(named: "CACHE_DIR"),
        let lastPath = data.0.url?.lastPathComponent
        else { return }
    if data.0.allHeaderFields["loadBackupData"] != nil { return }
    FileManagerAsset.mkdir(path:  NSString(string: path) )
    let filePath = NSString( string: lastPath).appendingPathExtension("json")!
    let fullPath =  NSString( string: path).appendingPathComponent(filePath)
    let _ = try? data.1.write(to: URL(fileURLWithPath: fullPath)  , atomically: true, encoding:String.Encoding.utf8)
}

func loadBackupData<T> (request:URLRequestConvertible, requestObservable:Observable<T>) -> Observable<T>
{
    guard let path = Environment.variable(named: "CACHE_DIR"),
        let lastPath = request.urlRequest?.url?.lastPathComponent
        else { return  Observable.error( KError.undefind)  }
    let fullPath = NSString( string: path).appendingPathComponent( lastPath+".json" )
    let result = Observable.just(fullPath)
        .map( { try String(contentsOfFile: $0 ) } )
        .map({  respond -> (T) in
            let url = try fullPath.asURL()
            let header = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: ["loadBackupData":"true"])!
            return ( header,respond ) as! (T)
        })
    return result
}

#else

func backupCacheDataForSomeService(data:(HTTPURLResponse, String))
{
    guard let path = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false),
        let lastPath = data.0.url?.lastPathComponent
        else { return }
    if data.0.allHeaderFields["loadBackupData"] != nil { return }
    let filePath1 = path.appendingPathComponent(lastPath)
    let filePath = filePath1.appendingPathExtension("json")
    let _ = try? data.1.write(to: filePath  , atomically: true, encoding:String.Encoding.utf8)
}

//func loadBackupDataCatchData<T> (request:URLRequestConvertible, requestObservable:Observable<T?>) -> Observable<T>
func loadBackupDataCatchData<T> (request:URLRequestConvertible) -> Observable<T>
{
    guard let path = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false),
        let lastPath = request.urlRequest?.url?.lastPathComponent
        else { return  Observable.error( KError.undefind)  }
    let fullPath = path.appendingPathComponent( lastPath+".json" )
    let result = Observable.just(fullPath)
        .map({ try String(contentsOf: $0 ) })
        .map({  respond -> (T) in
            let url = try fullPath.asURL()
            let header = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: ["loadBackupData":"true"])!
            return ( header,respond ) as! (T)
        })
    return result
}

#endif
