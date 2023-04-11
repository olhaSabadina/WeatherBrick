//
//  WeatherBrickTests.swift
//  WeatherBrickTests
//
//  Created by Olya Sabadina on 2023-04-09.
//

import XCTest
@testable import WeatherBrick

final class WeatherBrickTests: XCTestCase {

    let weatherBrickViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "weather") { coder in
        return WeatherViewController(coder: coder, fechManager: MockWeatherFetchManager())
    }
    

    func testFoundWeatherForCityName() async throws {
        
        await weatherBrickViewController.fetchManager?.fetchWeatherForCityName(cityName: "Testing city should be London", completionhandler: { weatherModel in
            guard let weather = weatherModel else {return}
            
            XCTAssert(weather.nameCity == "London")
            XCTAssertEqual(weather.temp, 12.98)
        })
    }

    func testFoundWeatherForCoordinates() throws {
        
//        який спосіб кращий: цей що закоментований чи той що з expectation?
        
//        await weatherBrickViewController.fetchManager?.fetchWeatherForCoordinates(latitude: 50.4333, longitude: 30.5167, completionhandler: { weatherModel in
//            guard let weather = weatherModel else {return}
//            XCTAssertEqual(weather.temp, 16.48)
//            XCTAssert(weather.nameCity == "Kyiv")
//            XCTAssertFalse(weather.wind == 10)
//        })
        
        let expectation = expectation(description: "Weather data parsing for coordinates and found Kyiv ")
        var weather: WeatherModel?
        weatherBrickViewController.fetchManager?.fetchWeatherForCoordinates(latitude: 50.4333, longitude: 30.5167, completionhandler: { weatherModel in
            weather = weatherModel
            expectation.fulfill()
        })
        XCTAssertNotNil(weather)
        waitForExpectations(timeout: 15)
        XCTAssert(weather?.nameCity == "Kyiv")
        XCTAssertEqual(weather?.temp, 16.48)
    }
}
