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
    @IBOutlet weak var viewBelajarAkademi: UIView!
    @IBOutlet weak var viewMemenangkanChallange: UIView!
    @IBOutlet weak var viewMenghadiriEvent: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageProfile.layer.cornerRadius = 10
        imageProfile.clipsToBounds = true
        
        viewBelajarAkademi.layer.cornerRadius = 10
        viewBelajarAkademi.clipsToBounds = true
        
        viewMemenangkanChallange.layer.cornerRadius = 10
        viewMemenangkanChallange.clipsToBounds = true
        
        viewMenghadiriEvent.layer.cornerRadius = 10
        viewMenghadiriEvent.clipsToBounds = true
    }
}
