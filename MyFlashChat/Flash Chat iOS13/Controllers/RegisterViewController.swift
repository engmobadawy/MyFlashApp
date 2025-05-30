//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
                guard let self = self else { return }

                if let error = error {
                    print("Error creating user: \(error.localizedDescription)")
                } else {
                    print("User registered successfully!")
                
                       
                        self.performSegue(withIdentifier: "RegisterToChat", sender: self)
                    }
                
            }
        }
    }
    

    
}
