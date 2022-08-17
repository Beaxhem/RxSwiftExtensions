//
//  ObservableType.swift
//  
//
//  Created by Ilya Senchukov on 09.01.2022.
//

import RxSwift
import RxCocoa

public extension ObservableType {

    func withPrevious() -> Observable<(Element, Element)> {
        Observable.zip(self, self.skip(1))
    }

    func mapToVoid() -> Observable<Void> {
        map { _ in () }
    }

	func mapToOptional() -> Observable<Self.Element?> {
		map(Optional.init)
	}

    func handle(_ action: @escaping () -> Void) -> Observable<Element> {
        self.do { _ in
            action()
        } onError: { _ in
            action()
        } onCompleted: {
            action()
        }
    }

	func skipIf(_ expression: Bool, count: Int = 1) -> Observable<Self.Element> {
		self.skip(expression ? count : 0)
	}

}

public extension ObservableType {

	/// Shortcut of `start(with: T, then: { _ in T }` for mapping future element to single value
	func start<T>(with: T, then: T) -> Observable<T> {
		self.start(with: with, then: { _ in then })
	}


	/// Immediately emits `with` value, then skips 1 element and maps future values with `then` functor
	func start<T>(with: T, then: @escaping (Self.Element) -> T) -> Observable<T> {
		self.map(then)
			.skip(1)
			.startWith(with)
	}

}

extension ObservableType {

	func resigningFirstResponder<Owner: UIViewController>(
		owner: Owner,
		_ action: @escaping (Owner, Element) -> Observable<()>
	) -> Observable<Void> {
		self.withUnretained(owner)
			.do(onNext: { owner, _ in
				owner.inputAccessoryView?.resignFirstResponder()
				owner.resignFirstResponder()
			})
				.flatMap { owner, element in
					action(owner, element)
						.handle { [weak owner] in
							owner?.becomeFirstResponder()
						}
				}
	}

}

public extension SharedSequenceConvertibleType {

	/// shortcut for `.do(onNext:,onCompleted:)`
    func handle(_ action: @escaping () -> Void) -> SharedSequence<SharingStrategy, Element> {
        self.do { _ in
            action()
        } onCompleted: {
            action()
        }
    }

	/// maps everything to void
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        self.map { _ in () }
    }

}
