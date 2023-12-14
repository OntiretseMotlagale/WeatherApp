import Foundation

class NetworkManager {
    typealias currentSuccess = (CurrentWeatherModel?, _ error: String?) ->()
    typealias forecastSuccess = (ForecastWeatherModel?, _ error: String?) ->()
    
    func getCurrentWeather(longitude: Float, latitude: Float, completed: @escaping currentSuccess) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=578feca10a590e86711974e85a838e7b&units=metric"
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard error == nil else {
                print ("error: \(error!)")
                //MARK: - Error to be visible to the user
                return
            }
            guard let data = data else {
                print("No data")
                return
            }
            let currentWeather = try? JSONDecoder().decode(CurrentWeatherModel.self, from: data)
            DispatchQueue.main.async {
                completed(currentWeather, nil)
            }
        }
        task.resume()
    }
    func getWeatherForecast(longitude: Float, latitude: Float, completed: @escaping forecastSuccess) {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=578feca10a590e86711974e85a838e7b&units=metric"
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
            guard error == nil else {
                print ("error: \(error!)")
                //MARK: - Error to be visible to the user
                return
            }
            guard let data = data else {
                return
            }
            let forecastWeather = try? JSONDecoder().decode(ForecastWeatherModel.self, from: data)
            DispatchQueue.main.async {
                completed(forecastWeather, nil)
            }
        }
        task.resume()
    }
}
