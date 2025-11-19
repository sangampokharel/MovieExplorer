//
//  UIImageView + Ext.swift
//  MovieExplorer
//
//  Created by Ekbana on 19/11/2025.
//

import UIKit

extension UIImageView {
    func loadImage(from urlString: String, placeholder: UIImage? = nil) {
        ImageLoader.shared.loadImage(from: urlString, into: self, placeholder: placeholder)
    }

    func loadImage(from urlString: String, placeholder: UIImage? = nil, completion: @escaping (Result<UIImage, Error>) -> Void) {
        ImageLoader.shared.loadImage(from: urlString, into: self, placeholder: placeholder, completion: completion)
    }

    func cancelImageLoad() {
        ImageLoader.shared.cancelImageLoad(for: self)
    }
}
