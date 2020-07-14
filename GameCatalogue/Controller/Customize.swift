//
//  ExtensionFile.swift
//  GameCatalogue
//
//  Created by Mochamad Nurkhayal Kadafi on 11/07/20.
//  Copyright © 2020 Mochamad Nurkhayal Kadafi. All rights reserved.
//

import Foundation

extension String {
    public var withoutHtml: String {
        guard let data = self.data(using: .utf8) else {
            return self
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return self
        }

        return attributedString.string
    }
}

func underlineText(keyword: String) -> NSAttributedString{
    let attributedString = NSMutableAttributedString.init(string: "\(keyword)")
    attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range:
        NSRange.init(location: 0, length: attributedString.length));
    
    return attributedString
}

extension LosslessStringConvertible {
    var string: String { .init(self) }
}
