//
//  UIScrollView+Keyboard.swift
//  VRT Mobile
//
//  Created by Wittawas Mukdaprasert on 12/7/2562 BE.
//  Copyright © 2562 Kemin Suenggittawisuthi. All rights reserved.
//

import UIKit
extension UIScrollView {
    func registKeyboardNotification()
    {
        
        NotificationCenter.default.addObserver(self, selector: #selector( self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector( self.keyboardWillHide ), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.registTapGesture()
    }
    
    
    func resignKeyboardNotification()
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification:Notification) {
        guard let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        var extendsHeight:CGFloat = 0
        if let window = self.window
        {
            let height = self.y + self.height
            let screenHeight = window.screen.bounds.height
            extendsHeight = CGFloat(screenHeight - height)
        }
        
        self.contentInset.bottom = endFrame.height - extendsHeight
        self.scrollIndicatorInsets.bottom = self.contentInset.bottom
    }
    
    @objc func keyboardWillHide(notification:Notification) {
//        printRed( self.contentInset )
        self.contentInset.bottom = 0
        self.scrollIndicatorInsets.bottom = self.contentInset.bottom
    }
    
    func registTapGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap);
    }
    
    @objc private func hideKeyboard(gesture: UITapGestureRecognizer){
        self.endEditing(true);
    }
    
}
