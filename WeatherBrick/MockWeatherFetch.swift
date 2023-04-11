//
//  MockWeatherFetch.swift
//  WeatherBrick
//
//  Created by Olya Sabadina on 2023-04-10.
//

import Foundation

class MockWeatherFetchManager: FetchWeatherProtocol {
    
    func fetchWeatherForCoordinates(latitude: Double, longitude: Double, completionhandler: @escaping (WeatherModel?) -> ()) {
        let url = Bundle.main.url(forResource: "MockKyiv", withExtension: "json")
        guard let data = try? Data(contentsOf: url!) else {return}
        
        do {
            let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
            
            guard let weatherModel = WeatherModel(weatherData: weatherData) else
            {return}
            
            completionhandler(weatherModel)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    func fetchWeatherForCityName(cityName: String, completionhandler: @escaping (WeatherModel?) -> ()) {
        
        let url = Bundle.main.url(forResource: "MockLondon", withExtension: "json")
        print(url!)
        guard let data = try? Data(contentsOf: url!) else {return}
        
        do {
            let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
            
            guard let weatherModel = WeatherModel(weatherData: weatherData) else {return}
            
            completionhandler(weatherModel)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
}

