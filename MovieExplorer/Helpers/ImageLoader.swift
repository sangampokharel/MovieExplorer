//
//  ImageLoader.swift
//  MovieExplorer
//
//  Created by Ekbana on 19/11/2025.
//
import UIKit
import SDWebImage

// MARK: - Image Loading Protocol
protocol ImageLoadable {
    func loadImage(from urlString: String, into imageView: UIImageView, placeholder: UIImage?)
    func loadImage(from urlString: String, into imageView: UIImageView, placeholder: UIImage?, completion: @escaping (Result<UIImage, Error>) -> Void)
    func cancelImageLoad(for imageView: UIImageView)
}

// MARK: - Image Loading Error
enum ImageLoadingError: Error {
    case invalidURL
    case loadingFailed
    case noImage
}

// MARK: - SDWebImage Implementation
final class SDWebImageLoader: ImageLoadable {
    static let shared = SDWebImageLoader()
    
    private init() {}
    
    func loadImage(from urlString: String, into imageView: UIImageView, placeholder: UIImage? = nil) {
        guard let url = URL(string: urlString) else {
            imageView.image = placeholder
            return
        }
        
        imageView.sd_setImage(with: url, placeholderImage: placeholder)
    }
    
    func loadImage(from urlString: String, into imageView: UIImageView, placeholder: UIImage? = nil, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            imageView.image = placeholder
            completion(.failure(ImageLoadingError.invalidURL))
            return
        }
        
        imageView.sd_setImage(with: url, placeholderImage: placeholder) { image, error, _, _ in
            if let error = error {
                completion(.failure(error))
            } else if let image = image {
                completion(.success(image))
            } else {
                completion(.failure(ImageLoadingError.noImage))
            }
        }
    }
    
    func cancelImageLoad(for imageView: UIImageView) {
        imageView.sd_cancelCurrentImageLoad()
    }
}

// MARK: - Main ImageLoader Class
final class ImageLoader {
    static let shared = ImageLoader()
    
    private let loader: ImageLoadable
    
    init(loader: ImageLoadable = SDWebImageLoader.shared) {
        self.loader = loader
    }
    
    func loadImage(from urlString: String, into imageView: UIImageView, placeholder: UIImage? = nil) {
        loader.loadImage(from: urlString, into: imageView, placeholder: placeholder)
    }
    
    func loadImage(from urlString: String, into imageView: UIImageView, placeholder: UIImage? = nil, completion: @escaping (Result<UIImage, Error>) -> Void) {
        loader.loadImage(from: urlString, into: imageView, placeholder: placeholder, completion: completion)
    }
    
    func cancelImageLoad(for imageView: UIImageView) {
        loader.cancelImageLoad(for: imageView)
    }
}

