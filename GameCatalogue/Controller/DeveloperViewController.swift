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
    override func viewDidLoad() {
        super.viewDidLoad()

        developerCollection.dataSource = self
        developerCollection.register(UINib(nibName: "DeveloperCell", bundle:nil), forCellWithReuseIdentifier : "DeveloperCell")
    }
}

extension DeveloperViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DeveloperCell", for: indexPath) as! DeveloperCell
        
        cell.popularLabel.text = "100"
        
        cell.containerCell.layer.cornerRadius = 20
        cell.containerCell.clipsToBounds = true
        
        return cell
    }
    
    
}
