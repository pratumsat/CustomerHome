//
//  FAQViewCell.swift
//  Customs2Home
//
//  Created by thanawat on 10/30/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit
import WebKit
import RxCocoa
import RxSwift
import RxWebKit

class FAQViewCell: UIView {

    @IBOutlet weak var expandHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var expandImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var wkWebView: WKWebView!
    @IBOutlet weak var expandableView: UIView!
    let disposeBag = DisposeBag()
    
    var faqRelay = BehaviorRelay<FaqResp?>(value: nil)
    
    override func awakeFromNib() {
        faqRelay.filter({ $0 != nil })
            .map({ (faqResp) -> String in
                let font = UIFont.mainFontSemiBold(ofSize: 40)
                
                let htmlString = """
                                <style>
                                @font-face
                                {
                                font-family: 'Prompt';
                                font-weight: normal;
                                src: url(Prompt-Regular.ttf);
                                }
                                </style>
                                <span style="font-family: '\(font.familyName)'; font-size: \(font.pointSize);">\(faqResp!.faqAnswer!)</span>
                                """
                return htmlString
            })
            .bind(onNext: {[unowned self] (htmlString) in
                UIView.animate(withDuration: 0.25, animations: {
                    let expandable = self.expandableView.isHidden
                    
                    
                    
                    self.expandableView.isHidden = !expandable
                    self.expandImageView.image =  !expandable ? UIImage(named: "icnArrowDown")! : UIImage(named: "icnArrowUp")!
                    
                  
                    if expandable {
                       self.wkWebView.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL)
                    }
                })
                
            }).disposed(by: disposeBag)
        
        wkWebView.rx
            .didFinishNavigation
            .map({ (action) -> CGSize in
                return action.webView.scrollView.contentSize
            })
            .bind(onNext: { [unowned self] (contentSize) in
                self.expandHeightConstraint.constant = contentSize.height
            })
            .disposed(by: disposeBag)
    }
    
    
    func bind(_ faqResp:FaqResp){
        titleLabel.attributedText = faqResp.faqQuestion?.htmlAttributed(using: UIFont.mainFontlight(ofSize: 14.0))
        expandButton.rx.tap.map( { faqResp }).bind(to: faqRelay).disposed(by: disposeBag)

    }
}
