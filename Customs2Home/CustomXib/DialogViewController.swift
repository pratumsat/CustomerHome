//
//  DialogView.swift
//  Customs2Home
//
//  Created by Wittawas Mukdaprasert on 31/10/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class DialogViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    var image = BehaviorRelay<UIImage?>(value: nil)
    var titleText = BehaviorRelay<String?>(value: nil)
    var detailText = BehaviorRelay<String?>(value: nil)
    
    var disposeBag : DisposeBag?
    
    init()
    {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        image.bind(to: imageView.rx.image).disposed(by: disposeBag)
        titleText.bind(to: titleLabel.rx.text).disposed(by: disposeBag)
        detailText.bind(to: detailLabel.rx.text).disposed(by: disposeBag)
    }
    
    func jailbreakAlertSetting() {
        image.accept( UIImage.init(named: "FailError") )
        titleText.accept( "Jailbroken" )
        detailText.accept( "Please delete your jailbroken and try again later." )
    }
}
