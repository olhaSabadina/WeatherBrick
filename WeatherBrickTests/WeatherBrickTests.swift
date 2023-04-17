//
//  WeatherBrickTests2.swift
//  WeatherBrickTests
//
//  Created by Olya Sabadina on 2023-04-17.
//

import XCTest
@testable import WeatherBrick

final class WeatherBrickTests: XCTestCase {
    
    let sut = FetchWeatherManager()
    
    func testFetchWeatherForCityNameTrue() {
        let expectation = expectation(description: "city")
        var weatherData : WeatherModel?
        
        sut.fetchWeatherForCityName(cityName: "London") { weather in
            guard let weather = weather else {return}
            print(weather.nameCity, "внутри теста")
            weatherData = weather
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
        XCTAssert(weatherData?.nameCity == "London")
    }
    
    func testFetchWeatherForCoordinatesTrue() {
        let expectation = expectation(description: "Weather for coordinates")
        var weatherData : WeatherModel?
        
        sut.fetchWeatherForCoordinates(latitude: 48.8534, longitude: 2.3488) { weather in
            guard let weather = weather else {return}
            print(weather.nameCity, "внутри теста lonlat")
            weatherData = weather
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
        XCTAssert(weatherData?.nameCity == "Paris")
    }
    
}
