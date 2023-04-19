//
//  WeatherFatchManager.swift
//  WeatherBrick
//
//  Created by Olya Sabadina on 2023-03-13.
//

import Foundation

protocol FetchWeatherProtocol {
    
    func fetchWeatherForCoordinates(latitude: Double, longitude: Double, completionhandler: @escaping (WeatherModel?)->())
    
    func fetchWeatherForCityName(cityName: String, completionhandler: @escaping (WeatherModel?)->())
    
}

struct FetchWeatherManager: FetchWeatherProtocol {
    
    func fetchWeatherForCoordinates(latitude: Double, longitude: Double, completionhandler: @escaping (WeatherModel?)->()){
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=f2085fa546a323d778ef788c6b934414&units=metric&lang=uk") else {return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil, let data = data else {
                completionhandler(nil)
                return
            }
            if let response = response as? HTTPURLResponse,
               !(200...299).contains(response.statusCode) {
                completionhandler(nil)
            }
            
            if let weather = parseJSON(data: data) {
                completionhandler(weather)
            }
        }
        task.resume()
    }
    
    func fetchWeatherForCityName(cityName: String, completionhandler: @escaping (WeatherModel?)->()){
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=f2085fa546a323d778ef788c6b934414&units=metric&lang=uk") else {
            completionhandler(nil)
            return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil, let data = data else {
                completionhandler(nil)
                return
            }
            if let response = response as? HTTPURLResponse,
               !(200...299).contains(response.statusCode) {
                completionhandler(nil)
            }
            if let weather = parseJSON(data: data) {
                completionhandler(weather)
            }
        }
        task.resume()
    }
    
    private func parseJSON(data: Data) -> WeatherModel? {
        
        let decoder = JSONDecoder()
        
        do{
            let weatherData = try decoder.decode(WeatherData.self, from: data)
            guard let finalWeather = WeatherModel(weatherData: weatherData) else { return nil
            }
            return finalWeather
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
    
}
