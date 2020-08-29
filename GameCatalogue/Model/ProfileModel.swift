//
//  ProfileModel.swift
//  GameCatalogue
//
//  Created by Mochamad Nurkhayal Kadafi on 27/07/20.
//  Copyright © 2020 Mochamad Nurkhayal Kadafi. All rights reserved.
//

import Foundation

struct ProfileModel{
    static let nameKey = "name"
    static let professionKey = "profession"
    
    static var name : String{
        get{
            return UserDefaults.standard.string(forKey: nameKey) ?? "Mochamad Nurkhayal Kadafi"
        }
        set{
            UserDefaults.standard.set(newValue, forKey: nameKey)
        }
    }
    
    static var profession : String{
        get{
            return UserDefaults.standard.string(forKey: professionKey) ?? "Mahasiswa"
        }
        set{
            UserDefaults.standard.set(newValue, forKey: professionKey)
        }
    }
    
    static func synchronize(){
        UserDefaults.standard.synchronize()
    }
}
