//
//  KTextField.swift
//  VRT Mobile
//
//  Created by Kemin Suenggittawisuthi on 24/6/2562 BE.
//  Copyright © 2562 Kemin Suenggittawisuthi. All rights reserved.
//

import UIKit
import Foundation
import RxCocoa
import RxSwift

public extension String {
    
    var isEmptyStr:Bool{
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces).isEmpty
    }
}

@IBDesignable
public class KTextField: UITextField {
    
    public enum FloatingDisplayStatus:Int{
        case always
        case never
        case defaults
    }
    
    public enum DTBorderStyle{
        case none
        case rounded
        case sqare
    }
    
    fileprivate var lblFloatPlaceholder:UILabel             = UILabel()
    fileprivate var lblError:UILabel                        = UILabel()
    
    fileprivate let paddingX:CGFloat                        = 5.0
    
    fileprivate let paddingHeight:CGFloat                   = 10.0
    
    public var dtLayer:CALayer                              = CALayer()
    public var floatPlaceholderColor:UIColor                = UIColor.black
    public var floatPlaceholderActiveColor:UIColor          = UIColor.black
    public var floatingLabelShowAnimationDuration           = 0.3
    
    
    var floatingDisplayStatus:FloatingDisplayStatus  = .defaults
    @IBInspectable
    public var floatingDisplayStatusAdapter:Int = FloatingDisplayStatus.defaults.rawValue {
        didSet {
            if let select = FloatingDisplayStatus(rawValue: floatingDisplayStatusAdapter) {
                floatingDisplayStatus = select
            }
        }
    }
    
    public var dtborderStyle:DTBorderStyle = .rounded{
        didSet{
            switch dtborderStyle {
            case .none:
                dtLayer.cornerRadius        = 0.0
                dtLayer.borderWidth         = 0.0
            case .rounded:
                dtLayer.cornerRadius        = 4.5
                dtLayer.borderWidth         = 0.5
                dtLayer.borderColor         = borderColor?.cgColor
            case .sqare:
                dtLayer.cornerRadius        = 0.0
                dtLayer.borderWidth         = 0.5
                dtLayer.borderColor         = borderColor?.cgColor
            }
        }
    }
    
    override public var isEnabled: Bool {
        didSet {
            if (self.isEnabled == false) {
                self.textColor = UIColor.light_blue_grey
                self.floatPlaceholderColor = UIColor.light_blue_grey
                self.floatPlaceholderActiveColor = UIColor.light_blue_grey
                self.placeholderColor = UIColor.light_blue_grey
                self.borderColor = UIColor.light_blue_grey
            } else {
                self.textColor = UIColor.charcoal_grey
                self.floatPlaceholderColor = UIColor.blue_grey
                self.floatPlaceholderActiveColor = UIColor.blue_grey
                self.placeholderColor = UIColor.blue_grey
                self.borderColor = UIColor.blue_grey
            }
        }
    }
    
    public var errorMessage:String = ""{
        didSet{ lblError.text = errorMessage }
    }
    
    public var animateFloatPlaceholder:Bool = true
    public var hideErrorWhenEditing:Bool   = true
    
    public var errorFont = UIFont.systemFont(ofSize: 10.0){
        didSet{ invalidateIntrinsicContentSize() }
    }
    
    public var floatPlaceholderFont = UIFont.systemFont(ofSize: 10.0){
        didSet{ invalidateIntrinsicContentSize() }
    }
    
    public var paddingYFloatLabel:CGFloat = 3.0{
        didSet{ invalidateIntrinsicContentSize() }
    }
    
    public var paddingYErrorLabel:CGFloat = 3.0{
        didSet{ invalidateIntrinsicContentSize() }
    }
    
    override var borderColor: UIColor?{
        didSet {
            dtLayer.borderColor = borderColor?.cgColor
        }
    }
    
//    @IBInspectable
//    public var borderColor:UIColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0){
//        didSet{ dtLayer.borderColor = borderColor.cgColor }
//    }
    
    public var canShowBorder:Bool = true{
        didSet{ dtLayer.isHidden = !canShowBorder }
    }
    
    public var placeholderColor:UIColor?{
        didSet{
            guard let color = placeholderColor else { return }
            attributedPlaceholder = NSAttributedString(string: placeholderFinal,
                                                       attributes: [NSAttributedString.Key.foregroundColor:color])
        }
    }
    
    fileprivate var kPaddingX:CGFloat {
        
        if let leftView = leftView {
            return leftView.frame.origin.x + leftView.bounds.size.width - paddingX
        }
        
        return paddingX
    }
    
    fileprivate var fontHeight:CGFloat{
        return ceil(font!.lineHeight)
    }
    
    fileprivate var dtLayerHeight:CGFloat{
        return showErrorLabel ? floor(bounds.height - lblError.bounds.size.height - paddingYErrorLabel) : bounds.height
    }
    
    fileprivate var floatLabelWidth:CGFloat{
        
        var width = bounds.size.width
        
        if let leftViewWidth = leftView?.bounds.size.width{
            width -= leftViewWidth
        }
        
        if let rightViewWidth = rightView?.bounds.size.width {
            width -= rightViewWidth
        }
        
        return width - (self.kPaddingX * 2)
    }
    
    fileprivate var placeholderFinal:String{
        if let attributed = attributedPlaceholder { return attributed.string }
        return placeholder ?? " "
    }
    
    fileprivate var isFloatLabelShowing:Bool = false
    
    fileprivate var showErrorLabel:Bool = false{
        didSet{
            
            guard showErrorLabel != oldValue else { return }
            
            guard showErrorLabel else {
                hideErrorMessage()
                return
            }
            
            guard !errorMessage.isEmptyStr else { return }
            showErrorMessage()
        }
    }
    
    override public var borderStyle: UITextField.BorderStyle{
        didSet{
            guard borderStyle != oldValue else { return }
            borderStyle = .none
        }
    }
    
    public override var textAlignment: NSTextAlignment{
        didSet{ setNeedsLayout() }
    }
    
    public override var text: String?{
        didSet{ self.textFieldTextChanged() }
    }
    
    override public var placeholder: String?{
        didSet{
            
            guard let color = placeholderColor else {
                lblFloatPlaceholder.text = placeholderFinal
                return
            }
            attributedPlaceholder = NSAttributedString(string: placeholderFinal,
                                                       attributes: [NSAttributedString.Key.foregroundColor:color])
        }
    }
    
    override public var attributedPlaceholder: NSAttributedString?{
        didSet{ lblFloatPlaceholder.text = placeholderFinal }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public func setErrorMsg(_ msg:String?)
    {
        self.hideError()
        if let value = msg
        {
            self.showError(message: value)
        }
    }
    
    public func showError(message:String? = nil) {
        if let msg = message { errorMessage = msg }
        showErrorLabel = true
    }
    
    public func hideError()  {
        showErrorLabel = false
    }
    
    
    fileprivate func commonInit() {
        
        dtborderStyle               = .rounded
        dtLayer.backgroundColor     = UIColor.clear.cgColor
        
        floatPlaceholderColor       = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        floatPlaceholderActiveColor = tintColor
        lblFloatPlaceholder.frame   = CGRect.zero
        lblFloatPlaceholder.alpha   = 0.0
        lblFloatPlaceholder.font    = floatPlaceholderFont
        lblFloatPlaceholder.text    = placeholderFinal
        
        addSubview(lblFloatPlaceholder)
        
        lblError.frame              = CGRect.zero
        lblError.font               = errorFont
        lblError.textColor          = UIColor.red
        lblError.numberOfLines      = 0
        lblError.isHidden           = true
        
        addTarget(self, action: #selector(textFieldTextChanged), for: .editingChanged)
        
        addSubview(lblError)
        
        layer.insertSublayer(dtLayer, at: 0)
    }
    
    fileprivate func showErrorMessage(){
        
        lblError.text = errorMessage
        lblError.isHidden = false
        let boundWithPadding = CGSize(width: bounds.width - (paddingX * 2), height: bounds.height)
        lblError.frame = CGRect(x: paddingX, y: 0, width: boundWithPadding.width, height: boundWithPadding.height)
        lblError.sizeToFit()
        
        invalidateIntrinsicContentSize()
    }
    
    func setErrorLabelAlignment() {
        var newFrame = lblError.frame
        
        if textAlignment == .right {
            newFrame.origin.x = bounds.width - paddingX - newFrame.size.width
        }else if textAlignment == .left{
            newFrame.origin.x = paddingX
        }else if textAlignment == .center{
            newFrame.origin.x = (bounds.width / 2.0) - (newFrame.size.width / 2.0)
        }else if textAlignment == .natural{
            
            if UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .rightToLeft{
                newFrame.origin.x = bounds.width - paddingX - newFrame.size.width
            }
        }
        
        lblError.frame = newFrame
    }
    
    func setFloatLabelAlignment() {
        var newFrame = lblFloatPlaceholder.frame
        
        if textAlignment == .right {
            newFrame.origin.x = bounds.width - paddingX - newFrame.size.width
        }else if textAlignment == .left{
            newFrame.origin.x = paddingX
        }else if textAlignment == .center{
            newFrame.origin.x = (bounds.width / 2.0) - (newFrame.size.width / 2.0)
        }else if textAlignment == .natural{
            
            if UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .rightToLeft{
                newFrame.origin.x = bounds.width - paddingX - newFrame.size.width
            }
            
        }
        
        lblFloatPlaceholder.frame = newFrame
    }
    
    fileprivate func hideErrorMessage(){
        lblError.text = ""
        lblError.isHidden = true
        lblError.frame = CGRect.zero
        invalidateIntrinsicContentSize()
    }
    
    fileprivate func showFloatingLabel(_ animated:Bool) {
        
        let animations:(()->()) = {
            self.lblFloatPlaceholder.alpha = 1.0
            self.lblFloatPlaceholder.frame = CGRect(x: self.lblFloatPlaceholder.frame.origin.x,
                                                    y: self.paddingYFloatLabel,
                                                    width: self.lblFloatPlaceholder.bounds.size.width,
                                                    height: self.lblFloatPlaceholder.bounds.size.height)
        }
        
        if animated && animateFloatPlaceholder {
            UIView.animate(withDuration: floatingLabelShowAnimationDuration,
                           delay: 0.0,
                           options: [.beginFromCurrentState,.curveEaseOut],
                           animations: animations){ status in
                            DispatchQueue.main.async {
                                self.layoutIfNeeded()
                            }
            }
        }else{
            animations()
        }
    }
    
    fileprivate func hideFlotingLabel(_ animated:Bool) {
        
        let animations:(()->()) = {
            self.lblFloatPlaceholder.alpha = 0.0
            self.lblFloatPlaceholder.frame = CGRect(x: self.lblFloatPlaceholder.frame.origin.x,
                                                    y: self.lblFloatPlaceholder.font.lineHeight,
                                                    width: self.lblFloatPlaceholder.bounds.size.width,
                                                    height: self.lblFloatPlaceholder.bounds.size.height)
        }
        
        if animated && animateFloatPlaceholder {
            UIView.animate(withDuration: floatingLabelShowAnimationDuration,
                           delay: 0.0,
                           options: [.beginFromCurrentState,.curveEaseOut],
                           animations: animations){ status in
                            DispatchQueue.main.async {
                                self.layoutIfNeeded()
                            }
            }
        }else{
            animations()
        }
    }
    
    fileprivate func insetRectForEmptyBounds(rect:CGRect) -> CGRect{
        let newX = kPaddingX
        guard showErrorLabel else { return CGRect(x: newX, y: 0, width: rect.width - newX - paddingX, height: rect.height) }
        
        let topInset = (rect.size.height - lblError.bounds.size.height - paddingYErrorLabel - fontHeight) / 2.0
        let textY = topInset - ((rect.height - fontHeight) / 2.0)
        
        return CGRect(x: newX, y: floor(textY), width: rect.size.width - newX - paddingX, height: rect.size.height)
    }
    
    fileprivate func insetRectForBounds(rect:CGRect) -> CGRect {
        
        guard let placeholderText = lblFloatPlaceholder.text,!placeholderText.isEmptyStr  else {
            return insetRectForEmptyBounds(rect: rect)
        }
        
        if floatingDisplayStatus == .never {
            return insetRectForEmptyBounds(rect: rect)
        }else{
            
            if let text = text,text.isEmptyStr && floatingDisplayStatus == .defaults {
                return insetRectForEmptyBounds(rect: rect)
            }else{
                let topInset = paddingYFloatLabel + lblFloatPlaceholder.bounds.size.height + (paddingHeight / 2.0)
                let textOriginalY = (rect.height - fontHeight) / 2.0
                var textY = topInset - textOriginalY
                
                if textY < 0 && !showErrorLabel { textY = topInset }
                let newX = kPaddingX
                return CGRect(x: newX, y: ceil(textY), width: rect.size.width - newX - paddingX, height: rect.height)
            }
        }
    }
    
    @objc fileprivate func textFieldTextChanged(){
        guard hideErrorWhenEditing && showErrorLabel else { return }
        showErrorLabel = false
    }
    
    override public var intrinsicContentSize: CGSize{
        self.layoutIfNeeded()
        
        let textFieldIntrinsicContentSize = super.intrinsicContentSize
        
        if showErrorLabel {
            lblFloatPlaceholder.sizeToFit()
            return CGSize(width: textFieldIntrinsicContentSize.width,
                          height: textFieldIntrinsicContentSize.height + paddingYFloatLabel + paddingYErrorLabel + lblFloatPlaceholder.bounds.size.height + lblError.bounds.size.height + paddingHeight)
        }else{
            return CGSize(width: textFieldIntrinsicContentSize.width,
                          height: textFieldIntrinsicContentSize.height + paddingYFloatLabel + lblFloatPlaceholder.bounds.size.height + paddingHeight)
        }
    }
    
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return insetRectForBounds(rect: rect)
    }
    
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return insetRectForBounds(rect: rect)
    }
    
    fileprivate func insetForSideView(forBounds bounds: CGRect) -> CGRect{
        var rect = bounds
        rect.origin.y = 0
        rect.size.height = dtLayerHeight
        return rect
    }
    
    override public func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.leftViewRect(forBounds: bounds)
        return insetForSideView(forBounds: rect)
    }
    
    override public func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= padding
        return insetForSideView(forBounds: rect)
    }
    
    override public func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.clearButtonRect(forBounds: bounds)
        rect.origin.y = (dtLayerHeight - rect.size.height) / 2
        return rect
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        dtLayer.frame = CGRect(x: bounds.origin.x,
                               y: bounds.origin.y,
                               width: bounds.width,
                               height: dtLayerHeight)
        CATransaction.commit()
        
        if showErrorLabel {
            
            var lblErrorFrame = lblError.frame
            lblErrorFrame.origin.y = dtLayer.frame.origin.y + dtLayer.frame.size.height + paddingYErrorLabel
            lblError.frame = lblErrorFrame
        }
        
        let floatingLabelSize = lblFloatPlaceholder.sizeThatFits(lblFloatPlaceholder.superview!.bounds.size)
        
        lblFloatPlaceholder.frame = CGRect(x: kPaddingX, y: lblFloatPlaceholder.frame.origin.y,
                                           width: floatingLabelSize.width,
                                           height: floatingLabelSize.height)
        
        setErrorLabelAlignment()
        setFloatLabelAlignment()
        lblFloatPlaceholder.textColor = isFirstResponder ? floatPlaceholderActiveColor : floatPlaceholderColor
        
        switch floatingDisplayStatus {
        case .never:
            hideFlotingLabel(isFirstResponder)
        case .always:
            showFloatingLabel(isFirstResponder)
        default:
            if let enteredText = text,!enteredText.isEmptyStr{
                showFloatingLabel(isFirstResponder)
            }else{
                hideFlotingLabel(isFirstResponder)
            }
        }
    }
    
    @IBInspectable var fieldImage: UIImage? = nil {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var padding: CGFloat = 10 {
        didSet {
            self.leftView = UIView(frame:  CGRect(x: 0, y: 0, width: padding, height: 0) )
            self.leftViewMode = .always
        }
    }
    @IBInspectable var color: UIColor = UIColor.gray {
        didSet {
            updateView()
        }
    }
    @IBInspectable var bottomColor: UIColor = UIColor.clear {
        didSet {
            if bottomColor == UIColor.clear {
                self.borderStyle = .roundedRect
            } else {
                self.borderStyle = .bezel
            }
            self.setNeedsDisplay()
        }
    }
    
    func updateView() {
        if let image = fieldImage {
            rightViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            rightView = imageView
        } else {
            rightViewMode = UITextField.ViewMode.never
            rightView = nil
        }
//        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 45))
//        mainView.layer.cornerRadius = 5
//
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 45))
//        view.backgroundColor = .clear
//        view.clipsToBounds = true
//        view.layer.cornerRadius = 5
//        mainView.addSubview(view)
//
//        let imageView = UIImageView(image: fieldImage)
//        imageView.contentMode = .scaleAspectFit
//        imageView.frame = CGRect(x: 12.0, y: 10.0, width: 24.0, height: 24.0)
//        view.addSubview(imageView)
//
//        rightViewMode = .always
//        rightView = mainView
    }
    
//    @IBInspectable
//    public var format: String {
//        get {
//            return objc_getAssociatedObject(self, &AssociatedKeys.format) as? String ?? ""
//        }
//        set {
//
//            let oldFormat = self.format
//            objc_setAssociatedObject(
//                self,
//                &AssociatedKeys.format,
//                newValue as NSString,
//                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
//            )
//
//            if self.text != nil && self.text!.count > 0{
//                formatChanged(oldFormat)
//            }
//
//        }
//    }
//    fileprivate var textSourceArray: [String] {
//        get {
//            return objc_getAssociatedObject(self, &AssociatedKeys.ld) as? [String] ?? []
//        }
//        set {
//            objc_setAssociatedObject(
//                self,
//                &AssociatedKeys.ld,
//                newValue as [NSString]?,
//                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
//            )
//        }
//    }
//
//    public func formatText(_ string:String)->Bool{
//        //string is the newest character to be added
//        if self.format != "" && self.text != nil{
//            let backspace = string == ""
//            var textFieldIndex = self.text!.count > 0 ? self.text!.count - 1 : -1
//            var textFieldArray = Array(self.text!)
//            let newStringArray = Array(string)
//            let formatArray = Array(self.format)
//            var newText = ""
//            if backspace == false{
//                textFieldArray = textFieldArray + newStringArray
//                for _ in newStringArray{
//                    if textSourceArray.count < formatArray.count{
//                        if String(formatArray[textSourceArray.count]).lowercased() == "x"{
//                            newText = newText + String(textFieldArray[textFieldIndex+1])
//                            textFieldIndex = textFieldIndex + 1
//                            textSourceArray.append("u")
//                        }
//                        else{
//                            while String(formatArray[textSourceArray.count]).lowercased() != "x"{
//                                if String(formatArray[textSourceArray.count]).lowercased() == "\\"{
//                                    newText = newText + "x"
//                                    textSourceArray.append("e")
//                                    textSourceArray.append("f")
//                                }
//                                else{
//                                    newText = newText + String(formatArray[textSourceArray.count])
//                                    textSourceArray.append("f")
//                                }
//                            }
//                            newText = newText + String(textFieldArray[textFieldIndex+1])
//                            textFieldIndex = textFieldIndex + 1
//                            textSourceArray.append("u")
//                        }
//
//                    }
//                    else if textFieldIndex < textFieldArray.count{
//                        newText = newText + String(textFieldArray[textFieldIndex+1])
//                        textFieldIndex = textFieldIndex + 1
//                    }
//                }
//                self.text = self.text! + newText
//                if self.text?.count == formatArray.count{
//                    NotificationCenter.default.post(name: Notification.Name(rawValue: "text.MoveNext.Format"), object: nil)
//                }
//                self.sendActions(for: .editingChanged)
//                return false
//            }
//            else{
//                if textSourceArray.count > 0 && textFieldArray.count <= formatArray.count{
//
//                    if textSourceArray.last! == "u"{
//                        textSourceArray.removeLast()
//                        textFieldArray.removeLast()
//                    }
//
//                    while textSourceArray.count > 0 && textSourceArray.last! != "u"{
//                        textSourceArray.removeLast()
//                        if textSourceArray.count > 0 && textSourceArray.last! != "e"{
//                            textFieldArray.removeLast()
//                        }
//                        else if textSourceArray.count == 0 && textFieldArray.count > 0{
//                            textFieldArray.removeLast()
//                        }
//
//                    }
//
//                }
//                else if textFieldArray.count > 0{
//                    textFieldArray.removeLast()
//                }
//
//                for ch in textFieldArray{
//                    newText = newText + String(ch)
//                }
//
//                self.text = newText
//                self.sendActions(for: .editingChanged)
//                return false
//            }
//        }
//
//        return true
//    }
//
//    fileprivate func formatChanged(_ oldFormat:String?){
//        var newText = ""
//        var enteredText = self.text
//        enteredText = getUserEnteredCharacters(oldFormat!)
//        textSourceArray = []
//        var formatIndex = 0
//        var enteredIndex = 0
//        let enteredArray = Array(enteredText!)
//        let formatArray = Array(self.format)
//        while enteredIndex < enteredArray.count && formatIndex < formatArray.count{
//            if String(formatArray[formatIndex]).lowercased() == "\\"{
//                textSourceArray.append("e")
//                textSourceArray.append("f")
//                newText = newText + "x"
//                formatIndex = formatIndex + 2
//            }
//            else if String(formatArray[formatIndex]).lowercased() == "x"{
//                newText = newText + String(enteredArray[enteredIndex])
//                enteredIndex = enteredIndex + 1
//                formatIndex = formatIndex + 1
//                textSourceArray.append("u")
//            }
//            else{
//                newText = newText + String(formatArray[formatIndex])
//                formatIndex = formatIndex + 1
//                textSourceArray.append("f")
//            }
//        }
//        while enteredIndex < enteredArray.count{
//            newText = newText + String(enteredArray[enteredIndex])
//            enteredIndex = enteredIndex + 1
//        }
//
//        self.text = newText
//
//
//    }
//
//    fileprivate func getUserEnteredCharacters(_ fromFormat:String) -> String{
//        if fromFormat == ""{
//            return self.text!
//        }
//        var enteredText = ""
//        let enteredArray = Array(self.text!)
//        var userEnteredIndices = [Int]()
//        let _ = textSourceArray.enumerated().filter{(index, element) in
//            if element == "u"{
//                userEnteredIndices.append(index)
//                return true
//            }
//            return false
//        }
//        for ent in userEnteredIndices{
//            let char = String(enteredArray[ent])
//            //print(char)
//            enteredText = enteredText + char
//        }
//        return enteredText
//    }
    
    // JumpOrder
    
    
}

extension Reactive where Base: KTextField {
    public var date: ControlProperty<String?> {
        return base.rx.controlProperty(editingEvents: UIControl.Event.editingDidEnd, getter: { (textField) in
            print("😙 getter ",textField.text)
            
            return textField.text // Api date
        }, setter: { (textField, newValue) in
            if newValue == nil {
                printKhem("😙 setter ",textField.text,newValue)
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd"
                let newformatter = DateFormatter()
                newformatter.dateFormat = "dd MMM yyyy"
                if let str = textField.text {
                    print("str",str)
                    if let date = formatter.date(from: str) {
                        let value = newformatter.string(from: date)
                        textField.text = value
                        print("new", newValue)
                        print("😙 setter ",textField.text,newValue)
                    } else {
                        print("date nil")
                    }
                } else {
                    print("textField nil")
                }
            } else {
                printRed("😙 setter ",textField.text,newValue)
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd"
                let newformatter = DateFormatter()
                newformatter.dateFormat = "dd MMM yyyy"
                if let str = newValue {
                    print("str",str)
                    if let date = formatter.date(from: str) {
                        let value = newformatter.string(from: date)
                        textField.text = value
                        print("new", newValue)
                        print("😙 setter ",textField.text,newValue)
                    } else {
//                        guard let date = newformatter.date(from: str)
//                        let value = newformatter.string(from: date)
                        
                        print("date nil")
                    }
                } else {
                    print("textField nil")
                }
            }
            
        })
    }
    
    public var date2: ControlProperty<String?> {
        return base.rx.controlProperty(editingEvents: UIControl.Event.valueChanged, getter: { (textField) in
            print("😙 getter ",textField.text)
            
            return textField.text // Api date
        }, setter: { (textField, newValue) in
            printKhem("😙 setter ",textField.text,newValue)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            let newformatter = DateFormatter()
            newformatter.dateFormat = "dd MMM yyyy"
            if let str = textField.text {
                print("str",str)
                if let date = formatter.date(from: str) {
                    let value = newformatter.string(from: date)
                    textField.text = value
                    print("new", newValue)
                    print("😙 setter ",textField.text,newValue)
                } else {
                    print("date nil")
                }
            } else {
                print("textField nil")
            }
        })
    }
}
