//
//  MoviesListTableViewCell.swift
//  Ticketek
//
//  Created by Venkata Prabhu on 21/10/23.
//  Copyright © 2023 Venkata Prabhu. All rights reserved.
//

import UIKit

class MoviesListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    @IBOutlet weak var movieBackdrop: UIImageView!
    
    private var apiService = ApiService()
    private var urlString: String = ""
    
    //MARK: - Setup movie values
    func setCellWithValuesOf(_ movie: Movie) {
        
        updateUI(title: movie.title, overview: movie.overview, backdrop: movie.backdropImage)
    }
    
    //MARK: - Setup CoreData values
    func setCellWithValuesOfCoreData(_ movie: MovieList) {
        
        updateUI(title: movie.title, overview: movie.overview, backdrop: movie.backdropImage)
    }

    
    // MARK: - Update the UI Views
    private func updateUI(title: String?, overview: String?, backdrop: String?) {
        
        self.movieTitle.text = title
        self.movieOverview.text = overview
        
        guard let backdropString = backdrop else {return}
        urlString = "https://image.tmdb.org/t/p/w300" + backdropString
        
        guard let backdropImageURL = URL(string: urlString) else {
            self.movieBackdrop.image = UIImage(named: "noImageAvailable")
            return
        }
        
        // Before we download the image we clear out the old one
        self.movieBackdrop.image = nil
        
        apiService.getImageDataFrom(url: backdropImageURL) { [weak self] (data: Data) in
            if let image = UIImage(data: data) {
                self?.movieBackdrop.image = image
            } else {
                self?.movieBackdrop.image = UIImage(named: "noImageAvailable")
            }
        }
        viewsAttributes()
    }
    
    // MARK: - Views attributes
    private func viewsAttributes() {
        
        // Movie Backdrop attributes
        movieBackdrop.layer.cornerRadius = 20
        movieBackdrop.layer.borderWidth = 0.8
        movieBackdrop.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        movieBackdrop.contentMode = .scaleAspectFill
    }
}

// Development
