//
//  Error.swift
//  Customs2Home
//
//  Created by Wittawas Mukdaprasert on 2/9/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import Foundation

enum KError:Error {
    case commonError(message:String )
    case httpRespondError(_ respond:HTTPURLResponse)
    case httpServiceError(_ respond:BaseRespond)
    case httpError(_ urlError:URLError)
    case internalError( _ code:Int )
    case undefind
    
    var getMessage:KErrorMessage{
        switch self {
        case .commonError(let message):
            return KErrorMessage(message: message, errorCode: 0, debugMessage: nil)
        case .internalError(let code):
            return KErrorMessage(internalErrorCode: code)
        case .httpRespondError(let respond):
            return KErrorMessage( respondError: respond )
        case .httpServiceError(let respond):
            return KErrorMessage( serviceErrorRespond: respond)
        case .httpError(let respond):
            return KErrorMessage(message: respond.localizedDescription, errorCode: respond.errorCode, debugMessage: "error_html")
        default:
            return KErrorMessage(message: "undefind", errorCode: 0, debugMessage: nil)
        }
    }
}

struct KErrorMessage {
    var message:String?
    var errorCode:Int?
    var debugMessage:String?
    
    private var _codeString:String?
    var codeString: String? {
        set { _codeString = newValue }
        get {
            return _codeString == nil ? toString( errorCode,"No error code") : _codeString
        }
    }
    
    init( message: String?, errorCode: Int?, debugMessage: String? ) {
        self.message = message
        self.errorCode = errorCode
        self.debugMessage = debugMessage
        self.codeString = nil
    }
    
    func show()
    {
    }
}

extension KErrorMessage {
    init( respondError:HTTPURLResponse ) {
        self.message = respondError.description
        self.errorCode = respondError.statusCode
        self.debugMessage = respondError.debugDescription
    }
    
    init( serviceErrorRespond :BaseRespond ) {
        self.codeString = serviceErrorRespond.statusCd
        self.message = convenientLangCompair(interLang: serviceErrorRespond.statusDescEN  , altLang: serviceErrorRespond.statusDescTH)
        self.debugMessage = "Service_Error: " + "{\(toString(self.message))}"
    }
    
    
    init( internalErrorCode:Int ) {
        self.message = "internalError".localizable()
        self.errorCode = internalErrorCode
        switch internalErrorCode {
        case -2000:
            debugMessage = "Can't transform json to object mapper."
        case -2001:
            debugMessage = "Respond object is not integrate protocol \"BaseRespond\". That need to check internal error."
        case -2002:
            debugMessage = "Decrypt error for some reason."
        default:
            debugMessage = "No debugMessage case error ?.This is bad isn't it ? "
        }
    }
}

//Status Code
//Status Description (Thai)
//Status Description (English)
//00000
//สำเร็จ
//Successful
//V0001
//สกุลเงินไม่ถูกต้อง
//Invalid Currency Code
//V0002
//ไม่พบสกุลเงิน
//Not Found Currency Code
//V0003
//รหัสพิกัดศุลกากรไม่ถูกต้อง
//Invalid Tariff ID
//V0004
//ไม่พบพิกัดศุลกากร
//Not Found Tariff Name
//V0005
//ประเภทพิกัดศุลกากรไม่ถูกต้อง
//Not Found Category Name
//V0006
//ไม่พบ ประเภทพิกัดศุลกากร
//Not Found Category
//V0007
//ประเภทย่อยของพิกัดศุลกากรไม่ถูกต้อง
//Not Found Sub Category Name
//V0008
//ไม่พบ ประเภทย่อยของพิกัดศุลกากร
//Not Found Sub Category
//V0009
//ไม่พบ พิกัดศุลกากร
//Not Found Tariff
//D0001
//สินค้าที่สำแดงมีมูลค่ารวมเกินกว่าที่กำหนดไว้ ไม่สามารถทำรายการได้
//Unable to process, the total CIF is exceeding the limit
//D0002
//สินค้าที่สำแดงมีมูลค่าไม่เกิน 1,500  บาท ได้รับการยกเว้นไม่ต้องชำระอากรขาเข้า
//Tax and Duty Exemption, the total CIF is less than 1,500 baht
//D0003
