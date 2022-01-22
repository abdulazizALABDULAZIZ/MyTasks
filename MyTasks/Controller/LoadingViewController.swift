//
//  LoadingViewController.swift
//  MyTasks
//
//  Created by MACBOOK on 19/06/1443 AH.
//

import UIKit

class LoadingViewController: UIViewController {

    private let authManager = AuthManager()
    private let navigationManager = NavigationManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showInitialScreen()
    }
    
    func showInitialScreen() {
        
        if authManager.userLoggedIn() {
            navigationManager.show(scene: .tasks)
            
        } else {
            navigationManager.show(scene: .onboarding)
            
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
