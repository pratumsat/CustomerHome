//
//  ValidationProtocol.swift
//  Customs2Home
//
//  Created by thanawat on 11/6/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//
import RxCocoa
import RxSwift
import Foundation

protocol ValidationProtocol {
    var errorMessage: String { get }
    var data: BehaviorRelay<String> { get set }
    var errorValue: BehaviorRelay<String?> { get}
    func validateCredentials() -> Bool
}
