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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageProfile.layer.cornerRadius = 10
        imageProfile.clipsToBounds = true
    }
}
