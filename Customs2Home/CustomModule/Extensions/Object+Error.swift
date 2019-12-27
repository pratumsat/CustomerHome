//
//  Object+Error.swift
//  VRT Mobile
//
//  Created by Wittawas Mukdaprasert on 31/7/2562 BE.
//  Copyright © 2562 Kemin Suenggittawisuthi. All rights reserved.
//

import Foundation

@inlinable func printBlue( _ items: Any... )  {
    rePrint(symbol: "💙", items)
}
@inlinable func printRed( _ items: Any... )  {
    rePrint(symbol: "❤️", items)
}
@inlinable func printYellow( _ items: Any... )  {
    rePrint(symbol: "💛", items)
}
@inlinable func printGreen( _ items: Any... )  {
    rePrint(symbol: "💚", items)
}

@inlinable func debugError( _ items: Any... )  {
    rePrint(symbol: "❌", items)
}

@inlinable func printKhem( _ items: Any... )  {
    rePrint(symbol: "❗️❗️📣📣🤫🤭☠️👻", items)
}

@inlinable func rePrint( symbol:String ,  _ items: [Any]   )  {
    print(symbol+" ", separator:"", terminator:"")
    for item in items {
        print(item, separator:"", terminator:"")
        print(" ", separator:"", terminator:"")
    }
    print("")
}
