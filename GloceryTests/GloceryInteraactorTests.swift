import Foundation
@testable import Glocery
import XCTest

class GloceryInteraactorTests: XCTestCase {
    
    func test_GetGloceryDetails_FromService() {
        let worker = GloceryWorkerSpy()
        let interactor = GloceryInteractor(worker:worker)
        
        interactor.getItemList()
        
        let expectation = ItemDataModel(itemId: 1, itemName: "Sugar", itemPrice: 23)
        XCTAssertEqual(interactor.itemList, expectation)
    }
}


class GloceryInteractor {
    let worker: GloceryWorkerProtocol?
    var itemList: ItemDataModel?
    
    init(worker: GloceryWorkerProtocol) {
        self.worker = worker
    }
    
    func getItemList() {
        self.worker?.getItemList(onCompletion: { item in
            itemList = ItemDataModel(itemId: item.itemId, itemName: item.itemName, itemPrice: item.itemPrice)
        })
    }
}

protocol GloceryWorkerProtocol {
    typealias completion = (ItemDataModel) -> Void
    func getItemList(onCompletion: completion)
}

class GloceryWorkerSpy: GloceryWorkerProtocol {
    func getItemList(onCompletion: completion) {
        let item = ItemDataModel(itemId: 1, itemName: "Sugar", itemPrice: 23)
        onCompletion(item)
    }
    
}
