//
//  String+Extensions.swift
//  VRT Mobile
//
//  Created by Kemin Suenggittawisuthi on 20/6/2562 BE.
//  Copyright © 2562 Kemin Suenggittawisuthi. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func htmlDecode() -> NSAttributedString? {
        if let data = self.data(using: String.Encoding.unicode, allowLossyConversion: true){
            let attrStr = try? NSAttributedString(data: data, options: [.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
            return attrStr
        }
        return nil
    }
    
    func htmlAttributed(using font: UIFont) -> NSAttributedString? {
        do {
            let htmlCSSString = "<style>" +
                "html *" +
                "{" +
                "font-size: \(font.pointSize)pt !important;" +
//                "color: #\(color.hexString!) !important;" +
                "font-family: \(font.familyName), Helvetica !important;" +
            "}</style> \(self)"
            
            guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
                return nil
            }
            
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }

    
    func toAttributedString(currency: String? = "") -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: "\(currency ?? "") \(self)")
        attributedString.addAttribute(.font, value: UIFont.mainFontRegular(ofSize: 12), range: NSRange(location: 0, length: 3))
        return attributedString
    }
    
    func toAttributed() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(.font, value: UIFont.mainFontRegular(ofSize: 12), range: NSRange(location: 0, length: self.count))
        return attributedString
    }
    
    func localizable() -> String {
        let lang = UserDefaultService.getLang() ?? "th"
        guard let pathResource = Bundle.main.path(forResource: lang, ofType: "lproj") else { return self }
        guard let bundle = Bundle(path: pathResource) else { return self }
        
        
        var result = NSLocalizedString(self, tableName: "Localizable", bundle: bundle, value: "", comment: "")
        guard result == self else { return result }
        
        result = NSLocalizedString(self, tableName: "Error", bundle: bundle, value: "", comment: "")
        guard result == self else { return result }
        
//        result = NSLocalizedString(self, tableName: "Rules", bundle: bundle, value: "", comment: "")
//        guard result == self else { return result }
//
//        result = NSLocalizedString(self, tableName: "StatusCodes", bundle: bundle, value: "", comment: "")
//        guard result == self else { return result }
//
//        result = NSLocalizedString(self, tableName: "ServiceErrors", bundle: bundle, value: "", comment: "")
//        guard result == self else { return result }
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
    
    func urlEncode() -> String? {
        let charset = CharacterSet(charactersIn: "!*'();@&=+$,?%#[] ").inverted
        return self.addingPercentEncoding(withAllowedCharacters: charset)
    }
    
    func translateToShowDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let newformatter = DateFormatter()
        newformatter.dateFormat = "dd MMM yyyy"
        guard let date = formatter.date(from: self) else { return "" }
        let value = newformatter.string(from: date)
        printKhem(value)
        return value
    }
    
    func translateToAPIDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let newformatter = DateFormatter()
        newformatter.dateFormat = "dd MMM yyyy"
        guard let date = newformatter.date(from: self) else { return "" }
        let value = formatter.string(from: date)
        printKhem(value)
        return value
    }
    
    func formatCardString(reverse: Bool = false) -> String {
        if self.replacingOccurrences(of: " ", with: "").count <= 19 {
            var formattedString = String()
            let normalizedString = self.replacingOccurrences(of: " ", with: "")
//            printRed(normalizedString)
            if reverse {
                formattedString = normalizedString
            } else {
                var idx = 0
                var character: Character
                while idx < normalizedString.count {
                    let index = normalizedString.index(normalizedString.startIndex, offsetBy: idx)
                    character = normalizedString[index]
                    
                    if idx != 0 && idx % 4 == 0 {
                        formattedString.append(" ")
                    }
                    
                    formattedString.append(character)
                    idx += 1
                }
            }
            printBlue(formattedString)
            return formattedString
        }
        return String(self.prefix(23))
    }
    
    func sha512() -> Data {
        return self.data(using: .utf8)!.sha512()
    }
    
    var thousandFormatted: String {
        guard !self.isEmpty else{ return  ""}
        let numberFormatter = NumberFormatter()
        let number = numberFormatter.number(from: self.splitComma) ?? 0
        numberFormatter.numberStyle = .decimal
        let string = numberFormatter.string(from: number)!
        return string
    }
    var splitComma:String {
        return replacingOccurrences(of: ",", with: "")
    }
    
    
    func DateToNewDateFormat(formatIn:String, formatOut: String, locale: Locale = Locale(identifier: "th_TH"), calendar: Calendar = Calendar(identifier: .buddhist)) -> String? {
        let dateFormat = DateFormatter()
        dateFormat.locale = locale
        dateFormat.calendar = calendar
        dateFormat.dateFormat = formatIn
        let date = dateFormat.date(from: self)
        return date?.DateToString(format: formatOut)
    }
    
}

