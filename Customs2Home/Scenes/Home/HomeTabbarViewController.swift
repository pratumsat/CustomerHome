//
//  HomeTabbarViewController.swift
//  Customs2Home
//
//  Created by Wittawas Mukdaprasert on 2/9/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import RxAppState
import RxCocoa
import RxDataSources
import RxSwift
import UIKit

class HomeTabbarViewController: UITabBarController {
    var disposeBag: DisposeBag?

    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        delegate = self

        guard let font = UIFont(name: "Prompt-Light", size: 10) else { return }
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: font], for: .selected)

        guard TokenModel.instance().isLogin() else {
            showTutorial()
            return
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBar.items?[3].badgeValue = KeyChainService.notiBadge == "0" ? nil : KeyChainService.notiBadge
    }

    func bind() {
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        let viewModel = HomeTabbarViewModel.instance()
        viewModel.viewControl = self

        let onload = Driver.just(())
        let input = HomeTabbarViewModel.Input(onLoadView: onload)
        let output = viewModel.transform(input: input)
        output.items.drive().disposed(by: disposeBag)
        output.commonDispose.disposed(by: disposeBag)
    }

    func showAlertForceLogin(msg: String) {
        alert(message: msg, perform: { [unowned self] () in
            self.showLoginRegister(noDialogConfirm : true)
        })
    }

    func showTutorial() {
        performSegue(withIdentifier: "showTutorial", sender: nil)
    }
}

extension HomeTabbarViewController: UITabBarControllerDelegate {
    func showLoginRegister(noDialogConfirm:Bool = false) {
        // LoginRegisterViewController
        if let loginNav = UIViewController.loadStory(storyboardName: "Tutorial", identifier: "LoginRegisterNav") as? LoginRegisterNav {
            loginNav.showLoginRegister = true
            loginNav.modalTransitionStyle = .coverVertical

            guard !noDialogConfirm else {
                self.present(loginNav, animated: true, completion: nil)
                return
            }
            presentAlertWithTitle(title: "กรุณาเข้าสู่ระบบ", message: "", options: "ยกเลิก", "ตกลง", completion: { index in
                guard index > 0 else { return }
                self.present(loginNav, animated: true, completion: nil)
            })
        }
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController)!
        var show = true
        switch selectedIndex {
        case 1, 2, 3:
            if TokenModel.instance().checkAccountValid() {
                show = true
            } else {
                show = false
            }
            break
        default:
            break
        }
        return show
    }
}
