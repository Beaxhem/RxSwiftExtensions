//
//  ActivityIndicator.swift
//  
//
//  Created by Ilya Senchukov on 09.10.2021.
//

import RxSwift
import RxCocoa
import UIKit

public class ActivityIndicator: SharedSequenceConvertibleType {

    public typealias Element = Bool
    public typealias SharingStrategy = DriverSharingStrategy

    private var count = BehaviorRelay<Int>(value: 0)
    private var loading: SharedSequence<SharingStrategy, Bool>

    public init() {
        loading = count.asDriver()
            .map { $0 > 0}
            .distinctUntilChanged()
    }

    func trackActivity<Source: ObservableConvertibleType>(_ source: Source) -> Observable<Source.Element>{
        Observable.using { () -> Token<Source.Element> in
            self.increment()
            return Token(source: source.asObservable(), disposeAction: self.decrement)
        } observableFactory: { d in
            d.asObservable()
        }
    }

    func increment() {
		count.increment()
    }

    func decrement() {
		count.decrement()
    }

    public func asSharedSequence() -> SharedSequence<DriverSharingStrategy, Bool> {
        loading
    }

}

private class Token<Element>: ObservableConvertibleType, Disposable {

    var _dispose: Cancelable
    var _source: Observable<Element>


    init(source: Observable<Element>, disposeAction: @escaping () -> Void) {
        self._source = source
        self._dispose = Disposables.create(with: disposeAction)
    }

    func asObservable() -> Observable<Element> {
        _source
    }

    func dispose() {
        _dispose.dispose()
    }

}

extension ObservableConvertibleType {

    public func trackActivity(_ activityIndicator: ActivityIndicator) -> Observable<Element> {
        activityIndicator.trackActivity(self)
    }

}

