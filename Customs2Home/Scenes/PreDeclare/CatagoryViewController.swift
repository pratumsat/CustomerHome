//
//  CatagoryViewController.swift
//  Customs2Home
//
//  Created by warodom on 27/9/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import RxAppState
import RxCocoa
import RxDataSources
import RxSwift
import SWSegmentedControl
import UIKit

class CatagoryViewController: UIViewController,UISearchControllerDelegate, UINavigationControllerDelegate {
    var disposeBag :DisposeBag?
    
    
//    var navigatorSelect = ReplaySubject<CategoryCellModel>.create(bufferSize: 3)
    var categoryArray = Array<CategoryCellModel>()
    
    var navigatorSelect = PublishSubject<CategoryCellModel?>()
    
    var didSelect = PublishSubject<TariffList>()

//    func updateSearchResults(for searchController: UISearchController) {
//        guard let text = searchController.searchBar.text else { return }
//        SearchResultViewModel.instance().searchText.accept(text)
//    }

    @IBOutlet var segmentedControl: SWSegmentedControl!
    var tabNavigation: UINavigationController!
    @IBOutlet var tabView: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        initTabView()
        segmentedControl.items = ["ประเภท", "ประเภทย่อย", "รายการ"]
        segmentedControl.isEnabled = false
        segmentedControl.font = UIFont.mainFontSemiBold(ofSize: 16)
        bind()
        initSearchView()
    }

    func bind() {
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        let viewModel = CategoryViewModel.instance()
        viewModel.viewControl = self
        let onload = Driver.just(())

        let input = CategoryViewModel.Input(onLoadView: onload, onItem: nil)

        let output = viewModel.transform(input: input)
        output.items?.drive(onNext: { [unowned self] data in
            guard let navigationtabView = self.loadStory(identifier: "navigationtabView") as? NavigationTabView else { return }
            self.tabNavigation.pushViewController(navigationtabView, animated: false)
            navigationtabView.items.accept([KTableCellSection(identity: 0, items: data)])
        }).disposed(by: disposeBag)

        output.commonDispose.disposed(by: disposeBag)
        self.bindNavigatorSelect().disposed(by: disposeBag)
    }
    
    func bindNavigatorSelect() -> Disposable {
        
        let result = navigatorSelect.subscribe(onNext: { [unowned self] (newModel) in
            if let newModel = newModel {
                self.categoryArray.append(newModel)
            }
            else {
                 self.categoryArray.removeLast()
            }
        }, onCompleted: {
            let models = self.categoryArray
            let category = models[0].content as! Category
            let subCategory = models[1].content as! SubCategory
            var tariffList = models[2].content as! TariffList
            
            tariffList.fillCategoryData(category:  category , subCategory: subCategory)
            
            self.didSelect.onNext(tariffList)
            self.didSelect.onCompleted()
        })
        
        
//         let result = navigatorSelect
//            .takeLast(3)
//            .buffer(timeSpan: RxTimeInterval.never, count: 0, scheduler: MainScheduler.instance)
//            .map( { models -> TariffList in
//                let category = models[0].content as! Category
//                let subCategory = models[1].content as! SubCategory
//                var tariffList = models[2].content as! TariffList
//
//
//                tariffList.fillCategoryData(category:  category , subCategory: subCategory , qtyLimit : tariffList.qtyLimit ?? 0, msgWarning: tariffList.msgWarning)
//                return tariffList
//            })
//            .bind(onNext: { (tariff) in
//                self.didSelect.onNext(tariff)
//                self.didSelect.onCompleted()
//            })
        return result
    }

    func initTabView() {
        tabNavigation = UINavigationController()
        tabNavigation.delegate = self
        tabNavigation.setNavigationBarHidden(true, animated: false)
//        tabNavigation.view.backgroundColor = UIColor.red
        //        tabNavigation.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tabNavigation.view.frame = tabView.bounds
        tabView.addSubview(tabNavigation.view)
    }

    func initSearchView() {
        let searchVc = loadStory(identifier: "searchresult")
        let searchController = UISearchController(searchResultsController: searchVc)
        
        searchController.searchBar.setValue("ยกเลิก", forKey: "cancelButtonText")
        searchController.searchBar.placeholder = "ค้นหา"
        searchController.searchBar.rx.textDidEndEditing.bind { _ in
            guard let text = searchController.searchBar.text else { return }
            SearchResultViewModel.instance().searchText.accept( text )
        }
        .disposed(by: self.disposeBag!)
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false

        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard navigationController.viewControllers.count <= segmentedControl.items.count else { return }
        if navigationController.viewControllers.count < 2 {
            self.backButton.fadeOut()
        } else {
            self.backButton.alpha = 1
            backButton.isHidden = false
        }
        segmentedControl.setSelectedSegmentIndex((navigationController.viewControllers.count - 1) , animated: true)
    }

//    let dataSource = RxTableViewSectionedReloadDataSource<KTableCellSection>(
//        configureCell: { ( _, tableView, indexPath, cellModel) -> UITableViewCell in
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.cellIden) as? KTableViewCell else { fatalError("Set wrong cell Iden or Wrong class") }
//            cell.bind(cellData: cellModel)
//            return cell
//    })
    @IBAction func onBackButton(_ sender: Any) {
        tabNavigation.popViewController(animated: true)
        self.navigatorSelect.onNext(nil)
    }
}

extension Reactive where Base: CatagoryViewController {
    internal var didCompleteSelect: Observable<TariffList> {
        return base.didSelect.do(onCompleted: {
            self.base.navigationController?.popViewController(animated: true)
        })
    }
}
