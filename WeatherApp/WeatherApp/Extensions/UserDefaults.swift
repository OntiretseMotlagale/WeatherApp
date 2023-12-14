
import UIKit
import Foundation

extension UserDefaults {
    private enum Keys {
        static let favorites = "favorites"
    }
    static var savedfavorites: [CurrentWeatherModel] {
        get {
            guard let data = UserDefaults.standard.data(forKey: Keys.favorites) else {return []}
            do {
                let decoder = JSONDecoder()
                let weatherLocations = try decoder.decode([CurrentWeatherModel].self, from: data)
                return weatherLocations
            } catch {
                return []
            }
        }
        set {
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(newValue)
                UserDefaults.standard.set(data, forKey: Keys.favorites)
            } catch {
                print("Unable to Encode weather data (\(error))")
            }
        }
    }
    static func addToFavorites(_ weather: CurrentWeatherModel) {
        var currentFavorites = UserDefaults.savedfavorites
        currentFavorites.append(weather)
        print("saved")
        UserDefaults.savedfavorites = currentFavorites
    }
    static func isFavorite(_ weather: CurrentWeatherModel?) -> Bool {
        let favorites = UserDefaults.savedfavorites
        guard let weather = weather else  { return false }
        return favorites.contains(weather)
    }
}


