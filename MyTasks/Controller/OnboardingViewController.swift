//
//  OnboardingViewController.swift
//  MyTasks
//
//  Created by MACBOOK on 19/06/1443 AH.
//

import UIKit

class OnboardingViewController: UIViewController {

    private let navigationManager = NavigationManager.shared
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLoginScreen", let destination = segue.destination as? LoginViewController {
            
            destination.delegate = self
            
        }
            
            
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func getStartedButton(_ sender: UIButton) {
        
        performSegue(withIdentifier: "showLoginScreen", sender: nil)
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

extension OnboardingViewController: LoginVCDelegate {
    
    
    func didLogin() {
        
        presentedViewController?.dismiss(animated: true, completion: { [unowned self] in
            self.navigationManager.show(scene: .tasks)
        })
    }
    
    
    
    
}
