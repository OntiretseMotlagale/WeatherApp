import UIKit

class FavouritesTableViewCell: UITableViewCell {
    @IBOutlet weak var favouriteWeatherLocation: UILabel!
    @IBOutlet weak var countryName: UILabel!
    
    func setup(location: String, countryName: String) {
        self.favouriteWeatherLocation.text = "Location: \(location)"
        self.countryName.text = "Country: \(countryName)"
    }
}
