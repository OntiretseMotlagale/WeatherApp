import UIKit

protocol MainTabBarDelegate {
    func transitionToHomeScreen(with selectedLocation: CurrentWeatherModel?)
}

class MainTabBarController: UITabBarController {
    let viewModel: HomeScreenViewModel
    init(viewModel: HomeScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "FavouriteTableViewCell", bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        self.tabBar.tintColor = .green
        self.tabBar.unselectedItemTintColor = .gray
    }
    private func setupTabs() {
        let home = self.createNav(with: "Home", and: (UIImage(systemName: "house.fill")), viewController: HomeViewControllers())
        let favourite = self.createNav(with: "Favourite", and: UIImage(systemName: "star.fill"), viewController: FavouriteViewController())
        let map = self.createNav(with: "Map", and: UIImage(systemName: "map.fill"), viewController: MapViewController())
        self.setViewControllers([home, favourite, map], animated: true)
    }
    private func createNav(with title: String, and image: UIImage?, viewController: UIViewController) -> UINavigationController {

        let nav = UINavigationController(rootViewController: viewController)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        return nav
    }
}

