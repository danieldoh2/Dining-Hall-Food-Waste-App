//
//  LoginViewController.swift
//  Clock-In
//
//  Created by William Lee on 2022/7/12.
//

import UIKit
import Parse
import TransitionButton


class KeychainManager{
    static func save(){
        
    }
    
    static func get(){
        
    }
}

class LoginViewController: UIViewController {

    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: TransitionButton!
    
    
    
    @IBAction func OnSignIn(_ sender: Any) {
        var username = usernameField.text!
        var password = passwordField.text!
        
        PFUser.logInWithUsername(inBackground: username, password: password) {
                  (user: PFUser?, error: Error?) -> Void in
                  if user != nil {
                      self.performSegue(withIdentifier: "LogInSegue", sender: nil)
                  } else {
                      print("failed")
                      let alert = UIAlertController(title: "Wrong Username or Password", message: "Please Enter Your Username or Password", preferredStyle: UIAlertController.Style.alert)

                      // add an action (button)
                      alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                      // show the alert
                      self.present(alert, animated: true, completion: nil)
                  }
                }
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

}
