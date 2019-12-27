//
//  KTableViewCell.swift
//  VRT Mobile
//
//  Created by Wittawas Mukdaprasert on 6/8/2562 BE.
//  Copyright © 2562 Kemin Suenggittawisuthi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ExpandableLabel

class KTableViewCell: UITableViewCell {
    @IBOutlet weak var titleImage:UIImageView?
    @IBOutlet weak var titleLabel:UILabel?
    @IBOutlet weak var detailLabel:UILabel? {
        didSet {
            if let expandLabel = detailLabel as? ExpandableLabel
            {
                expandLabel.isUserInteractionEnabled = false
                expandLabel.collapsedAttributedLink = NSAttributedString(string: "Continue reading", attributes: [ NSAttributedString.Key.foregroundColor : UIColor.azure ])
            }
        }
    }
    @IBOutlet weak var button1:UIButton?
    @IBOutlet weak var button2:UIButton?
    @IBOutlet weak var kText:KTextField?
    @IBOutlet weak var attrDetailLabel:UILabel?
    @IBOutlet weak var attrDetail2Label:UILabel?
    @IBOutlet weak var attrDetail3Label:UILabel?
    @IBOutlet weak var attrDetail4Label:UILabel?
    @IBOutlet weak var attrDetail5Label:UILabel?
    
    @IBOutlet weak var subDetailLabel1:UILabel?
    @IBOutlet weak var subDetailLabel2:UILabel?
    @IBOutlet weak var subDetailLabel3:UILabel?
    @IBOutlet weak var subDetailLabel4:UILabel?
    @IBOutlet weak var subDetailLabel5:UILabel?
    @IBOutlet weak var subDetailLabel6:UILabel?
    @IBOutlet weak var subDetailLabel7:UILabel?
    
    @IBOutlet weak var subView:UIView?
    
    var specingBetweenCell:CGFloat?
    
    var disposeBag:DisposeBag?
    
    func bind( cellData:KTableCellModel, bindButton:PublishSubject<String>? = nil ) {
        disposeBag = DisposeBag()
        if titleLabel != nil {
            cellData.title.bind(to: titleLabel!.rx.text).disposed(by: disposeBag!)
        }
        if detailLabel != nil {
            cellData.detail.bind(to: detailLabel!.rx.text).disposed(by: disposeBag!)
        }
        if titleImage != nil {
            cellData.image.bind(onNext: { [weak self] (image) in
                if let image = image,
                    let titleImage = self?.titleImage
                {
                    if image.size.width < titleImage.width && image.size.height < titleImage.height
                    {
                        titleImage.contentMode = .center
                    }
                    else {
                        titleImage.contentMode = .scaleAspectFit
                    }
                }
                self?.titleImage?.image = image
            }).disposed(by: disposeBag!)
            //            cellData.image.bind(to: titleImage!.rx.image).disposed(by: disposeBag!)
        }
        if attrDetailLabel != nil {
            cellData.attributedDetail.bind(to: attrDetailLabel!.rx.attributedText).disposed(by: disposeBag!)
        }
        if attrDetail2Label != nil {
            cellData.attributedDetail2.bind(to: attrDetail2Label!.rx.attributedText).disposed(by: disposeBag!)
        }
        if attrDetail3Label != nil {
            cellData.attributedDetail3.bind(to: attrDetail3Label!.rx.attributedText).disposed(by: disposeBag!)
        }
        if attrDetail4Label != nil {
            cellData.attributedDetail4.bind(to: attrDetail4Label!.rx.attributedText).disposed(by: disposeBag!)
        }
        if attrDetail5Label != nil {
            cellData.attributedDetail5.bind(to: attrDetail5Label!.rx.attributedText).disposed(by: disposeBag!)
        }
        bindSubDetailLabel(cellData: cellData)
        
        self.specingBetweenCell = cellData.specingBetweenCell
    }
    
    fileprivate func bindSubDetailLabel(cellData:KTableCellModel)
    {
        let disposeBag = self.disposeBag!
        bindLabel(label: subDetailLabel1, relay: cellData.subDetail1)?.disposed(by: disposeBag)
        bindLabel(label: subDetailLabel2, relay: cellData.subDetail2)?.disposed(by: disposeBag)
        bindLabel(label: subDetailLabel3, relay: cellData.subDetail3)?.disposed(by: disposeBag)
        bindLabel(label: subDetailLabel4, relay: cellData.subDetail4)?.disposed(by: disposeBag)
        bindLabel(label: subDetailLabel5, relay: cellData.subDetail5)?.disposed(by: disposeBag)
        bindLabel(label: subDetailLabel6, relay: cellData.subDetail6)?.disposed(by: disposeBag)
        bindLabel(label: subDetailLabel7, relay: cellData.subDetail7)?.disposed(by: disposeBag)
    }
    
    fileprivate func bindLabel( label:UILabel?, relay:BehaviorRelay<String>? ) -> Disposable?
    {
        if let label = label,
            let relay = relay
        {
            return relay.bind(to: label.rx.text)
        }
        else
        {
            return nil
        }
    }
    
    override func prepareForReuse() {
        self.accessoryType = .none
       
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let specing = specingBetweenCell {
            contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: specing, left: 0, bottom: specing, right: 0))
        }
        
    }
}
