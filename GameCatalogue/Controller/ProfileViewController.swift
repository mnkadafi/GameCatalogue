//
//  ProfileViewController.swift
//  GameCatalogue
//
//  Created by Mochamad Nurkhayal Kadafi on 08/07/20.
//  Copyright © 2020 Mochamad Nurkhayal Kadafi. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var professionLabel: UILabel!
    @IBOutlet weak var viewBelajarAkademi: UIView!
    @IBOutlet weak var viewMemenangkanChallange: UIView!
    @IBOutlet weak var viewMenghadiriEvent: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageProfile.layer.cornerRadius = 15
        viewBelajarAkademi.layer.cornerRadius = 10
        viewMemenangkanChallange.layer.cornerRadius = 10
        viewMenghadiriEvent.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ProfileModel.synchronize()
        nameLabel.text = ProfileModel.name
        professionLabel.text = ProfileModel.profession
    }
    
    
    @IBAction func editProfile(_ sender: Any) {
        self.performSegue(withIdentifier: "moveToEdit", sender: self)
    }
}
