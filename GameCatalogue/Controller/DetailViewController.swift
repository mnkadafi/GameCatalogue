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
    @IBOutlet weak var developersLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var systemRequirementLabel: UILabel!
    
    var selectData : GameResults?
    var detailGame : DetailGameModel?
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getGameDetail()
//        detailView(detailGame: detailGame!)
    }
    
    func getGameDetail(){
        RawgServiceAPI.getDetailGames(id: selectData!.id) { (error, game) in
            if let error = error {
                print("Error : \(error.localizedDescription)")
            }else if let game = game{
                print(game)
                self.detailView(detailGame: game)
            }
        }
    }
    
    func detailView(detailGame: DetailGameModel){
        DispatchQueue.main.async {
            self.gameImage.image = self.image
        }
        
        DispatchQueue.main.async {
            self.titleLabel.text = detailGame.name_original
            self.ratingLabel.text = String("Rating \(detailGame.rating)")
            self.metacriticLabel.text = String("Metacritic \(detailGame.metacritic)")
            self.descriptionLabel.text = detailGame.description
        }
    }
}
