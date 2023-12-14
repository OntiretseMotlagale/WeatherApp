
import UIKit
import CoreLocation

class HomeViewControllers: UIViewController {
    @IBOutlet weak var mainTempLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var forecastTableView: UITableView!
    @IBOutlet weak var favouriteButton: UIButton!
    
    var locationManager = CLLocationManager()
    lazy var viewModel = HomeScreenViewModel(networkManager: NetworkManager(),
                                             currentWeather: CurrentWeatherModel(),
                                                     forecastWeather: ForecastWeatherModel())
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        rightBarButton()
    }
    
    @objc func addFavourite() {
        viewModel.updateFavorites()
    }
    private func setupUI() {
        viewModel.fetchWeather {
            self.updateData()
        }
    }
    
    func rightBarButton() {
        let rightButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(addFavourite))
        navigationItem.rightBarButtonItem = rightButton
        rightButton.image = viewModel.rightBarButtonImage()
        rightButton.tintColor = .red
    }
    func registerCell() {
        forecastTableView.register(UINib(nibName: "ForecastTableViewCell", bundle: nil), forCellReuseIdentifier: "ForecastTableViewCell")
    }
    func updateData() {
        self.mainImage.image = UIImage(named: viewModel.conditionID)
        self.mainTempLabel.text = ("\(self.viewModel.currentTemp)\("℃")")
        self.currentTempLabel.text = ("\(self.viewModel.currentTemp)\("℃")")
        self.weatherDescriptionLabel.text = self.viewModel.conditionID
        self.minTempLabel.text = ("\(self.viewModel.minTemp)\("℃")")
        self.maxTempLabel.text = ("\(self.viewModel.maxTemp)\("℃")")
        self.forecastTableView.reloadData()
    }
    func update(with currentWeather: CurrentWeatherModel?) {
        viewModel.currentWeather = currentWeather ?? CurrentWeatherModel()
        updateData()
    }
    private func dateFormatter(dateTimeString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: dateTimeString) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            let dayName = dateFormatter.string(from: date)
            return dayName
        } else {
            print("Invalid date format")
            return dateTimeString
        }
    }
}
extension HomeViewControllers: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            DispatchQueue.main.async {
                let lat = location.coordinate.latitude
                let lon = location.coordinate.longitude
                self.viewModel.lat = Float(lat)
                self.viewModel.long = Float(lon)
                self.setupUI()
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        //MARK: - Error need to be visible to the user. 
    }
}
  extension HomeViewControllers: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastTableViewCell", for: indexPath) as! ForecastTableViewCell
        cell.setWeatherForecast(weekday: dateFormatter(dateTimeString: viewModel.forecastWeather.list?[indexPath.row].dt_txt ?? ""),
        temparature: viewModel.tempArray[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(70)
    }
}
