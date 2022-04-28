//
//  CheckoutViewModelTests.swift
//  bettingTests
//
//  Created by Çağrı Portakalkökü on 28.04.2022.
//

import XCTest
import RxCocoa
@testable import betting

class CheckoutViewModelTests: XCTestCase {
    var sut: CheckoutViewModel!
    var cartSpy = CartSpy()
    var delegateSpy = CheckoutViewModelDelegateSpy()
    
    override func setUp() {
        setupViewModel()
    }
    
    override func tearDown() {
        sut = nil
    }

    private func setupViewModel() {
        sut = .init(cart: cartSpy)
        sut.delegate = delegateSpy
    }
    
    func testRemoveEventFromCart_CallAddOrRemoveEvent() {
        sut.removeEventFromCart(event: createMockEvent())
        XCTAssertTrue(cartSpy.addOrRemoveEventCalled)
    }
    
    func testRemoveEventFromCart_CallReloadMultiplier_WhileEventsExists() {
        cartSpy.getEventsReturnValue = [createMockEvent()]
        sut.removeEventFromCart(event: createMockEvent())
        XCTAssertTrue(delegateSpy.reloadMultiplierCalled)
    }
    
    func testRemoveEventFromCart_CallReloadMultiplierWithCorrectData_WhileEventsExists() {
        cartSpy.getEventsReturnValue = [createMockEvent()]
        cartSpy.getMultiplierReturnValue = 10.0
        sut.removeEventFromCart(event: createMockEvent())
        XCTAssertTrue(delegateSpy.reloadMultiplierValue == 10.0)
    }
    
    func testRemoveEventFromCart_CallReloadTableView_WhileEventsExists() {
        cartSpy.getEventsReturnValue = [createMockEvent()]
        sut.removeEventFromCart(event: createMockEvent())
        XCTAssertTrue(delegateSpy.reloadTableViewCalled)
    }
    
    func testRemoveEventFromCart_CallShowEmptyScreen_WhileEventCountIsZero() {
        cartSpy.getEventsReturnValue = []
        sut.removeEventFromCart(event: createMockEvent())
        XCTAssertTrue(delegateSpy.showEmptyScreenCalled)
    }
    
    func testGetCartEvents_CallGetEventsAndReturnsEventArray() {
        cartSpy.getEventsReturnValue = [createMockEvent()]
        let events = sut.getCartEvents()
        XCTAssertTrue(events.count == 1)
        XCTAssertTrue(cartSpy.getEventsCalled)
    }
    
    func testGetMultiplier_CallGetMultiplierOfCart() {
        let _ = sut.getMultiplier()
        XCTAssertTrue(cartSpy.getMultiplierCalled)
    }
    
    func testCalculateMaxReturn_CallReloadMultiplier() {
        sut.calculateMaxReturn(value: 5.0)
        XCTAssertTrue(delegateSpy.reloadMultiplierCalled)
    }
    
    func testCalculateMaxReturn_CalculatesIncomeCorrectly() {
        cartSpy.getMultiplierReturnValue = 5.0
        sut.calculateMaxReturn(value: 5.0)
        XCTAssertTrue(delegateSpy.reloadMultiplierValue == 25.00)
    }

}

extension CheckoutViewModelTests {
    func createMockEvent(id: String = "", name: String = "", price: Double = 0.0, side: BulletinModels.OddType = .away) -> CartModels.Event {
        return .init(id: id, name: name, price: price, side: side)
    }
}

class CartSpy: CartProtocol {
    var events: BehaviorRelay<[CartModels.Event]> = .init(value: [])
    var addOrRemoveEventCalled = false
    var checkIfOddExistInCartCalled = false
    var getMultiplierCalled = false
    var getEventsCalled = false
    
    var checkIfOddExistInCartReturnValue = false
    var getMultiplierReturnValue = 0.0
    var getEventsReturnValue: [CartModels.Event] = []
    
    func addOrRemoveEvent(_ event: CartModels.Event) {
        addOrRemoveEventCalled = true
    }
    
    func checkIfOddExistInCart(_ id: String, type: BulletinModels.OddType) -> Bool {
        checkIfOddExistInCartCalled = true
        return checkIfOddExistInCartReturnValue
    }
    
    func getMultiplier() -> Double {
        getMultiplierCalled = true
        return getMultiplierReturnValue
    }
    
    func getEvents() -> [CartModels.Event] {
        getEventsCalled = true
        return getEventsReturnValue
    }
}

class CheckoutViewModelDelegateSpy: CheckoutViewModelDelegate {
    var reloadMultiplierCalled = false
    var reloadMultiplierValue = 33.33
    var reloadTableViewCalled = false
    var showEmptyScreenCalled = false
    
    func reloadMultiplier(with value: Double) {
        reloadMultiplierCalled = true
        reloadMultiplierValue = value
    }
    
    func reloadTableView() {
        reloadTableViewCalled = true
    }
    
    func showEmptyScreen() {
        showEmptyScreenCalled = true
    }
}
