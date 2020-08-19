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
    @IBOutlet weak var websiteLabel: UILabel!
    
    private lazy var favoriteProvider: GamesDataProvider = { return GamesDataProvider() }()
    
    var idGame : Int?
    var game : DetailGameModel!
    var favorite : FavoriteGameModel!
    var idFavorite : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getGameDetail()
    }
    
    @IBAction func addFavoriteAction(_ sender: Any) {

        if let imageGame = self.gameImage.image, let dataImage = imageGame.pngData() as NSData? {
            favoriteProvider.addFavorite(idGame!, self.titleLabel.text!, self.descriptionLabel.text!, self.metacriticLabel.text!, self.releaseDateLabel.text!, dataImage as Data, self.websiteLabel.text!, self.ratingLabel.text!){
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Successful", message: "New favorite game has added.", preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "OK", style: .default) { (action) in
                        self.navigationController?.popViewController(animated: true)
                    })
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }else{
            print(Error.self)
        }
    }
    
    func getGameDetail(){
        
        if idGame != 0{
            RawgServiceAPI.getDetailGames(id: idGame!) { (error, game) in
                self.detailView(game: game, favorite: nil)
            }
        }else{
            self.detailView(game: nil, favorite: favorite)
        }
    }
    
    func detailView(game: DetailGameModel?, favorite: FavoriteGameModel?){
        
        if let game = game{
            DispatchQueue.main.async {
                self.loadImageDetail(urlImage: game)
            }
            
            let platforms = game.platforms?.map { (element) -> String in
                return element.platform.name
            }
            
            let genres = game.genres?.map { (element) -> String in
                return element.name
            }
            
            let developers = game.developers?.map { (element) -> String in
                return element.name
            }
            
            let publishers = game.publishers?.map { (element) -> String in
                return element.name
            }
            
            DispatchQueue.main.async {
                self.titleLabel.text = game.name_original
                self.ratingLabel.text = String("Rating \(game.rating!)")
                self.metacriticLabel.text = String("Metacritic \(game.metacritic!)")
                self.descriptionLabel.text = game.description!.withoutHtml
                self.releaseDateLabel.text = game.released!
                self.platformsLabel.text = platforms!.joined(separator: ", ")
                self.genreLabel.text = genres!.joined(separator: ", ")
                self.developersLabel.text = developers!.joined(separator: ", ")
                self.publisherLabel.text = publishers!.joined(separator: ", ")
                self.websiteLabel.text = String("\(game.website!)")
            }
            
            self.favoriteProvider.cekFavorite(idGame!) { (result) in
                if result == true{
                    DispatchQueue.main.async {
                        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "baseline_favorite_black_24pt"), style: .plain, target: self, action: #selector(self.removeFavorite))
                    }
                }else{
                    DispatchQueue.main.async {
                        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "baseline_favorite_border_black_24pt"), style: .plain, target: self, action: #selector(self.addFavorite))
                    }
                }
            }

        }else if let favorite = favorite {
            print(idFavorite!)
            DispatchQueue.main.async {
                self.gameImage.image = UIImage(data: favorite.background_image!)
                self.titleLabel.text = favorite.name_original
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "baseline_favorite_black_24pt"), style: .plain, target: self, action: #selector(self.removeFavorite))
            }
        }
    }
    
    func loadImageDetail(urlImage: DetailGameModel){
        DispatchQueue.global().async {
            guard urlImage.background_image != nil else {
                DispatchQueue.main.async{
                    self.gameImage.image = UIImage(named: "no_image.png")
                }
                return
            }
            do{
                let imageData = try Data.init(contentsOf: urlImage.background_image!)
                DispatchQueue.main.async {
                    self.gameImage.image = UIImage.init(data: imageData)
                }
            }catch{
                print("Memproses gambar bermasalah : \(error)")
            }
        }
    }
    
    @objc func removeFavorite(){
        favoriteProvider.removeFavorite((idFavorite ?? idGame)!) {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Successful", message: "Favorite game has removed.", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "OK", style: .default) { (action) in
                    self.navigationController?.popViewController(animated: true)
                })
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func addFavorite(){
        let image = self.gameImage.image
        let imageGame = image?.pngData() as NSData?
        
        favoriteProvider.addFavorite(idGame!, self.titleLabel.text!, self.descriptionLabel.text!, self.metacriticLabel.text!, self.releaseDateLabel.text!, imageGame! as Data, self.websiteLabel.text!, self.ratingLabel.text!) {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Successful", message: "Favorite game has added.", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "OK", style: .default) { (action) in
                    self.navigationController?.popViewController(animated: true)
                })
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
