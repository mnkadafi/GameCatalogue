//
//  ProfileModel.swift
//  GameCatalogue
//
//  Created by Mochamad Nurkhayal Kadafi on 27/07/20.
//  Copyright © 2020 Mochamad Nurkhayal Kadafi. All rights reserved.
//

import Foundation

struct ProfileModel{
    static let stateLoginKey = "state"
    static let nameKey = "name"
    static let professionKey = "profession"
    
    static var stateLogin : Bool{
        get{
            return UserDefaults.standard.bool(forKey: stateLoginKey)
        }
        set{
            UserDefaults.standard.set(newValue, forKey: stateLoginKey)
        }
    }
    
    static var name : String{
        get{
            return UserDefaults.standard.string(forKey: nameKey) ?? ""
        }
        set{
            UserDefaults.standard.set(newValue, forKey: nameKey)
        }
    }
    
    static var profession : String{
        get{
            return UserDefaults.standard.string(forKey: professionKey) ?? ""
        }
        set{
            UserDefaults.standard.set(newValue, forKey: professionKey)
        }
    }
    
    static func synchronize(){
        UserDefaults.standard.synchronize()
    }
}
