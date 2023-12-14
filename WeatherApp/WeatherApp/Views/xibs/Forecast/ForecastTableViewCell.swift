import UIKit

class ForecastTableViewCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var forecastTempLabel: UILabel!
    @IBOutlet weak var forecastIcon: UIImageView!
    
    func setWeatherForecast(weekday: String,
                            temparature: String) {
        dayLabel.text = weekday
        forecastTempLabel.text = "\(temparature)\("℃")"
    }
}
