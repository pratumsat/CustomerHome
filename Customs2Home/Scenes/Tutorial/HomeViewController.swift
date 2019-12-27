//
//  HomeViewController.swift
//  Customs2Home
//
//  Created by warodom on 4/11/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import RxAppState

class HomeViewController: C2HViewcontroller {
    
    var disposeBag :DisposeBag?
    @IBOutlet weak var tableView:UITableView!
    @IBAction func prepareForUnwindToHome(segue: UIStoryboardSegue) {}
    @IBOutlet weak var withoutLoginButton: UIButton!
    @IBOutlet weak var orView: UIView!
    override func viewDidLoad() {
        appTitleLabelAndNavigationDelegate(view: self)

        
//        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let loginRegisterNav = self.navigationController as? LoginRegisterNav {
            withoutLoginButton.isHidden = loginRegisterNav.showLoginRegister
            orView.isHidden = loginRegisterNav.showLoginRegister
            self.navigationController?.setNavigationBarHidden(!loginRegisterNav.showLoginRegister, animated: true)
        }
    }
    
    @IBAction func withOutLoginTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func dismissTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    //    func bind()  {
//        self.disposeBag = DisposeBag()
//        let disposeBag = self.disposeBag!
//        let viewModel = <#ViewModelName#>.instance()
//        viewModel.viewControl = self
//        let onload = Driver.just(())
//
//        let onItem = tableView.rx.itemSelected.map({ [unowned self] path -> KTableCellModel? in
//            try?self.tableView.rx.model(at: path)
//        }).asDriver(onErrorJustReturn: nil)
//        let input = <#ViewModelName#>.Input( onLoadView: onload,
//                                                  onItem: onItem )
//
//        let output = viewModel.transform(input: input)
//        output.items?.drive( self.tableView.rx.items(dataSource: dataSource) ).disposed(by: disposeBag )
//        output.commonDispose.disposed(by: disposeBag)
//    }
    
    let dataSource = RxTableViewSectionedReloadDataSource<KTableCellSection>(
        configureCell: { ( _, tableView, indexPath, cellModel) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.cellIden) as? KTableViewCell else { fatalError("Set wrong cell Iden or Wrong class") }
            cell.bind(cellData: cellModel)
            return cell
    })
    
    @IBAction func prepareForUnwindToHomeLoginView(segue: UIStoryboardSegue) {}
}

extension HomeViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if !(viewController is HomeViewController) {
            viewController.navigationItem.leftBarButtonItem = setThemeBackButton()
        }
    }
}
