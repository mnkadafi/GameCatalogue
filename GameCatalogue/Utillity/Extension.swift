//
//  Extension.swift
//  GameCatalogue
//
//  Created by Mochamad Nurkhayal Kadafi on 24/07/20.
//  Copyright © 2020 Mochamad Nurkhayal Kadafi. All rights reserved.
//

import UIKit

fileprivate var loadingView : UIView?
let loadingLabel = UILabel()
let spinner = UIActivityIndicatorView()

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

extension UIViewController{
    public func setLoadingScreen() {

        loadingView = UIView(frame: self.view.bounds)
        
        spinner.style = .medium
        spinner.center = loadingView!.center
        spinner.startAnimating()
        
        loadingLabel.isHidden = false
        loadingLabel.textColor = .darkGray
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading ..."
        loadingLabel.frame = CGRect(x: spinner.frame.origin.x - 60, y: 10 + spinner.frame.origin.y , width: 140, height: 30)

        loadingView!.addSubview(spinner)
        loadingView!.addSubview(loadingLabel)
        loadingView!.isHidden = false
        self.view.addSubview(loadingView!)

    }

    public func removeLoadingScreen() {

        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
        loadingView!.removeFromSuperview()

    }
}
