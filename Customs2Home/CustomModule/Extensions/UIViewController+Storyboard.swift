//
//  UIView+Nib.swift
//  VRT Mobile
//
//  Created by Wittawas Mukdaprasert on 10/7/2562 BE.
//  Copyright © 2562 Kemin Suenggittawisuthi. All rights reserved.
//

import UIKit
extension UIViewController {
    static func loadStory(storyboardName:String,identifier:String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
    func loadStory(identifier:String) -> UIViewController? {
        return self.storyboard?.instantiateViewController(withIdentifier: identifier)
    }
    
    //How to use
    //        presentAlertWithTitle(title: "Test", message: "A message", options: "1", "2") { (option) in
    //            print("option: \(option)")
    //            switch(option) {
    //            case 0:
    //                print("option one")
    //                break
    //            case 1:
    //                print("option two")
    //            default:
    //                break
    //            }
    //        }
    // vvvvvvvv
    
    func presentAlertWithTitle(title: String, message: String, options: String..., completion: @escaping (Int) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, option) in options.enumerated() {
            alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                completion(index)
            }))
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alert(message: String, title: String = "" , perform:(()->Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: {  _ in
            perform?()
        })
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func initStepView4(mainView: UIView, label1: UIColor, label2: UIColor, label3: UIColor, label4: UIColor, viewLeft: UIColor,viewCenter: UIColor,viewRight: UIColor ) {
        let stepView4 = UIView.loadNib(name: "StepView4")?.first as! StepView4ViewController
        stepView4.frame = mainView.frame
        stepView4.viewLeft.backgroundColor = viewLeft
        stepView4.viewCenter.backgroundColor = viewCenter
        stepView4.viewRight.backgroundColor = viewRight
        stepView4.label1.backgroundColor = label1
        stepView4.label2.backgroundColor = label2
        stepView4.label3.backgroundColor = label3
        stepView4.label4.backgroundColor = label4
        mainView.addSubview(stepView4)
    }
    
    func appTitleLabelAndNavigationDelegate(view: UIViewController) {
        self.navigationController?.delegate = view as? UINavigationControllerDelegate
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.mainFontSemiBold(ofSize: 18)]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.mainFontSemiBold(ofSize: 24)]
    }
    
}
