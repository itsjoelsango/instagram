//
//  AccountViewController.swift
//  Instagram
//
//  Created by Jo Michael on 7/31/23.
//

import UIKit
import ParseCore

class AccountViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var indicatorLogout: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        self.indicatorLogout.isHidden = true
    }
    
    private func fetchUser() {
        let user = PFUser.current()
        if let user = user {
            self.usernameLabel.text = user.username
        } else {
            print("not user of that username found!")
        }
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        
        indicatorToggle()
        
        PFUser.logOutInBackground { error in
            self.indicatorLogout.stopAnimating()
            NotificationCenter.default.post(name: NSNotification.Name("logout"), object: nil)
            print("Log Out!")
        }
    }
    
    private func indicatorToggle() {
        self.indicatorLogout.isHidden.toggle()
        // start indicator animation
        self.indicatorLogout.startAnimating()
    }
}
