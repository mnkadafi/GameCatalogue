//
//  DeveloperViewController.swift
//  GameCatalogue
//
//  Created by Mochamad Nurkhayal Kadafi on 10/07/20.
//  Copyright © 2020 Mochamad Nurkhayal Kadafi. All rights reserved.
//

import UIKit

class DeveloperViewController: UIViewController {

    @IBOutlet weak var developerCollection: UICollectionView!
    
    
    var developers = [DeveloperElement](){
        didSet{
            DispatchQueue.main.async {
                self.developerCollection.reloadData()
                self.removeLoadingScreen()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        developerCollection.dataSource = self
        developerCollection.register(UINib(nibName: "DeveloperCell", bundle:nil), forCellWithReuseIdentifier : "DeveloperCell")
        setLoadingScreen()
        defaultDevelopers()
    }
    
    func defaultDevelopers(){
        RawgServiceAPI.getAllDevelopers(completion: { (error, developerdata) in
            guard let developerdata = developerdata else{
                return
            }
            
            self.developers = developerdata
        })
    }
    
}

extension DeveloperViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return developers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DeveloperCell", for: indexPath) as? DeveloperCell
        
        let developerData = developers[indexPath.row]

        loadImageData(developers: developerData, forCell: cell!)
    
        DispatchQueue.main.async {
            cell!.nameDeveloper.text = String(developerData.name)
            cell!.nameDeveloper.attributedText = underlineText(keyword: developerData.name)
            cell!.popularLabel.text = String(developerData.games_count)
            
            cell!.containerCell.layer.cornerRadius = 20
        }
        
        return cell!
    }
    
    func loadImageData(developers: DeveloperElement, forCell cell : DeveloperCell){
        DispatchQueue.global().async {
            do{
                let imageData = try Data.init(contentsOf: developers.image_background)
                    DispatchQueue.main.async {
                        cell.imageDeveloper.image = UIImage.init(data: imageData)
                    }
            }catch{
                print(error)
            }
        }
    }
}
