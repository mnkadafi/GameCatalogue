//
//  ExtensionFile.swift
//  GameCatalogue
//
//  Created by Mochamad Nurkhayal Kadafi on 11/07/20.
//  Copyright © 2020 Mochamad Nurkhayal Kadafi. All rights reserved.
//

import Foundation
import UIKit

func underlineText(keyword: String) -> NSAttributedString{
    let attributedString = NSMutableAttributedString.init(string: "\(keyword)")
    attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range:
        NSRange.init(location: 0, length: attributedString.length));
    
    return attributedString
}

extension LosslessStringConvertible {
    var string: String { .init(self) }
}
