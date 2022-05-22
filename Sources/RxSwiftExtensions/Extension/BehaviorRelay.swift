//
//  BehaviorRelay.swift
//  
//
//  Created by Ilya Senchukov on 10.04.2022.
//

import RxCocoa

public extension BehaviorRelay where Element == Int {

	func increment() {
		accept(value + 1)
	}

	func increment(min: Int) {
		accept(max(min, value + 1))
	}

	func increment(max: Int) {
		accept(min(max, value + 1))
	}

	func decrement() {
		accept(value - 1)
	}

	func decrement(min: Int) {
		accept(max(min, value - 1))
	}

	func decrement(max: Int) {
		accept(min(max, value - 1))
	}

}

public extension BehaviorRelay where Element == Bool {

	func toggle() {
		accept(!value)
	}

}
