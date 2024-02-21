//
//  ProfilePopUpViewController.swift
//  Ticketek
//
//  Created by Venkata Prabhu on 22/10/23.
//

import UIKit
import Kingfisher

class ProfilePopUpViewController: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.kf.indicatorType = .activity
        
        DispatchQueue.main.async {
            self.profileImageView.kf.setImage(with: self.defaults.url(forKey: "profilePicture"))
            self.nameLabel.text = "Welcome, \(self.defaults.string(forKey: "userName") ?? "")!"
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "isShowProfile")
        self.dismiss(animated: true)
    }
}
