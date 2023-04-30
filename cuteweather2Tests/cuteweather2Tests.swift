//
//  cuteweather2Tests.swift
//  cuteweather2Tests
//
//  Created by Justin Brady on 4/27/23.
//

import XCTest
import SwiftUI
import MapKit

@testable import cuteweather2

final class cuteweather2Tests: XCTestCase {
    
    var tmp = CuteMapViewRepresentable()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
        // see cuteWeatherTest extension
        let model = WeatherViewModel()
//        let mark = MKPlacemark(coordinate: CLLocationCoordinate2D(), addressDictionary: ["City": "san francisco"])
//        model.goToThere(mark)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testWeatherAPI() {
        let api = WeatherAPI()
        
        var done = XCTestExpectation()
        
        var q = WeatherQuery()
        q.city = "San Francisco"
        
        api.query(&q) {
            [weak self] resp in
            done.fulfill()
        }
        
        XCTWaiter().wait(for: [done], timeout: 4.0)
    }
}
