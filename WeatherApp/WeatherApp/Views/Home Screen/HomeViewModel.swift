import UIKit

class HomeScreenViewModel {
   
    var networkManager: NetworkManager
    var currentWeather: CurrentWeatherModel
    var forecastWeather: ForecastWeatherModel
    var dates = [String]()
    var long: Float?
    var lat: Float?
    init(networkManager: NetworkManager,
         currentWeather: CurrentWeatherModel,
         forecastWeather: ForecastWeatherModel) {
        self.networkManager = networkManager
        self.currentWeather = currentWeather
        self.forecastWeather = forecastWeather
    }
    var mainWeatherDescription: String {
        return currentWeather.weather?.first?.main ?? ""
    }
    var currentTemp: String {
        guard let currentTemp = currentWeather.main?.temp else {
            return ""
        }
        return String(format:"%.0f", currentTemp)
    }
    var minTemp: String {
        guard let mainTemp = currentWeather.main?.temp_min else {
            return ""
        }
        return String(format:"%.0f", mainTemp)
    }
    var conditionID: String {
        switch currentWeather.weather?.first?.id  ?? 0 {
        case 200...232:
            return "Thunderstorm"
        case 300...321:
            return "Sunny"
        case 500...531:
            return "Rainy"
        case 600...622:
            return "Snow"
        case 701...781:
            return "Sunny"
        case 800:
            return "clear"
        case 801...804:
            return "Cloudy"
        default:
            return "Default"
        }
    }
    
    var weatherID: String {
        switch currentWeather.weather?.first?.id ?? 0 {
        case 200...232:
            return "thunderstorm"
        case 300...321:
            return "clear"
        case 500...531:
            return "rain"
        case 600...622:
            return "snow"
        case 701...781:
            return "snow"
        case 800:
            return "clear"
        case 801...804:
            return "sunny"
        default:
            return "Default"
        }
    }
    var maxTemp: String {
        guard let maxTemp = currentWeather.main?.temp_max else {
            return ""
        }
        return String(format:"%.0f", maxTemp)
    }
    
    var listCount: Int {
        return forecastWeather.list?.count ?? Int()
    }
    
    var weatherArray: [Forecast] {
        return forecastWeather.list ?? []
    }
    
    var tempArray: [String] {
        var temps = [String]()
        for weather in weatherArray {
            guard let forecastTemp = weather.main?.temp else {
                return []
            }
            let temp = String(format:"%.0f", forecastTemp)
            temps.append(temp)
        }
        return temps
    }
    func savefavorite(weather: CurrentWeatherModel) {
        UserDefaults.addToFavorites(weather)
    }
    
    func updateFavorites() {
        if UserDefaults.isFavorite(currentWeather) {
            removeFromFavorites(country: currentWeather)
        } else {
            savefavorite(weather: currentWeather)
        }
    }
    
    func rightBarButtonImage() -> UIImage? {
        if UserDefaults.isFavorite(currentWeather) {
            return UIImage(systemName: "heart.fill")
        }
        return UIImage(systemName: "heart.fill")
    }
    func removeFromFavorites(country: CurrentWeatherModel) {
        UserDefaults.savedfavorites.removeAll(where: { $0.name == country.name })
    }
    
    func fetchWeather(completed: @escaping () ->()) {
        if let longitude = long, let lattitude = lat {
            DispatchQueue.main.async {
                self.networkManager.getCurrentWeather(longitude: longitude, latitude: lattitude) { (response, error) in
                    self.currentWeather = response ?? CurrentWeatherModel()
                    completed()
                }
                self.networkManager.getWeatherForecast(longitude: self.long ?? Float(), latitude: self.lat ?? Float()) { (response, error) in
                    self.forecastWeather = response ?? ForecastWeatherModel()
                    completed()
                }
            }
        }
    }
}
