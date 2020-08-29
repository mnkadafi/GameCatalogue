//
//  UpdateProfileViewController.swift
//  GameCatalogue
//
//  Created by Mochamad Nurkhayal Kadafi on 27/07/20.
//  Copyright © 2020 Mochamad Nurkhayal Kadafi. All rights reserved.
//

import UIKit

class UpdateProfileViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var professionTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ProfileModel.synchronize()
        nameTextField.text = ProfileModel.name
        professionTextField.text = ProfileModel.profession
    }
    
    @IBAction func saveProfile(_ sender: Any) {
        if let name = nameTextField.text, let profession = professionTextField.text{
            if name.isEmpty{
                textEmpty("Name")
            }else if profession.isEmpty{
                textEmpty("Profession")
            }else{
                saveProfile(name, profession)
                
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func saveProfile(_ name: String, _ profession: String){
        ProfileModel.name = name
        ProfileModel.profession = profession
    }
    
    func textEmpty(_ field: String){
        let alert = UIAlertController(title: "Info", message: "\(field) can't be empty", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
