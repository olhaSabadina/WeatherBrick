//
//  WeatherBrickUITests.swift
//  WeatherBrickUITests
//
//  Created by Olya Sabadina on 2023-04-11.
//

import XCTest
@testable import WeatherBrick

final class WeatherBrickUITests: XCTestCase {
    
    func testFetchWeatherFromStartCoordinatesTrue() {
        let app = XCUIApplication()
        app.launch()
        XCTAssert(app.staticTexts["Kyiv, UA"].exists)
    }
    
    func testSearchByCityNameTrue() {
        let app = XCUIApplication()
        app.launch()
        let iconSearch = app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .button).element(boundBy: 1)
        XCTAssert(iconSearch.exists)
        iconSearch.tap()
        app.alerts["You can selected city"].scrollViews.otherElements.collectionViews/*@START_MENU_TOKEN@*/.textFields["Enter city name"]/*[[".cells.textFields[\"Enter city name\"]",".textFields[\"Enter city name\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.typeText("London")
        app.alerts["You can selected city"].scrollViews.otherElements.buttons["OK"].tap()
        XCTAssert(app.staticTexts["London, GB"].exists)
    }
    
    func testFetchWeatherFromIconCoordinatesTrue() {
        let app = XCUIApplication()
        app.launch()
        testSearchByCityNameTrue()
        let window = app.children(matching: .window).element(boundBy: 0)
        window.tap()
        window.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .button).element(boundBy: 0).tap()
        XCTAssert(app.staticTexts["Kyiv, UA"].exists)
    }
    
    func testFetchWeatherFromBrickSwipeDownTrue() {
        let app = XCUIApplication()
        app.launch()
       testSearchByCityNameTrue()
        app.scrollViews.children(matching: .other).element(boundBy: 0).swipeDown()
        XCTAssert(app.staticTexts["Kyiv, UA"].exists)
    }
    
    func testExistsInfoMenuTrue() throws {
        let app = XCUIApplication()
        app.launch()
        app/*@START_MENU_TOKEN@*/.staticTexts["INFO"]/*[[".buttons[\"INFO\"].staticTexts[\"INFO\"]",".staticTexts[\"INFO\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssert(app.staticTexts["Hide"].exists)
        app/*@START_MENU_TOKEN@*/.staticTexts["Hide"]/*[[".buttons[\"Hide\"].staticTexts[\"Hide\"]",".staticTexts[\"Hide\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssert(app.staticTexts["INFO"].exists)
    }
}
