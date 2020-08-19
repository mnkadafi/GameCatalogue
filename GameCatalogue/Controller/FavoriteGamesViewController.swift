//
//  FavoriteGamesViewController.swift
//  GameCatalogue
//
//  Created by Mochamad Nurkhayal Kadafi on 25/07/20.
//  Copyright © 2020 Mochamad Nurkhayal Kadafi. All rights reserved.
//

import UIKit

class FavoriteGamesViewController: UIViewController {
    @IBOutlet weak var searchBarFavorite: UISearchBar!
    @IBOutlet weak var tableFavorite: UITableView!
    private lazy var favoriteProvider: GamesDataProvider = { return GamesDataProvider() }()
    
    var favorite: [FavoriteGameModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavoriteGames()
    }
    
    func loadFavoriteGames(){
        self.favoriteProvider.getAllMember { (results) in
            DispatchQueue.main.async {
                self.favorite = results
                self.tableFavorite.reloadData()
            }
        }
    }
    
    func setupView(){
        tableFavorite.dataSource = self
        tableFavorite.delegate = self
        tableFavorite.register(UINib(nibName: "FavoriteCell", bundle: nil), forCellReuseIdentifier: "FavoriteCell")
    }
    
}

extension FavoriteGamesViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorite.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as? FavoriteCell {
            let favoriteList = favorite[indexPath.row]
            
            cell.imageFavorite.layer.cornerRadius = 20
            cell.imageFavorite.image = UIImage(data: favoriteList.background_image!)
            cell.titleFavorite.text = favoriteList.name_original!
            cell.releaseDateFavorite.text = "Release Date: \(favoriteList.released!)"
            
    //        let genres = favoriteList.genres?.map { (element) -> String in
    //            return element.name
    //        }
    //
    //        let platform = favoriteList.platforms?.map { (element) -> String in
    //            return element.platform.name
    //        }
            
            cell.genresFavorite.text = "Genres: Example"
            cell.ratingFavorite.text = favoriteList.rating!
            cell.platformFavorite.text = "Platform Data: Example"
            
            return cell
        }else{
            return UITableViewCell()
        }
    }
}

extension FavoriteGamesViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "HomeViewStoryboard", bundle: nil)
        let detailFavorite = storyboard.instantiateViewController(withIdentifier: "detailStoryboard") as? DetailViewController
        detailFavorite!.favorite = favorite[indexPath.row]
        detailFavorite?.idFavorite = favorite[indexPath.row].id
        detailFavorite?.idGame = 0
        
        self.navigationController?.pushViewController(detailFavorite!, animated: true)
    }
}
