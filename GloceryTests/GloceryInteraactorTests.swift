import Foundation
@testable import Glocery
import XCTest

class GroceryInteraactorTests: XCTestCase {
    
    func test_GetGroceryDetails_FromService() {
        let worker = GroceryWorkerSpy()
        let presenter = GroceryPresenterSpy()
        let interactor = GroceryInteractor(worker:worker, presenter: presenter)
        
        interactor.getItemList()
        
        let expectation = ItemDataModel(itemId: 1, itemName: "Sugar", itemPrice: 23)
        XCTAssertEqual(interactor.item, expectation)
    }
    
    func test_GetGroceryDetails_FromService_ViewModelIsCreated() {
        let worker = GroceryWorkerSpy()
        let presenter = GroceryPresenterSpy()
        let interactor = GroceryInteractor(worker:worker, presenter: presenter)
        
        interactor.getItemList()
        
        let expectation = ItemViewModel(itemName: "Sugar", itemPrice: 23.0)
        XCTAssertEqual(presenter.viewModel, expectation)
    }
}

protocol GroceryPresenterProtocol {
    func getItemListViewModel(dataModel: ItemDataModel)
}
class GroceryPresenterSpy: GroceryPresenterProtocol {
    
    var viewModel: ItemViewModel?
    
    func getItemListViewModel(dataModel: ItemDataModel) {
        viewModel = ItemViewModel(itemName: dataModel.itemName, itemPrice: dataModel.itemPrice)
    }
}

class GroceryInteractor {
    let worker: GroceryWorkerProtocol?
    let presenter: GroceryPresenterProtocol?
    private(set) var item: ItemDataModel? {
        didSet {
            guard let item = item, item != oldValue else { return }
            presenter?.getItemListViewModel(dataModel: item)
        }
    }
    
    init(worker: GroceryWorkerProtocol,
         presenter: GroceryPresenterProtocol) {
        self.worker = worker
        self.presenter = presenter
    }
    
    func getItemList() {
        self.worker?.getItemList(onCompletion: { item in
            self.item = ItemDataModel(itemId: item.itemId, itemName: item.itemName, itemPrice: item.itemPrice)
        })
    }
}

protocol GroceryWorkerProtocol {
    typealias completion = (ItemDataModel) -> Void
    func getItemList(onCompletion: completion)
}

class GroceryWorkerSpy: GroceryWorkerProtocol {
    func getItemList(onCompletion: completion) {
        let item = ItemDataModel(itemId: 1, itemName: "Sugar", itemPrice: 23)
        onCompletion(item)
    }
    
}
