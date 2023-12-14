import Foundation

struct CurrentWeatherModel: Codable, Equatable {
    static func == (lhs: CurrentWeatherModel, rhs: CurrentWeatherModel) -> Bool {
        return lhs.name == rhs.name
    }
    
    var coord: Coordinates?
    var name: String?
    var main: MainData?
    var weather: [WeatherData]?
    var sys: Sys?
}
struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}
struct WeatherData: Codable {
    var id: Int
    var main: String?
    var description: String?
}
struct Coordinates: Codable {
    var lon: Float?
    var lat: Float?
}
struct MainData: Codable {
    var temp_max: Double?
    var temp: Double?
    var feels_like: Double?
    var temp_min: Double?
}
struct Forecast: Codable{
    var dt_txt: String?
    var main: MainData?
    var weather: [WeatherData]?
}

