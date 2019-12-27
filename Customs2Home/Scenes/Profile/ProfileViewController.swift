//
//  ProfileViewController.swift
//  Customs2Home
//
//  Created by Wittawas Mukdaprasert on 3/9/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import RxAppState

class ProfileViewController: C2HViewcontroller {
    
    var disposeBag :DisposeBag?
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var labelVersion: UILabel!
    @IBOutlet weak var logoutButton: KButton!
    @IBOutlet weak var loginButton: KButton!
    
    var isLoginRelay:BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: TokenModel.instance().isLogin())
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(checkLogin), name: NSNotification.Name(rawValue: "checkLogin"), object: nil)
        
        bind()
        appTitleLabelAndNavigationDelegate(view: self)
    }
    @objc func checkLogin(notification:Notification){
        isLoginRelay.accept(TokenModel.instance().isLogin())
    }
    
    func bind()  {
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        let viewModel = ProfileViewModel.instance()
        viewModel.viewControl = self
        let onload = Driver.just(())

        
        isLoginRelay.bind(onNext: {[unowned self] (isLogin) in
            self.showEventLoginButton(isLogin: isLogin)
        })
        .disposed(by: disposeBag)
        
        
        let onItem = tableView.rx.itemSelected.map({ path -> IndexPath? in
//            try?self.tableView.rx.model(at: path)
            return path
        }).asDriver(onErrorJustReturn: nil)
//        let onTap = tableView.rx.itemSelected.map({ [unowned self] indexpath -> IndexPath in
//
//        })
        let input = ProfileViewModel.Input( onLoadView: onload,
                                            onItem: onItem,
                                            logout: logoutButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        output.items?.drive( self.tableView.rx.items(dataSource: dataSource) ).disposed(by: disposeBag )
        output.commonDispose.disposed(by: disposeBag)
        
        output.logout.bind(to: isLoginRelay).disposed(by: disposeBag )
        
        
        loginButton.rx.tap.bind { _ in
            TokenModel.instance().showLogin()
        }.disposed(by: disposeBag )
        
        //Display version app
        let nsObject = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
        let version = "V. \(nsObject as? String ?? "V. 0.0.0")"
        labelVersion.text = version
    }
    
    func onContact(){
        self.performSegue(withIdentifier: "opencontact", sender: nil)
    }
    
    func onFaq(){
        self.performSegue(withIdentifier: "openfaq", sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isLoginRelay.accept(TokenModel.instance().isLogin())

    }
    
    
    @IBAction func onTapLogout(_ sender: Any) {
    }
    @IBAction func onTapLogin(_ sender: Any) {
        //HomeTabbarViewModel.instance().showLogin()
    }
    
    func showEventLoginButton(isLogin: Bool){
        if isLogin {
            loginButton.isHidden = true
            logoutButton.isHidden = false
        }else{
            loginButton.isHidden = false
            logoutButton.isHidden = true
        }
    }
    
    lazy var dataSource:RxTableViewSectionedReloadDataSource<KTableCellSection> = {
        let datasource = RxTableViewSectionedReloadDataSource<KTableCellSection>(configureCell: {( _, tableView, indexPath, cellModel) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.cellIden) as? KTableViewCell else { fatalError("Set wrong cell Iden or Wrong class") }
            cell.bind(cellData: cellModel)
            return cell
        })
        return datasource
    }()
}

extension ProfileViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if !(viewController is ProfileViewController) {
            viewController.navigationItem.leftBarButtonItem = setThemeBackButton()
        }
    }
}
