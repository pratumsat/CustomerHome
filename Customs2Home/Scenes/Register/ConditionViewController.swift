//
//  ConditionViewController.swift
//  Customs2Home
//
//  Created by warodom on 8/11/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit
import WebKit
import RxCocoa
import RxSwift
import RxDataSources
import RxAppState

class ConditionViewController: C2HViewcontroller {
    
    var disposeBag :DisposeBag?
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var btnNext: KButton!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        initHeaderView()
        bind()
    }
  
    //    override func viewDidAppear(_ animated: Bool) {
    //        super.viewDidAppear(animated)
    ////        initHeaderView()
    //    }
    
        func bind()  {
            self.disposeBag = DisposeBag()
            let disposeBag = self.disposeBag!
            let viewModel = ConditionViewModel.instance()
            viewModel.viewControl = self
            
            let onload = Driver.just(())

            let input = ConditionViewModel.Input( onLoadView: onload )
            let output = viewModel.transform(input: input)
            
            output.htmlString.do(onNext: {[unowned self] (htmlString) in
                self.webView.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL)
            }).drive().disposed(by: disposeBag)
            output.commonDispose.disposed(by: disposeBag)
            
            btnCheck.rx.controlEvent(.touchDown).bind(onNext: { [unowned self] in
                self.btnCheck.isSelected = !self.btnCheck.isSelected
                self.btnNext.isEnabled = self.btnCheck.isSelected
            }).disposed(by: disposeBag)
        }
    
//        let dataSource = RxTableViewSectionedReloadDataSource<KTableCellSection>(
//            configureCell: { ( _, tableView, indexPath, cellModel) -> UITableViewCell in
//                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.cellIden) as? KTableViewCell else { fatalError("Set wrong cell Iden or Wrong class") }
//                cell.bind(cellData: cellModel)
//                return cell
//        })
    
    
    func initHeaderView(){
        guard let stepView = UIView.loadNib(name: "StepView")?.first as? StepViewControlller else { return }
        stepView.frame.size = headerView.frame.size
        stepView.view1.backgroundColor = .appThemeColor
        stepView.view2.backgroundColor = .borderThemeColor
        stepView.view3.backgroundColor = .borderThemeColor
        stepView.lineleft.backgroundColor = .borderThemeColor
        stepView.lineRight.backgroundColor = .borderThemeColor
        headerView.addSubview(stepView)
        
    }
}

