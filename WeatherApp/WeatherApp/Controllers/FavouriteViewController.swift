import UIKit

class FavouriteViewController: UIViewController {
    
    var delegate: MainTabBarDelegate?
    var viewModel = FavouritesViewModel()
    
    @IBOutlet weak var favouriteTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favouriteTableView.delegate = self
        favouriteTableView.dataSource = self
        registerCell()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    func registerCell() {
        favouriteTableView.register(UINib(nibName: "FavouritesTableViewCell", bundle: nil), forCellReuseIdentifier: "FavouritesTableViewCell")
    }
    func setupView() {
        viewModel.resetFavorites()
        if viewModel.favoriteListCount == 0 {
            //            NoFavouritesText.text = "No favorite weather locations"
            favouriteTableView.isHidden = true
        } else {
            favouriteTableView.isHidden = false
            favouriteTableView.reloadData()
        }
    }
}

extension FavouriteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favoriteListCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouritesTableViewCell", for: indexPath) as! FavouritesTableViewCell
        cell.setup(location: viewModel.favoritesList[indexPath.row].name ?? "",
                   countryName: viewModel.favoritesList[indexPath.row].sys?.country ?? "")
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedWeatherLocation =  viewModel.favoritesList[indexPath.row]
        delegate?.transitionToHomeScreen(with: selectedWeatherLocation)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}
