


import SnapshotTesting
import XCTest
@testable import WeatherBrick

class WeatherViewControllerTests: XCTestCase {
    
    var vc : WeatherViewController!
    
    override func setUp() {
        vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "weather", creator: { coder in
            WeatherViewController(coder: coder, fechManager: MockWeatherFetchManager())
        })
    }
    
    override func tearDown() {
        vc = nil
    }
    
    func testWeatherViewController() {
        assertSnapshot(matching: vc, as: .wait(for: 5, on: .image))
    }
    
    func testWeatherIndoView() {
        let infoView = InfoView()
        assertSnapshot(matching: infoView, as: .image)
    }
    
}



