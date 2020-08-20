//
//  ImageLoading.swift
//  DogBreeds
//
//  Created by Alexandr Lavrinovich on 17.08.2020,
//  Copyright © 2020 MacBook Pro. All rights reserved.
//


import UIKit

extension UIImageView {
    
    private var cache: URLCache { URLCache.shared }
    private var session: URLSession { URLSession.shared }
    
    func loadImage(fromURL urlString: String?,
                   with placeholder: UIImage? = nil) {
        guard let url = urlString,
            let imageURL = URL(string: url) else {
                DispatchQueue.main.async {
                    self.image = placeholder
                }
                return
        }
        
        let request = URLRequest(url: imageURL)
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = self.cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self.image = placeholder
                }
                self.session.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
                    guard let self = self else { return }
                    if let data = data,
                        let response = response,
                        ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300,
                        let image = UIImage(data: data) {
                        let cachedData = CachedURLResponse(response: response, data: data)
                        self.cache.storeCachedResponse(cachedData, for: request)
                        DispatchQueue.main.async {
                            self.transition(toImage: image)
                        }
                    }
                }).resume()
            }
        }
    }
    
    func transition(toImage image: UIImage?) {
        UIView.transition(with: self, duration: 0.2,
                          options: [.transitionCrossDissolve],
                          animations: {
                            self.image = image
        },
                          completion: nil)
    }
    
}
