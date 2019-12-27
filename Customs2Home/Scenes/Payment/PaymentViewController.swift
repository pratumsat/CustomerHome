//
//  PaymentViewController.swift
//  Customs2Home
//
//  Created by warodom on 2/12/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import RxAppState
import Refreshable

class PaymentViewController: C2HViewcontroller {
    
    var disposeBag :DisposeBag?
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var noItemLabel: UILabel!

    
    var onRefreshBehavior:BehaviorSubject<Void?> = BehaviorSubject(value: nil)
    var onLoadMoreBehavior:BehaviorSubject<Void?> = BehaviorSubject(value: nil)
    
    override func viewDidLoad() {
        appTitleLabelAndNavigationDelegate(view: self)

        bind()
        addPullRefresh()
    }
    
    func updateLoadMoreEnable(_ count:Int) {
        tableView.setLoadMoreEnable(count != 0)
    }
    
    func addPullRefresh(){
        tableView.addPullToRefresh(action: {  [unowned self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                self.onRefreshBehavior.onNext(())
            }
        })
        
        tableView.addLoadMore(action: {  [unowned self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.onLoadMoreBehavior.onNext(())
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          self.onRefreshBehavior.onNext(())
    }
    
    func bind()  {
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        let viewModel = PaymentViewModel.instance()
        viewModel.viewControl = self
        let onload = Driver.just(())
        
        

        let onItem = tableView.rx.itemSelected.map({ [unowned self] path -> KTableCellModel? in
            try?self.tableView.rx.model(at: path)
        }).asDriver(onErrorJustReturn: nil)
        
        let onLoadMore = onLoadMoreBehavior.filter({ $0 != nil }).asDriver(onErrorJustReturn: nil)
        let onRefresh = onRefreshBehavior.filter({ $0 != nil }).asDriver(onErrorJustReturn: nil)
        
        
        let input = PaymentViewModel.Input( onLoadView: onload,
                                            onRefresh: onRefresh,
                                            onLoadMore: onLoadMore,
                                            onItem: onItem )

        let output = viewModel.transform(input: input)
        output.items?
            .do(onNext: { [unowned self] item in
                self.noItemLabel.isHidden = !item.isEmpty
 
            }).drive( self.tableView.rx.items(dataSource: dataSource) ).disposed(by: disposeBag )
        
        output.onItemSelect.bind {[unowned self] (declareId) in
            guard let declareId = declareId else { return }
            //self.showPaymentDetail(declareId)
            }.disposed(by: disposeBag)

        output.commonDispose.disposed(by: disposeBag)
    }
    
    let dataSource = RxTableViewSectionedReloadDataSource<KTableCellSection>(
        configureCell: { ( _, tableView, indexPath, cellModel) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.cellIden) as? KTableViewCell else { fatalError("Set wrong cell Iden or Wrong class") }
            cell.bind(cellData: cellModel)
            cell.selectionStyle = .none
            return cell
    })
}

extension PaymentViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if !(viewController is PaymentViewController) {
            viewController.navigationItem.leftBarButtonItem = setThemeBackButton()
        }
    }
    
    func showPaymentDetail(_ declareId: String){
        performSegue(withIdentifier: "showPaymentDetail", sender: declareId)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard  segue.identifier == "showPaymentDetail" else { return }
        guard let vc = segue.destination as? PaymentDetailViewController else { return }
        vc.declareId = (sender as! String)
    }
}
