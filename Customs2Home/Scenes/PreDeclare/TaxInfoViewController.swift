//
//  TaxInfoViewController.swift
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

class TaxInfoViewController: UIViewController {
    
    var disposeBag :DisposeBag?
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var howtoLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        bind()
    }
    
    func bind()  {
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        let viewModel = TaxInfoViewModel.instance()
        viewModel.viewControl = self
        let onload = Driver.just(())

      
        
        let input = TaxInfoViewModel.Input( onLoadView: onload,
                                                  onItem: nil )
//
        let output = viewModel.transform(input: input)
        output.commonDispose.disposed(by: disposeBag)
        
        viewModel.calTaxInfoResp.map({ (resp) -> NSAttributedString in
            return resp.htmlAttributed(using: UIFont.mainFontlight(ofSize: 12.0)) ?? NSAttributedString()
            
        }).bind(to: self.howtoLabel.rx.attributedText).disposed(by: disposeBag)
        
    }
    
    
    
//    let dataSource = RxTableViewSectionedReloadDataSource<KTableCellSection>(
//        configureCell: { ( _, tableView, indexPath, cellModel) -> UITableViewCell in
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.cellIden) as? KTableViewCell else { fatalError("Set wrong cell Iden or Wrong class") }
//            cell.bind(cellData: cellModel)
//            return cell
//    })
}
