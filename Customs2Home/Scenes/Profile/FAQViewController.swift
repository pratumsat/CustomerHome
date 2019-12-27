//
//  FAQViewController.swift
//  Customs2Home
//
//  Created by thanawat on 10/16/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import RxAppState

class FAQViewController: C2HViewcontroller {
    
    
    var disposeBag :DisposeBag?
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        bind()
    }
    
    var lastIndex:Int {
        return self.stackView.arrangedSubviews.count - 1
    }
    
    func bind()  {
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        let viewModel = FAQViewModel.instance()
        viewModel.viewControl = self
        let onload = Driver.just(())

      
        
        let input = FAQViewModel.Input( onLoadView: onload )


        let output = viewModel.transform(input: input)
        output.items?.do(onNext: { [unowned self] (dic) in

            for (_, value) in dic.sorted(by: { $0.key < $1.key}) {
                self.addItemView(value)
            }

        }).drive().disposed(by: disposeBag)
        output.commonDispose.disposed(by: disposeBag)
        
    }
    func addItemView(_ faqResp:[FaqResp]){
        
        if let view = UIView.loadNib(name: "FAQHeaderViewCell")?.first as? FAQHeaderViewCell {
            view.bind(faqResp.first ?? nil)
            self.stackView.insertArrangedSubview(view, at: self.lastIndex)
        }
        faqResp.forEach { [unowned self] (faqResp) in
            if let view = UIView.loadNib(name: "FAQViewCell")?.first as? FAQViewCell {
                view.bind(faqResp)
                self.stackView.insertArrangedSubview(view, at: self.lastIndex)
            }
        }
        
    }
    
}
