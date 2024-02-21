//
//  MoviesListViewController.swift
//  Ticketek
//
//  Created by Venkata Prabhu on 21/10/23.
//  Copyright © 2023 Venkata Prabhu. All rights reserved.
//

import UIKit
import CoreData
import GoogleSignIn

class MoviesListViewController: UIViewController, UpdateTableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel = MoviesListViewModel()
    private var movies: MoviesData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.viewModel.delegate = self
        loadData()
    
    }
    
    private func loadData() {
        
        self.viewModel.getPopularMoviesData { [weak self] (result) in
            self?.movies = result
            self?.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.standard.bool(forKey: "isShowProfile") {
            guard let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfilePopUpViewController") as? ProfilePopUpViewController else { return }
            popUpVC.presentAsPopUp(from: self)
        }
    }
    
    // Update the tableView if changes have been made
    func reloadData(sender: MoviesListViewModel) {
        self.tableView.reloadData()
    }
    
    // MARK: - Navigation - a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "movieSelected" {
            guard let detailsVC = segue.destination as? MovieDetailsViewController else { return }
            guard let selectedMovieCell = sender as? MoviesListTableViewCell else { return }
            
            if let indexPath = tableView.indexPath(for: selectedMovieCell) {
                let selectedMovie = movies?.movies[indexPath.row]
                detailsVC.viewModel = selectedMovie
            }
            // Back button without title on the next screen
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }
    
    //MARK: - Navigation Bar appearance
    private func setNavigationBar() {
        // Transparent the navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        // Navigation bar item color (time, battery) - white
        self.navigationController?.navigationBar.barStyle = .black
    }
    
    @IBAction func signOut(_ sender: UIButton) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "KiloWott", message: "Do you want to SignOut?", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "No", style: .destructive, handler: { action in
            })
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                GIDSignIn.sharedInstance.signOut()
                if let domain = Bundle.main.bundleIdentifier {
                    UserDefaults.standard.removePersistentDomain(forName: domain)
                }
                UIView.animate(withDuration: 5.0) {
                    guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController else { return }
                    UIApplication.shared.windows.first?.rootViewController = controller
                }
            }))
            alert.addAction(cancel)
            self.present(alert, animated: true)
        }
    }
}

//MARK: - TableView
extension MoviesListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.movies.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MoviesListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MoviesListTableViewCell
        cell.setCellWithValuesOf((movies?.movies[indexPath.row])!)
        return cell
    }
}
