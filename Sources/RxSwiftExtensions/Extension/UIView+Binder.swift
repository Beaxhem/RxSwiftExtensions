//
//  UIView+Binder.swift
//  
//
//  Created by Ilya Senchukov on 08.01.2022.
//

import RxSwift
import RxCocoa
import UIKit

public extension Reactive where Base: UIView {

    var isNotHidden: Binder<Bool> {
        .init(base) {
            $0.isHidden = !$1
        }
    }

}
