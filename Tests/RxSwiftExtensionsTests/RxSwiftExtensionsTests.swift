import XCTest
import RxSwift
import RxCocoa

@testable import RxSwiftExtensions

final class RxSwiftExtensionsTests: XCTestCase {

    func testActivityIndicator() {

        let expectation = XCTestExpectation()

        let activityIndicator = ActivityIndicator()
        var count = 0
        let relay = PublishSubject<Void>()

        let observable = Observable.just(())
            .delay(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .trackActivity(activityIndicator)
            .subscribe(onNext: { _ in
                print("next")
            }, onCompleted: {
                print("completed 2")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    relay.onNext(())
                    relay.onCompleted()
                }
            }) {
                print("disposed")
            }

        let secondObservable = relay
            .trackActivity(activityIndicator)
            .subscribe(onNext: { _ in
                print("next 2")
            }, onCompleted: {
                print("completed 2")
            }) {
                print("disposed 2")
            }

        let activity = activityIndicator
            .drive(onNext: { bool in
                print(bool)
                count += 1

                if count == 2 {
                    expectation.fulfill()
                }
            }
        )

        wait(for: [expectation], timeout: 10)

    }
}
