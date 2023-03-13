//
//  WeatherFatchManager.swift
//  WeatherBrick
//
//  Created by Olya Sabadina on 2023-03-13.
//

import Foundation

struct FetchWeatherManager {
    
    func fetchWeather(latitude: Double, longitude: Double, completionhandler: @escaping (FinalWeather?)->()){
        let session = URLSession.shared
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=f2085fa546a323d778ef788c6b934414&units=metric&lang=uk") else {return}
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            guard error == nil, let data = data else {
                print("___Data Task = \(String(describing: error?.localizedDescription))")
                print("___data = nil")
                DispatchQueue.global().asyncAfter(deadline: .now() + 3){
                    completionhandler(nil)
                }
                return
            }
            if let response = response as? HTTPURLResponse,
               !(200...299).contains(response.statusCode) {
                print("___Response error code = \(response.statusCode)")
            }
            if let weather = parseJSON(data: data) {
                completionhandler(weather)
            }
        }
        task.resume()
    }
    
    func parseJSON(data: Data) -> FinalWeather? {
       
        let decoder = JSONDecoder()
        
        do{
            let weatherData = try decoder.decode(WeatherData.self, from: data)
            guard let finalWeather = FinalWeather(weatherData: weatherData) else { return nil
            }
            return finalWeather
            
        } catch let error as NSError {
            print("Error parsing JSON", error.localizedDescription)
        }
        return nil
    }
    
}
