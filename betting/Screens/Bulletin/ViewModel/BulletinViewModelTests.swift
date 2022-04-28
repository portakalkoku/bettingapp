//
//  BulletinViewModelTests.swift
//  bettingTests
//
//  Created by Çağrı Portakalkökü on 28.04.2022.
//

import XCTest
@testable import betting

class BulletinViewModelTests: XCTestCase {
    
    var sut: BulletinViewModel!
    let apiSpy = APISpy()
    let cart = CartSpy()
    let firebaseHelper = FirebaseHelperSpy()
    let delegateSpy = BulletinViewModelDelegateSpy()
    
    override func setUp() {
        setupViewModel()
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testRXLoaded_EventAddedToCart_CallsReloadCartView() {
        cart.events.accept([createMockEvent()])
        XCTAssertTrue(delegateSpy.reloadCartViewCalled)
    }
    
    func testRXLoaded_EventAddedToCart_CallsReloadCartViewWithCorrectValue() {
        cart.getMultiplierReturnValue = 5.5
        cart.events.accept([createMockEvent()])
        XCTAssertTrue(delegateSpy.multiplierValue == 5.5)
    }
    
    func testRequestGroups_CallShowLoading() {
        sut.requestGroups()
        XCTAssertTrue(delegateSpy.showLoadingCalled)
    }
    
    func testRequestGroups_MakeApiCallsWithSportsRequestType() {
        sut.requestGroups()
        switch apiSpy.targetType {
        case RequestType.sports:
            XCTAssertTrue(true)
        default:
            XCTAssertTrue(false)
        }
    }
    
    func testRequestGroups_HideLoadingWhenAResultReturned() {
        sut.requestGroups()
        apiSpy.result = .failure(.serviceError)
        XCTAssertTrue(delegateSpy.hideLoadingCalled)
    }
    
    func testRequestGroups_ShowErrorMessageWhenMeaninglessDataReturned() {
        apiSpy.result = .success(.init("asdasd".utf8))
        sut.requestGroups()
        XCTAssertTrue(delegateSpy.showErrorMessageCalled)
    }
    
    func testRequestGroups_ReloadCollectionViewWhenMeaningfulDataReturned() {
        apiSpy.result = .success(createMeaningfulSportData())
        sut.requestGroups()
        XCTAssertTrue(delegateSpy.reloadCollectionViewCalled)
    }
    
    func testRequestGroups_StoresSportsDataOnDataStore() {
        apiSpy.result = .success(createMeaningfulSportData())
        sut.requestGroups()
        XCTAssertTrue(sut.dataStore.sports.count > 0)
    }
    
    func testRequestGroups_StoresGroupDataOnDataStore() {
        apiSpy.result = .success(createMeaningfulSportData())
        sut.requestGroups()
        XCTAssertTrue(sut.dataStore.groups.count > 0)
    }
    
    func testRequestGroups_StoresGroupDataAsUniqueVariables() {
        apiSpy.result = .success(createMeaningfulSportData())
        sut.requestGroups()
        XCTAssertTrue(sut.dataStore.sports.count > sut.dataStore.groups.count)
    }
    
    func testRequestGroups_CallsShowErrorMessageOnFailure() {
        apiSpy.result = .failure(.serviceError)
        sut.requestGroups()
        XCTAssertTrue(delegateSpy.showErrorMessageCalled)
    }
    
    func testRequestOdds_CallShowLoading() {
        sut.requestOdds(key: "")
        XCTAssertTrue(delegateSpy.showLoadingCalled)
    }
    
    func testRequestOdds_CallHideLoadingWhenAResultIsReturned() {
        sut.requestOdds(key: "")
        XCTAssertTrue(delegateSpy.hideLoadingCalled)
    }
    
    func testRequestOdds_CallsShowErrorMessageWhenMeaninglessDataReturned() {
        apiSpy.result = .success(.init("asd".utf8))
        sut.requestOdds(key: "")
        XCTAssertTrue(delegateSpy.showErrorMessageCalled)
    }
    
    func testRequestOdds_CallsReloadTableViewWhenMeaningfulDataReturned() {
        apiSpy.result = .success(createMeaningfulOddData())
        sut.requestOdds(key: "")
        XCTAssertTrue(delegateSpy.reloadTableViewCalled)
    }
    
    func testRequestOdds_CallsShowErrorMessageOnFailure() {
        apiSpy.result = .failure(.wrongMapping)
        sut.requestOdds(key: "")
        XCTAssertTrue(delegateSpy.showErrorMessageCalled)
    }
    
    func testRequestOdds_DoesntCallReloadTableView_WhenExistingOddInDataStoreIsReturned() {
        apiSpy.result = .success(createMeaningfulOddData())
        sut.dataStore.odds = [.init(id: "6658e994d5f4447a8ca4649995acf508", sport_key: "soccer_uefa_champs_league", commence_time: "", home_team: "", away_team: "", bookmakers: [])]
        sut.requestOdds(key: "")
        XCTAssertFalse(delegateSpy.reloadTableViewCalled)
    }
    
    func testRequestOdds_AppendsNewOddDataToDataStore_WhenNonExistingOddDataIsReturned() {
        apiSpy.result = .success(createMeaningfulOddData())
        sut.dataStore.odds = [.init(id: "6658e994d5f4447a8ca4649995acf508", sport_key: "league1", commence_time: "", home_team: "", away_team: "", bookmakers: [])]
        sut.requestOdds(key: "")
        XCTAssertTrue(sut.dataStore.odds.count > 1)
    }
    
    func testRequestOdds_CallsReloadTableView_WhenNonExistingOddDataIsReturned() {
        apiSpy.result = .success(createMeaningfulOddData())
        sut.dataStore.odds = [.init(id: "6658e994d5f4447a8ca4649995acf508", sport_key: "league1", commence_time: "", home_team: "", away_team: "", bookmakers: [])]
        sut.requestOdds(key: "")
        XCTAssertTrue(delegateSpy.reloadTableViewCalled)
    }
    
    func testGetOddsOfSport_SendsFirebaseEventCorrectly() {
        let _ = sut.getOddsOfSport(sportKey: "sport1")
        XCTAssertTrue(firebaseHelper.sendEventCalled)
        XCTAssertTrue(firebaseHelper.eventValue == "league_tap")
        XCTAssertTrue(firebaseHelper.parametersValue!["sportKey"] as! String == "sport1")
    }
    
    func testAddOrRemoveCartEventFromCart_CallsReloadTableView() {
        sut.addOrRemoveEventFromCart(event: .init(id: "", name: "", price: 52.0, side: .away))
        XCTAssertTrue(delegateSpy.reloadTableViewCalled)
    }
    
    func testSearchBy_CallsReloadTableView() {
        sut.searchBy("")
        XCTAssertTrue(delegateSpy.reloadTableViewCalled)
    }
    
    func testSearchBy_StoresSearchValueOnDataStore() {
        sut.searchBy("asd")
        XCTAssertTrue(sut.dataStore.searchText == "asd")
    }
    
    func testRouteToCheckout_CallsRouteToCheckout() {
        sut.didTapRouteToCheckout()
        XCTAssertTrue(delegateSpy.routeToCheckoutCalled)
    }
    
    func testRouteToCheckout_CallsRouteToCheckoutWithCorrectData() {
        sut.didTapRouteToCheckout()
        XCTAssertTrue(cart.getMultiplierReturnValue == delegateSpy.cartValue?.getMultiplier())
    }
    
    func testSelectGroup_StoresGroupIdOnDataStore() {
        sut.selectGroup(group: "abd")
        XCTAssertTrue(sut.dataStore.selectedGroup == "abd")
    }
    
    func testSelectGroup_CallsReloadCollectionView() {
        sut.selectGroup(group: "")
        XCTAssertTrue(delegateSpy.reloadCollectionViewCalled)
    }
    
    func testSelectGroup_CallsReloadTableView() {
        sut.selectGroup(group: "")
        XCTAssertTrue(delegateSpy.reloadTableViewCalled)
    }
    
    
    
    private func setupViewModel() {
        sut = BulletinViewModel.init(api: apiSpy, cart: cart)
        sut.firebaseHelper = firebaseHelper
        sut.delegate = delegateSpy
    }
    
    private func createMockEvent() -> CartModels.Event {
        .init(id: "", name: "", price: 2.5, side: .away)
    }
    
    private func createMeaningfulSportData() -> Data {
        .init("[{\"key\":\"americanfootball_ncaaf\",\"group\":\"American Football\",\"title\":\"NCAAF\",\"description\":\"US College Football\",\"active\":true,\"has_outrights\":false}, {\"key\":\"americanfootball_ncaaf\",\"group\":\"American Football\",\"title\":\"NCAAF\",\"description\":\"US College Football\",\"active\":true,\"has_outrights\":false}]".utf8)
    }
    
    private func createMeaningfulOddData() -> Data {
        .init("[{\"id\":\"6658e994d5f4447a8ca4649995acf508\",\"sport_key\":\"soccer_uefa_champs_league\",\"sport_title\":\"UEFA Champions\",\"commence_time\":\"2022-05-03T19:00:00Z\",\"home_team\":\"Villarreal\",\"away_team\":\"Liverpool\",\"bookmakers\":[{\"key\":\"unibet\",\"title\":\"Unibet\",\"last_update\":\"2022-04-28T19:45:17Z\",\"markets\":[{\"key\":\"h2h\",\"outcomes\":[{\"name\":\"Liverpool\",\"price\":1.65},{\"name\":\"Villarreal\",\"price\":5.2},{\"name\":\"Draw\",\"price\":3.9}]}]}]},{\"id\":\"438eb5dc631e420d65373bf151caf8eb\",\"sport_key\":\"soccer_uefa_champs_league\",\"sport_title\":\"UEFA Champions\",\"commence_time\":\"2022-05-04T19:00:00Z\",\"home_team\":\"Real Madrid\",\"away_team\":\"Manchester City\",\"bookmakers\":[{\"key\":\"unibet\",\"title\":\"Unibet\",\"last_update\":\"2022-04-28T19:45:17Z\",\"markets\":[{\"key\":\"h2h\",\"outcomes\":[{\"name\":\"Manchester City\",\"price\":2.05},{\"name\":\"Real Madrid\",\"price\":3.35},{\"name\":\"Draw\",\"price\":4.0}]}]}]}]".utf8)
    }
    
}

class APISpy: APIProtocol {
    
    var result: (Result<Data, APIError>) = .failure(.serviceError)
    var targetType: TargetType  = RequestType.sports
    func request(type: TargetType, completion: @escaping (Result<Data, APIError>) -> ()) {
        targetType = type
        completion(result)
    }
    
}

class BulletinViewModelDelegateSpy: BulletinViewModelDelegate {
    
    var reloadCollectionViewCalled = false
    var reloadTableViewCalled = false
    var showErrorMessageCalled = false
    var showLoadingCalled = false
    var hideLoadingCalled = false
    var reloadCartViewCalled = false
    var multiplierValue = 0.0
    var routeToCheckoutCalled = false
    var cartValue: CartProtocol?
    func reloadCollectionView() {
        reloadCollectionViewCalled = true
    }
    
    func reloadTableView() {
        reloadTableViewCalled = true
    }
    
    func showErrorMessage() {
        showErrorMessageCalled = true
    }
    
    func showLoading() {
        showLoadingCalled = true
    }
    
    func hideLoading() {
        hideLoadingCalled = true
    }
    
    func reloadCartView(multiplier: Double) {
        reloadCartViewCalled = true
        multiplierValue = multiplier
    }
    
    func routeToCheckout(cart: CartProtocol) {
        routeToCheckoutCalled = true
        cartValue = cart
    }
    
}

class FirebaseHelperSpy: FirebaseHelperProtocol {
    var sendEventCalled = true
    var eventValue = ""
    var parametersValue: [String: Any]?
    
    func sendEvent(_ event: String, parameters: [String : Any]?) {
        sendEventCalled = true
        eventValue = event
        parametersValue = parameters
    }
}
