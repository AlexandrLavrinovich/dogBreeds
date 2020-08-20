//
//  NetworkProvider.swift
//  DogBreeds
//
//  Created by Alexandr Lavrinovich on 17.08.2020,
//  Copyright © 2020 MacBook Pro. All rights reserved.
//


import UIKit

protocol NetworkServiceProtocol: AnyObject {

func parse<T: Decodable>(data: Data?,
                         response: URLResponse?,
                         error: Error?) -> Result<T, Error>

func getTask(path: String?,
             parameters: [String : String?]?,
             completion: @escaping ((Data?, URLResponse?, Error?) -> Void)) -> URLSessionTask?
}

class NetworkService {
    
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    var baseUrl: String { "https://dog.ceo/api" }
    
}

extension NetworkService: NetworkServiceProtocol {
    
    func parse<T: Decodable>(data: Data?,
                             response: URLResponse?,
                             error: Error?) -> Result<T, Error> {
        if let data = data {
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                return .success(decodedResponse)
            } catch {
                let alert = UIAlertController(title: "Ошибка", message: "\(error)", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                if let topViewController = self.getTopViewController() {
                    topViewController.present(alert, animated: true, completion: nil)
                }
                return .failure(error)
            }
        } else if let error = error {
            let alert = UIAlertController(title: "Ошибка", message: "\(error)", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            if let topViewController = self.getTopViewController() {
                topViewController.present(alert, animated: true, completion: nil)
            }
            return .failure(error)
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "\(APIError.invalidResponse)", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            if let topViewController = self.getTopViewController() {
                topViewController.present(alert, animated: true, completion: nil)
            }
            return .failure(APIError.invalidResponse)
        }
    }
    
    func getTask(path: String?,
                     parameters: [String: String?]? = nil,
                     completion: @escaping ((Data?, URLResponse?, Error?) -> Void)) -> URLSessionTask? {
        guard let urlRequest = makeUrlRequest(method: .get,
                                              path: path,
                                              parameters: parameters) else { return nil }
        let task = session.dataTask(with: urlRequest, completionHandler: completion)
        task.resume()
        return task
    }
    
    private func makeUrlRequest(method: HTTPMethod,
                                path: String?,
                                parameters: [String: String?]? = nil,
                                body: Data? = nil) -> URLRequest? {
        
        guard var url = URL(string: baseUrl) else { return nil }
        if let path = path {
            url.appendPathComponent(path)
        }
        guard var urlComponets = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return nil }
        if let params = parameters {
            var queryItems = [URLQueryItem]()
            for (key, value) in params {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
            urlComponets.queryItems = queryItems
        }
        guard let resultUrl = urlComponets.url else { return nil }
        var urlRequest = URLRequest(url: resultUrl)
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = body
        return urlRequest
    }
    
    func getTopViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.connectedScenes
                        .filter({$0.activationState == .foregroundActive})
                        .map({$0 as? UIWindowScene})
                        .compactMap({$0})
                        .first?.windows
                        .filter({$0.isKeyWindow}).first
        if var topViewController = keyWindow?.rootViewController {
            while let presentedViewController = topViewController.presentedViewController {
                topViewController = presentedViewController
            }
            return topViewController
        }
        return nil
    }
}
