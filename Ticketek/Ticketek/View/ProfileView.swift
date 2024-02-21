//
//  ProfileView.swift
//  Ticketek
//
//  Created by Venkata Prabhu on 21/10/23.
//

import UIKit

class ProfileView: UIViewController {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!

    init() {
        super.init(nibName: "ProfileView", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configView()
    }
    
    private func configView() {
        self.view.backgroundColor = .clear
        self.contentView.alpha = 0
        self.contentView.layer.cornerRadius = 10
    }
    
    func appear(sender: MoviesListViewController) {
        sender.present(self, animated: false) {
            self.show()
        }
    }
    
    private func show() {
        UIView.animate(withDuration: 1, delay: 0.2) {
            self.contentView.alpha = 1
        }
    }
}

