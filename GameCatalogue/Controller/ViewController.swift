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
        tableGames.dataSource = self
        tableGames.register(UINib(nibName: "GamesCell", bundle:nil), forCellReuseIdentifier : "GamesCell")
        defaultPage()
    }
    
    func defaultPage(){
        
        RawgServiceAPI.getAllData(page_size: "3", completion: { (error, games) in
            guard let games = games else {
                let alertController = UIAlertController(title: "Error Occured", message: "\(error!.localizedDescription)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            self.games = games
        })
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
        
        let platforms = game.platforms.map { (element) -> String in
            return element.platform.name
        }
        
        let genres = game.genres.map { (element) -> String in
            return element.name
        }
        
        cell.titleLabel.text = game.name
        cell.releaseDateLabel.text = "Release Date : "+game.released
        cell.genreLabel.text = genres.joined(separator: ", ")
        cell.ratingLabel.text = "Rating: \(game.rating)"
        cell.platformLabel.text = "Platforms: \(platforms.joined(separator: ", "))"
        
        cell.gameImage.layer.cornerRadius = 20
        cell.gameImage.clipsToBounds = true
        
        return cell
    }
    
    func loadImageCell(game: GameResults, forCell cell: GamesCell){
        DispatchQueue.main.async {
            do{
                let imageData = try Data.init(contentsOf: game.background_image)
                DispatchQueue.main.async {
                    cell.gameImage.image = UIImage.init(data: imageData)
                }
            }catch{
                print("Memproses gambar bermasalah : \(error)")
            }
        }
    }
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = storyboard?.instantiateViewController(withIdentifier: "detailStoryboard") as! DetailViewController
        detail.selectData = games[indexPath.row]
        
        self.navigationController?.pushViewController(detail, animated: true)
    }
}
