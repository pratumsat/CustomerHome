//
//  AlertDetailViewController.swift
//  Customs2Home
//
//  Created by thanawat on 12/23/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import RxAppState
import WebKit

class AlertDetailViewController: C2HViewcontroller {
    
    var disposeBag :DisposeBag?
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var webView: WKWebView!
    
    var msgId:Int?
    
    override func viewDidLoad() {
        bind()
    }
    func bind()  {
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        let viewModel = AlertDetailViewModel.instance()
        viewModel.viewControl = self
        
        let onload = Observable.just(toInt(msgId))
        
        let input = AlertDetailViewModel.Input( onLoadView: onload )
        
        let output = viewModel.transform(input: input)
        
        output.htmlString.bind(onNext: { [unowned self] (htmlString)in
            self.webView.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL)
        }).disposed(by: disposeBag)
        
        output.commonDispose.disposed(by: disposeBag)
        
        output.readMsg.bind { (read) in
            print("read success")
        }.disposed(by: disposeBag)
        
        output.commonDispose.disposed(by: disposeBag)
    }
    
}
