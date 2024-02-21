//
//  MoviesListViewModel.swift
//  KiloWott
//
//  Created by Venkata Prabhu on 21/10/23.
//  Copyright © 2023 Venkata Prabhu. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol UpdateTableViewDelegate: NSObjectProtocol {
    
    func reloadData(sender: MoviesListViewModel)
}

class MoviesListViewModel: NSObject, NSFetchedResultsControllerDelegate {
    
    private var dataTask: URLSessionDataTask?
    var moviesData: MoviesData?
    weak var delegate: UpdateTableViewDelegate?
    
    // MARK: - Get popular movies data
    func getPopularMoviesData(completion: @escaping (_ result: MoviesData?) -> (Void)) {
        
        let popularMoviesURL = "https://api.themoviedb.org/3/movie/popular?api_key=4e0be2c22f7268edffde97481d49064a&language=en-US&page=1"
        guard let url = URL(string: popularMoviesURL) else { return }
        
        // Create URL Session - work on the background
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // Handle Error
            if let error = error {
                completion(nil)
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                // Handle Empty Response
                print("Empty Response")
                return
            }
            print("Response status code: \(response.statusCode)")
            
            guard let data = data else {
                // Hndle Empty Data
                print("Empty Data")
                return
            }
            
            do {
                // Parse the data
                let jsonData = try JSONDecoder().decode(MoviesData.self, from: data)
                
                // Back to the main thread
                DispatchQueue.main.async {
                    completion(jsonData)
                }
            } catch let error {
                completion(nil)
            }
        }
        dataTask?.resume()
    }
}
