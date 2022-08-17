//
//  PublishRelay.swift
//  
//
//  Created by Ilya Senchukov on 28.07.2022.
//

import Foundation
import RxRelay

public extension PublishRelay where Element == Void {

	func accept() {
		self.accept(())
	}

}
