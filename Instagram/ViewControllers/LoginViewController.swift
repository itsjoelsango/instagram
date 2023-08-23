//
//  LoginViewController.swift
//  Instagram
//
//  Created by Jo Michael on 7/20/23.
//

import UIKit
import ParseCore

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var indicatorLogin: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.indicatorLogin.isHidden = true
        passwordTextField.becomeFirstResponder()
        passwordTextField.delegate = self
    }
    
    // MARK: onLogin function setup
    @IBAction func onLogin(_ sender: UIButton) {
        // Step 2: implement sign up logic
        guard let username = usernameTextField.text, username.count > 0,
              let password = passwordTextField.text else {
            displayEmptyTextFieldError()
            return
        }
        
        indicatorToggle()
        
        PFUser.logInWithUsername(inBackground: username, password: password) { user, error in
            // stop indicator animation
            self.indicatorLogin.stopAnimating()
            self.indicatorLogin.isHidden = true
            if let error = error {
                self.displayLoginError(error: error)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name("login"), object: nil)
            }
        }
        
    }
    
    private func indicatorToggle() {
        self.indicatorLogin.isHidden.toggle()
        // start indicator animation
        self.indicatorLogin.startAnimating()
    }
    
    // MARK: onSignup function setup
    @IBAction func onSignup(_ sender: UIButton) {
        // Step 3: Implement login logic
        guard let username = usernameTextField.text, username.count > 0,
              let password = passwordTextField.text else {
            displayEmptyTextFieldError()
            return
        }
        
        let newUser = PFUser()
        newUser.username = username
        newUser.password = password
        indicatorToggle()
        newUser.signUpInBackground { isSuccess, error in
            self.indicatorLogin.stopAnimating()
            self.indicatorLogin.isHidden = true
            if let error = error {
                self.displaySignupError(error: error)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name("login"), object: nil)
            }
        }
    }

    private func displayEmptyTextFieldError() {
        let title = "Error"
        let message = "Username and password field cannot be empty"
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }

    private func displayLoginError(error: Error) {
        let title = "Login Error"
        let message = "Oops! something went wrong while logging in: \(error.localizedDescription)"
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }
    
    private func displaySignupError(error: Error) {
        let title = "Sign up Error"
        let message = "Oops! something went wrong while logging in: \(error.localizedDescription)"
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        passwordTextField.resignFirstResponder()
        return true
    }
}
