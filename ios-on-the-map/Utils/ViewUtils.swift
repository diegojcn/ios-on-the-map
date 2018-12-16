//
//  ViewUtils.swift
//  ios-on-the-map
//
//  Created by Diego Neves on 14/12/18.
//  Copyright © 2018 dj. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func displayLoading(customMessage: String) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: customMessage, preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        return alert
    }
    
}


