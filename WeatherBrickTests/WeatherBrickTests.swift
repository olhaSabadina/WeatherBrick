//
//  WeatherBrickTests.swift
//  WeatherBrickTests
//
//  Created by Olya Sabadina on 2023-04-09.
//

import XCTest
@testable import WeatherBrick

final class WeatherBrickTests: XCTestCase {
    
    let sut = DefiniteWeatherFetchManager()

    func testFoundWeatherForCityName() throws {
        
        sut.fetchWeatherForCityName(cityName: "Testing city should be London", completionhandler: { weatherModel in
            guard let weather = weatherModel else {return}
            
            XCTAssert(weather.nameCity == "London")
            XCTAssertEqual(weather.temp, 12.98)
        })
    }
    
    func testFoundWeatherForCoordinates() throws {
                
        let expectation = expectation(description: "Weather data parsing for coordinates and found Kyiv ")
        var weather: WeatherModel?
        sut.fetchWeatherForCoordinates(latitude: 50.4333, longitude: 30.5167, completionhandler: { weatherModel in
            weather = weatherModel
            expectation.fulfill()
        })
        XCTAssertNotNil(weather)
        waitForExpectations(timeout: 15)
        XCTAssert(weather?.nameCity == "Kyiv")
        XCTAssertEqual(weather?.temp, 16.48)
    }
}
