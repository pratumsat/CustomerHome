//
//  PaymentCardViewController.swift
//  Customs2Home
//
//  Created by warodom on 14/11/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxAppState
import Alamofire
import ObjectMapper
import WebKit

class PaymentCardViewController: UIViewController, WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate {
    
    var disposeBag :DisposeBag?
    var webview: WKWebView!
    
    var declareId: Int = 0
    
    override func viewDidLoad() {
       
        let contentController = WKUserContentController()
        contentController.add(self, name: "callbackHandler")
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController = contentController
        webview = WKWebView(frame: .zero, configuration: webConfiguration)
    
//        let preferences = WKPreferences()
//        preferences.javaScriptEnabled = true
//        webview.configuration.preferences = preferences
//        webview.configuration.userContentController = contentController
        self.view = webview
        
        webview.uiDelegate = self
        webview.navigationDelegate = self
        
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "HI BACK", style: .done, target: self, action: nil)
    }
    func bind()  {
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        let viewModel = PaymentCardViewModel.instance()
        viewModel.viewControl = self
        let onload = Driver.just((declareId))

        let input = PaymentCardViewModel.Input( onLoadView: onload )

        let output = viewModel.transform(input: input)
        output.items?.map({ url in
           return self.webview.load(url!)
        }).drive().disposed(by: disposeBag )
        output.commonDispose.disposed(by: disposeBag)
        
        webview.rx.url.bind(onNext: { url in
            printYellow(url?.debugDescription)
        }).disposed(by: disposeBag)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: message,
                                                message: nil,
                                                preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "ตกลง", style: .cancel) {
            _ in completionHandler()}
        )
        
        self.present(alertController, animated: true, completion: nil)
    }
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
        let alertController = UIAlertController(title: message,
                                                message: nil,
                                                preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "ตกลง", style: .default) {
            _ in completionHandler(true)}
        )
        alertController.addAction(UIAlertAction(title: "ยกเลิก", style: .cancel) {
            _ in completionHandler(false)}
        )
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if (message.name == "callbackHandler"){
            printRed("\(message.body)")
           
            guard let message = message.body as? String else { return }
            guard message.lowercased() == "close" else { return }
            
            self.dismiss(animated: true, completion: {
                if let paymentnav = self.navigationController as? PaymentNav {
                    paymentnav.dismissCallback?()
                }
            })
        }
        
        
    }
    
    
    
}
