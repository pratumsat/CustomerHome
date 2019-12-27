//
//  TaxFormViewController.swift
//  Customs2Home
//
//  Created by Wittawas Mukdaprasert on 4/9/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import RxAppState

class TaxFormViewController: UIViewController {
    
    var disposeBag :DisposeBag?
    @IBOutlet weak var registButton:UIButton!
    @IBOutlet weak var moreButton:UISwitch!
    @IBOutlet weak var moreItemView:UIView!
    @IBOutlet weak var searchFormView:UIView!
    
    
    
    override func viewDidLoad() {
        self.showTransferForm = false
        self.showAdvanceSearch = false
        bind()
    }
    
    deinit {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func bind()  {
        
        
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        let viewModel = TaxFormViewModel.instance()
        viewModel.viewControl = self
        let onload = Driver.just(())

        let input = TaxFormViewModel.Input( onLoadView: onload,
                                            onRegist: registButton.rx.tap.asDriver() )
        
        let output = viewModel.transform(input: input)
        let form = self.view as? FormView
        form?.bind(model: viewModel.taxRegistFormModel!).disposed(by: disposeBag)
        
        output.commonDispose.disposed(by: disposeBag)
    }
    
    func onAdvanceSearch(isOn:Bool)  {
    }
    
    var showTransferForm:Bool = false {
        didSet {
            let isHidden = !showTransferForm
            self.moreItemView.isHidden = isHidden
            self.moreItemView.alpha = isHidden ? 0 : 1
        }
    }
    var showAdvanceSearch:Bool = false {
        didSet {
            let isHidden = showAdvanceSearch
            self.searchFormView.subviews.enumerated().forEach { (index,view) in
                if index == 0 {
                    view.isHidden = isHidden
                } else {
                    view.isHidden = !isHidden
                }
            }
        }
    }
    
    @IBAction func onMoreButton(button:UISwitch) {
        UIView.animate(withDuration: 0.25) {
            self.showTransferForm = button.isOn
        }
    }

}
