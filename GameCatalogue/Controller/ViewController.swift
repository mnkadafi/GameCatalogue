//
//  ViewController.swift
//  GameCatalogue
//
//  Created by Mochamad Nurkhayal Kadafi on 07/07/20.
//  Copyright © 2020 Mochamad Nurkhayal Kadafi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBarTable: UISearchBar!
    @IBOutlet weak var tableGames: UITableView!
    
    var games = [GameResults](){
        didSet {
             DispatchQueue.main.async {
                 self.tableGames.reloadData()
             }
         }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableGames.delegate = self
        searchBarTable.delegate = self
        tableGames.dataSource = self
        tableGames.register(UINib(nibName: "GamesCell", bundle:nil), forCellReuseIdentifier : "GamesCell")
        defaultPage()
    }
    
    func defaultPage(){
        
        RawgServiceAPI.getAllData(page_size: 5, completion: { (error, games) in
            guard let games = games else {
                self.alertError(message: error!)
                return
            }
            
            self.games = games
        })
    }
}

extension ViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text else { return }
        
        if !searchText.isEmpty{
            guard let encodedString = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
            
            RawgServiceAPI.getDataByTitle(title: encodedString, completion: {(error, dataSearch) in
                if let error = error {
                    self.alertError(message: error)
                    return
                } else if let dataSearch = dataSearch {
                    self.games = dataSearch
                }
            })
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        searchBar.text = ""
        defaultPage()
    }
}

extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GamesCell", for: indexPath) as! GamesCell
        
        let game = games[indexPath.row]

        loadImageCell(game: game, forCell: cell)
        
        let platforms = game.platforms!.map { (element) -> String in
            return element.platform.name!
        }
        
        let genres = game.genres!.map { (element) -> String in
            return element.name
        }

        
        cell.titleLabel.text = game.name
        cell.releaseDateLabel.text = "Release Date : \(String(describing: game.released!))"
        cell.genreLabel.text = genres.joined(separator: ", ")
        cell.ratingLabel.text = "Rating: " + String(game.rating!.string)
        cell.platformLabel.text = "Platforms: \(platforms.joined(separator: ", "))"
        cell.gameImage.layer.cornerRadius = 20
        cell.gameImage.clipsToBounds = true
        
        return cell
    }
    
    func loadImageCell(game: GameResults, forCell cell: GamesCell){
        DispatchQueue.global().async {
            guard game.background_image != nil else {
                DispatchQueue.main.async{
                    cell.gameImage.image = UIImage(named: "no_image.png")
                }
                return
            }
            do{
                let imageData = try Data.init(contentsOf: game.background_image!)
                DispatchQueue.main.async {
                    cell.gameImage.image = UIImage.init(data: imageData)
                }
            }catch{
                print("Memproses gambar bermasalah : \(error)")
            }
        }
    }
    
    func alertError(message: Error){
        let alertController = UIAlertController(title: "Error", message: "\(String(describing: message))", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = storyboard?.instantiateViewController(withIdentifier: "detailStoryboard") as! DetailViewController
        detail.selectData = games[indexPath.row]
        
        self.navigationController?.pushViewController(detail, animated: true)
    }
}
