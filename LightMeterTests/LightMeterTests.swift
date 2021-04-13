//
//  LightMeterTests.swift
//  LightMeterTests
//
//  Created by kamikuo on 2021/4/9.
//

import XCTest
@testable import LightMeter

class LightMeterTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        print(ExposureValue(rawValue: Float(-5)).speed(withAperture: 1.0, iso: 100))
        print(ExposureValue(rawValue: Float(-4)).speed(withAperture: 1.0, iso: 100))
        print(ExposureValue(rawValue: Float(-3)).speed(withAperture: 1.0, iso: 100))
        print(ExposureValue(rawValue: Float(-2)).speed(withAperture: 1.0, iso: 100))
        print(ExposureValue(rawValue: Float(-1)).speed(withAperture: 1.0, iso: 100))
        print(ExposureValue(rawValue: Float(0)).speed(withAperture: 1.0, iso: 100))
        print(ExposureValue(rawValue: Float(1)).speed(withAperture: 1.0, iso: 100))
        print(ExposureValue(rawValue: Float(2)).speed(withAperture: 1.0, iso: 100))
        print(ExposureValue(rawValue: Float(3)).speed(withAperture: 1.0, iso: 100))
        print(ExposureValue(rawValue: Float(4)).speed(withAperture: 1.0, iso: 100))
    }
    
    
    func testPerformanceExample2() throws {
        // This is an example of a performance test case.
        self.measure {
        }
    }

}
