//
//  DetailViewController.swift
//  GameCatalogue
//
//  Created by Mochamad Nurkhayal Kadafi on 09/07/20.
//  Copyright © 2020 Mochamad Nurkhayal Kadafi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var metacriticLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var platformsLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var developersLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var systemRequirementLabel: UILabel!
    
    var selectData : GameResults?
    var detailGame : DetailGameModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getGameDetail()
    }
    
    func getGameDetail(){
        RawgServiceAPI.getDetailGames(id: selectData!.id) { (error, game) in
            if let error = error {
                print("Error : \(error)")
            }else if let game = game{
                self.detailView(detailGame: game)
            }
        }
    }
    
    func detailView(detailGame: DetailGameModel){
        DispatchQueue.main.async {
            self.loadImageDetail(urlImage: detailGame)
            
            let platforms = detailGame.platforms.map { (element) -> String in
                return element.platform.name
            }
            
            let genres = detailGame.genres.map { (element) -> String in
                return element.name
            }
            
            let developers = detailGame.developers.map { (element) -> String in
                return element.name
            }
            
            let publishers = detailGame.publishers.map { (element) -> String in
                return element.name
            }
            
            let aboutGame = detailGame.description

            self.titleLabel.text = detailGame.name_original
            self.ratingLabel.text = String("Rating \(detailGame.rating)")
            self.metacriticLabel.text = String("Metacritic \(detailGame.metacritic)")
            self.descriptionLabel.text = aboutGame.withoutHtml
            self.releaseDateLabel.text = detailGame.released
            self.platformsLabel.text = platforms.joined(separator: ", ")
            self.genreLabel.text = genres.joined(separator: ", ")
            self.developersLabel.text = developers.joined(separator: ", ")
            self.publisherLabel.text = publishers.joined(separator: ", ")
        }
    }
    
    func loadImageDetail(urlImage: DetailGameModel){
        DispatchQueue.global().async {
            do{
                let imageData = try Data.init(contentsOf: urlImage.background_image)
                DispatchQueue.main.async {
                    self.gameImage.image = UIImage.init(data: imageData)
                }
            }catch{
                print("Memproses gambar bermasalah : \(error)")
            }
        }
    }
}
