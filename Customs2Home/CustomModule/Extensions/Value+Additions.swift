//
//  Value+Additions.swift
//  VRT Mobile
//
//  Created by Wittawas Mukdaprasert on 16/8/2562 BE.
//  Copyright © 2562 Kemin Suenggittawisuthi. All rights reserved.
//
import UIKit
import Foundation

@inlinable func toString( _ value: Int?, _ nullValue:String = "") ->String  {
    if let value = value
    {
        return String(value)
    }
    else {
        return nullValue
    }
}

@inlinable func toString( _ value: Double?, _ nullValue:String = "") ->String  {
    if let value = value
    {
        return String(value)
    }
    else {
        return nullValue
    }
}

@inlinable func toString( _ value: String?,_ nullValue:String = "") ->String  {
    if let value = value
    {
        return value
    }
    else {
        return nullValue
    }
}

@inlinable func toInt( _ value: Int?,_ nullValue:Int = 0) ->Int  {
    if let value = value
    {
        return value
    }
    else {
        return nullValue
    }
}

@inlinable func toInt( _ value: String?,_ nullValue:Int = 0) ->Int  {
    if let value = value
    {
        return Int(value) ?? nullValue
    }
    else {
        return nullValue
    }
}

@inlinable func toDouble( _ value: String?,_ nullValue:Double = 0.0) ->Double  {
    if let value = value
    {
        return Double(value) ?? nullValue
    }
    else {
        return nullValue
    }
}

@inlinable func toFloat( _ value: String?,_ nullValue:Float = 0.0) ->Float  {
    if let value = value
    {
        return Float(value) ?? nullValue
    }
    else {
        return nullValue
    }
}

@inlinable func toNumber( _ value: String?, _ nullValue:Float = 0.0) ->NSNumber  {
    return NSNumber( value: toFloat(value,nullValue) )
}
@inlinable func toNumber( _ value: Int?, _ nullValue:Int = 0) ->NSNumber  {
    return NSNumber( value: toInt(value,nullValue) )
}

@inlinable func toCurrency( _ value: Double?, _ nullValue:Double = 0.0) ->String  {
    let nf = NumberFormatter()
    nf.groupingSeparator = ","
    nf.minimumFractionDigits = 2
    nf.numberStyle = .decimal
    let number = NSNumber( value: value ?? nullValue )
    return nf.string(from: number) ?? "N/A"
}

@inlinable func toCurrency( _ value: String?, _ nullValue:Double = 0.0) ->String  {
    let nf = NumberFormatter()
    nf.groupingSeparator = ","
    nf.minimumFractionDigits = 2
    nf.numberStyle = .decimal
    let number = toNumber( value, Float(nullValue) )
    return nf.string(from: number) ?? "N/A"
}
