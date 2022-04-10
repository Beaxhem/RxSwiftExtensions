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

    func handle(_ action: @escaping () -> Void) -> Observable<Element> {
        self.do { _ in
            action()
        } onError: { _ in
            action()
        } onCompleted: {
            action()
        }
    }

}

public extension SharedSequenceConvertibleType {

    func handle(_ action: @escaping () -> Void) -> SharedSequence<SharingStrategy, Element> {
        self.do { _ in
            action()
        } onCompleted: {
            action()
        }
    }

    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        self.map { _ in () }
    }

}


