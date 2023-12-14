import XCTest
import CoreLocation
@testable import WeatherApp // Import your app module

class WeatherTests: XCTestCase {
    let favouritesViewModel = HomeScreenViewModel(networkManager: NetworkManager(),
                                                  currentWeather: CurrentWeatherModel(),
                                                  forecastWeather: ForecastWeatherModel())
    var systemUnderTest = HomeViewControllers()
    var tableView: UITableView!
    func testSaveFavorite() {
        // Given
        let weather = CurrentWeatherModel()
        // When
        favouritesViewModel.savefavorite(weather: weather)
        // Then
        let savedFavorites = UserDefaults.savedfavorites
        XCTAssertTrue(savedFavorites.contains(where: { $0 == weather }), "Weather should be saved to favorites")
    }
    func testIsFavoriteWhenWeatherIsInFavorites() {
        // Given
        let weather = CurrentWeatherModel()
        UserDefaults.savedfavorites = [weather]
        // When
        let isFavorite = UserDefaults.isFavorite(weather)
        // Then
        XCTAssertTrue(isFavorite, "Weather should be a favorite")
    }
    override func setUp() {
        super.setUp()
        systemUnderTest.loadViewIfNeeded()
        tableView = systemUnderTest.forecastTableView
    }
    func testForecastCellRegistration() {
        // When
        systemUnderTest.registerCell()
        // Then
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastTableViewCell")
        XCTAssertNotNil(cell, "Cell should be registered")
        XCTAssertTrue(cell is ForecastTableViewCell, "Registered cell should be of type ForecastTableViewCell")
    }
    
    func testMainImageUpdate() {
        // Given
        let expectedImage = UIImage(named: "Sunny") // Replace "Sunny" with your expected image name
        // When
        let mainImage = systemUnderTest.mainImage.image
        // Then
        XCTAssertNotEqual(mainImage, expectedImage, "Main image should be updated")
    }
    
    func testLabelsUpdate() {
        // Given
        let expectedCurrentTempText = "25℃" // Replace "25℃" with the expected temperature string
        // When
        let mainTempLabelText = systemUnderTest.mainTempLabel.text
        let currentTempLabelText = systemUnderTest.currentTempLabel.text
        // Then
        XCTAssertNotEqual(mainTempLabelText, expectedCurrentTempText, "Main temp label should be updated")
        XCTAssertNotEqual(currentTempLabelText, expectedCurrentTempText, "Current temp label should be updated")
    }
    
    func testTableViewReload() {
        // When
        let numberOfRows = systemUnderTest.forecastTableView.numberOfRows(inSection: 0)
        // Then
        XCTAssertEqual(numberOfRows, 0, "Table view should reload with data")
    }
}
