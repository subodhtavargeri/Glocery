import Foundation
@testable import Glocery
import XCTest

class GloceryInteraactorTests: XCTestCase {
    
    func test_GetGloceryDetails_FromService() {
        let worker = GloceryWorkerSpy()
        let presenter = GloceryPresenterSpy()
        let interactor = GloceryInteractor(worker:worker, presenter: presenter)
        
        interactor.getItemList()
        
        let expectation = ItemDataModel(itemId: 1, itemName: "Sugar", itemPrice: 23)
        XCTAssertEqual(interactor.item, expectation)
    }
    
    func test_GetGloceryDetails_FromService_ViewModelIsCreated() {
        let worker = GloceryWorkerSpy()
        let presenter = GloceryPresenterSpy()
        let interactor = GloceryInteractor(worker:worker, presenter: presenter)
        
        interactor.getItemList()
        
        let expectation = ItemViewModel(itemName: "Sugar", itemPrice: 23.0)
        XCTAssertEqual(presenter.viewModel, expectation)
    }
}

protocol GloceryPresenterProtocol {
    func getItemListViewModel(dataModel: ItemDataModel)
}
class GloceryPresenterSpy: GloceryPresenterProtocol {
    
    var viewModel: ItemViewModel?
    
    func getItemListViewModel(dataModel: ItemDataModel) {
        viewModel = ItemViewModel(itemName: dataModel.itemName, itemPrice: dataModel.itemPrice)
    }
}

class GloceryInteractor {
    let worker: GloceryWorkerProtocol?
    let presenter: GloceryPresenterProtocol?
    private(set) var item: ItemDataModel? {
        didSet {
            guard let item = item, item != oldValue else { return }
            presenter?.getItemListViewModel(dataModel: item)
        }
    }
    
    init(worker: GloceryWorkerProtocol,
         presenter: GloceryPresenterProtocol) {
        self.worker = worker
        self.presenter = presenter
    }
    
    func getItemList() {
        self.worker?.getItemList(onCompletion: { item in
            self.item = ItemDataModel(itemId: item.itemId, itemName: item.itemName, itemPrice: item.itemPrice)
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
