//
//  ImageViewExtension.swift
//  ChefNote
//
//  Created by Jason Cheng on 8/7/15.
//  Copyright (c) 2015 Jason. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage
import Alamofire

extension UIImageView {
    // Load image asynchronously fro an URL.
    public func imageFromUrl(urlString: String) {
        Alamofire.request(.GET, urlString)
            .responseImage { response in
                self.image = response.result.value
        }
    }
}