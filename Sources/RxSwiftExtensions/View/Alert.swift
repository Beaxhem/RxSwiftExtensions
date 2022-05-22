//
//  Alert.swift
//  
//
//  Created by Ilya Senchukov on 10.04.2022.
//

import UIKit
import RxSwift
import RxCocoa

public struct Alert: SharedSequenceConvertibleType {

	public typealias ActionConfiguration = (title: String?, style: UIAlertAction.Style)

	public typealias Element = Bool
	public typealias SharingStrategy = DriverSharingStrategy

	public init(title: String? = nil, message: String? = nil, cancelTitle: String, primaryAction: ActionConfiguration, controller: UIViewController?) {
		let alert = alertViewController(title: title, message: message, cancelTitle: cancelTitle, destructiveAction: primaryAction)
		controller?.present(alert, animated: true)
	}

	private var isSuccess = PublishRelay<Bool>()

	public func asSharedSequence() -> SharedSequence<DriverSharingStrategy, Bool> {
		isSuccess.asDriver(onErrorJustReturn: false)
	}

}

private extension Alert {

	func alertViewController(title: String?, message: String?, cancelTitle: String, destructiveAction: ActionConfiguration) -> UIAlertController {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

		alert.addAction(.init(title: cancelTitle,
							  style: .cancel,
							  handler: { _ in
			isSuccess.accept(false)
		}))

		alert.addAction(.init(title: destructiveAction.title,
							  style: destructiveAction.style,
							  handler: { _ in
			isSuccess.accept(true)
		}))

		return alert
	}

}
