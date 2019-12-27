//
//  ConfirmBeforeDeclarationViewController.swift
//  Customs2Home
//
//  Created by warodom on 14/11/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import RxAppState

class ConfirmBeforeDeclarationViewController: C2HViewcontroller {
    
    var disposeBag :DisposeBag?
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var stepView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    var declareAddEditReq: DeclareAddEditReq?
    
    override func viewDidLoad() {
        bind()
         initStepView4(mainView: stepView, label1: .appThemeColor, label2: .appThemeColor, label3: .borderThemeColor, label4: .borderThemeColor, viewLeft: .appThemeColor, viewCenter: .borderThemeColor, viewRight: .borderThemeColor)
    }
    func bind()  {
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        let viewModel = ConfirmBeforeDeclarationViewModel.instance()
        viewModel.viewControl = self
        
        let onload = Driver.just(())

        let onItem = tableView.rx.itemSelected.map({ [unowned self] path -> KTableCellModel? in
            try?self.tableView.rx.model(at: path)
        }).asDriver(onErrorJustReturn: nil)
        
        let input = ConfirmBeforeDeclarationViewModel.Input( onLoadView: onload,
                                                             onItem: onItem )
        
        let output = viewModel.transform(input: input)
        output.items?.drive( self.tableView.rx.items(dataSource: dataSource) ).disposed(by: disposeBag )
        output.commonDispose.disposed(by: disposeBag)
        
        if let model = declareAddEditReq {
            self.nameLabel.text = model.name
            self.addressLabel.text = model.address
            self.mobileLabel.text = model.mobileNo
            self.emailLabel.text = model.email
        }
    }
    
    let dataSource = RxTableViewSectionedReloadDataSource<KTableCellSection>(
        configureCell: { ( _, tableView, indexPath, cellModel) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.cellIden) as? KTableViewCell else { fatalError("Set wrong cell Iden or Wrong class") }
            cell.bind(cellData: cellModel)
            return cell
    })
}

extension ConfirmBeforeDeclarationViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard  segue.identifier == "showDeclareStep3" else { return }
        guard let vc = segue.destination as? DeclarationDetailViewController else { return }
        vc.declareAddEditReq = self.declareAddEditReq
    }
}
