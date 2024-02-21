//
//  ViewController.swift
//  Ticketek
//
//  Created by Venkata Prabhu on 21/10/23.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import FirebaseCore

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func googleSignIn(_ sender: UIButton) {
        setupGoogle()
    }
    
    func setupGoogle() {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                return print("\(error?.localizedDescription)")
            }
            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                return print("user")
            }
            let userDefaults = UserDefaults.standard
            userDefaults.set(user.profile?.name, forKey: "userName")
            userDefaults.set(Auth.auth().currentUser?.photoURL, forKey: "profilePicture")
            userDefaults.synchronize()

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { result, error in
                guard error == nil else {
                    return debugPrint("Error: \(error?.localizedDescription)")
                }
                debugPrint("successfully sign-in to firebase app")
                
                userDefaults.set(true, forKey: "isShowProfile")
              // At this point, our user is signed in
                guard let tabbar = self.storyboard?.instantiateViewController(withIdentifier: "MovieTabBarViewController") as? MovieTabBarViewController else { return }
                tabbar.selectedIndex = 0
                UIApplication.shared.windows.first?.rootViewController = tabbar
            }
        }
    }
}


extension UIViewController {
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.view.tag != 99843232 {
            super.touchesBegan(touches, with: event)
            return
        }
        if let point = touches.first?.location(in: self.view) {
            if let subView = self.view.subviews.first {
                if subView.frame.contains(point) {
                    super.touchesBegan(touches, with: event)
                } else {
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        self.view.alpha = 0.0
                    }) { (_) -> Void in
                        UserDefaults.standard.set(false, forKey: "isShowProfile")
                        self.dismiss(animated: false, completion: nil)
                    }
                }
            }
        }
    }
    
    func presentAsPopUp(from: UIViewController) {
        // Assign the source and destination views to local variables.
        let firstVCView = from.view as UIView
        let secondVCView = self.view as UIView
        secondVCView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(secondVCView, aboveSubview: firstVCView)
        // Animate the transition.
        secondVCView.alpha = 0
        secondVCView.tag = 99843232
        self.modalPresentationStyle = .overCurrentContext
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            secondVCView.alpha = 1
        }) { (_) -> Void in
            from.present(self, animated: false, completion: nil)
        }
    }
}
