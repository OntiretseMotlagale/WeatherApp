import Foundation

class FavouritesViewModel {
    var favoritesList = UserDefaults.savedfavorites
    var favoriteListCount: Int {
        return favoritesList.count
    }
    func resetFavorites() {
        favoritesList = UserDefaults.savedfavorites
    }
}
