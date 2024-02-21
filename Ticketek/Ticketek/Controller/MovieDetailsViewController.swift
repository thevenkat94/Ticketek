//
//  MovieDetailsViewController.swift
//  Ticketek
//
//  Created by Venkata Prabhu on 21/10/23.
//  Copyright © 2023 Venkata Prabhu. All rights reserved.
//

import UIKit
import CoreData

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    
    var viewModel: Movie!
    var movieList = [MovieList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Back button color
        self.navigationController?.navigationBar.tintColor = UIColor.white
        updateUI()
    }
    
    // Update UI
    private func updateUI() {
        self.movieTitle.text = viewModel.title
        self.movieReleaseDate.text = viewModel.year
        self.movieOverview.text = viewModel.overview
        self.moviePoster.setImageFromPath("https://image.tmdb.org/t/p/w300\(viewModel.posterImage ?? "")")
    }
    
    @IBAction func saveToCoreData(_ sender: UIButton) {
        movieList = CoreData.sharedInstance.getAllItems()
        let value = filterMovieLocalData()

        DispatchQueue.main.async {
            switch value {
            case false:
                self.showAlert()
            default:
                self.showSavedAlert()
            }
        }
        
    }
    
    func showSavedAlert() {
        let alert = UIAlertController(title: "KiloWott", message: "Already Saved", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.dismiss(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "KiloWott", message: "Saved in WatchList", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            CoreData.sharedInstance.createItem(data: self.viewModel)
            self.dismiss(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    func filterMovieLocalData() -> Bool {
        
        var isExist = Bool()
        
        for movie in 0..<movieList.count {
            let title = movieList[movie].title
            if title == viewModel.title {
                isExist = true
            } else {
                isExist = false
            }
        }
        return isExist
    }
}

// Extension to set an image into UIImageView
extension UIImageView {
    func setImageFromPath(_ path: String?) {
        image = nil
        DispatchQueue.global(qos: .background).async {
            var image: UIImage?
            guard let imagePath = path else {return}
            if let imageURL = URL(string: imagePath) {
                if let imageData = NSData(contentsOf: imageURL) {
                    image = UIImage(data: imageData as Data)
                } else {
                    // Image default - In case of error
                    image = UIImage(named: "noImageAvailable")
                }
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}
