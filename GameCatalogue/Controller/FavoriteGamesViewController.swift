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
    
    var favorite = [FavoriteGameModel](){
        didSet{
            DispatchQueue.main.async {
                self.tableFavorite.reloadData()
                self.removeLoadingScreen()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavoriteGames()
    }
    
    func loadFavoriteGames(){
        self.favoriteProvider.getAllFavorite { (results) in
            DispatchQueue.main.async {
                self.favorite = results
                self.tableFavorite.reloadData()
            }
        }
    }
    
    func setupView(){
        tableFavorite.dataSource = self
        tableFavorite.delegate = self
        searchBarFavorite.delegate = self
        tableFavorite.register(UINib(nibName: "FavoriteCell", bundle: nil), forCellReuseIdentifier: "FavoriteCell")
        setLoadingScreen()
    }
    
}

extension FavoriteGamesViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text else{
            print("Error")
            return
        }
        
        if !searchText.isEmpty{
            guard let encodedString = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
                print("Error")
                return
            }
            
            favoriteProvider.searchByTitle(encodedString, completion: { (favorites) in
                self.favorite = favorites
            })
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        if searchBar.text != nil{
            self.setLoadingScreen()
            favoriteProvider.getAllFavorite { (favorites) in
                self.favorite = favorites
            }
        }
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
            
            let genres = favoriteList.genres?.map { (element) -> String in
                return element.name
            }
    
            let platform = favoriteList.platforms?.map { (element) -> String in
                return element.name
            }
            
            cell.genresFavorite.text = genres!.joined(separator: ", ")
            cell.ratingFavorite.text = "Rating \(favoriteList.rating!)"
            cell.platformFavorite.text = platform!.joined(separator: ", ")
            
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


