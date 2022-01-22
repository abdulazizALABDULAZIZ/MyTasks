//
//  LoginViewController.swift
//  MyTasks
//
//  Created by MACBOOK on 19/06/1443 AH.
//

import UIKit
import Combine

class LoginViewController: UIViewController, Animatable {

    
    @IBOutlet weak var emailTextField:UITextField!
    @IBOutlet weak var passwordTextField:UITextField!
    @IBOutlet weak var errorLabel:UILabel!
    
    @Published var errorString:String = ""
    @Published var loginSuccessful = false
    
    weak var delegate: LoginVCDelegate?
    
    private let authManager = AuthManager()
    private var subscribers = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeForm()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.becomeFirstResponder()
    }
    
    func observeForm() {
        
        $errorString.sink { [unowned self] (errorMassage) in
            self.errorLabel.text = errorMassage
        }.store(in: &subscribers)
        $loginSuccessful.sink { [unowned self] (isSuccessful) in
            if isSuccessful {
                
                self.delegate?.didLogin()
            }
        }.store(in: &subscribers)
    }
    

    @IBAction func loginButton(_ sender: UIButton) {
        
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            
            errorString = "Incomplete form"
            
            
            return}
        
        errorString = ""
        showLoadingAnimation()
        
        authManager.login(withEmail: email, password: password) { [weak self] (result) in
            self?.hideLoadingAnimation()
            switch result {
                
            case .success:
                self?.loginSuccessful = true
            case .failure(let error):
            self?.errorString = error.localizedDescription
            }
        }
        
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            
            errorString = "Incomplete form"
            
            return
            
        }
        
        errorString = ""
        showLoadingAnimation()
        
        authManager.signUp(withEmail: email, password: password) { [weak self] (result) in
            
            self?.hideLoadingAnimation()
            
            switch result {
            case .success:
                self?.loginSuccessful = true
            case .failure(let error):
                self?.errorString = error.localizedDescription
            }
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
