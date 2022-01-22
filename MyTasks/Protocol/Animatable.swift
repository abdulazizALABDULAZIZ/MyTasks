//
//  Animatable.swift
//  MyTasks
//
//  Created by MACBOOK on 18/06/1443 AH.
//

import Foundation
import Loaf
import MBProgressHUD

protocol Animatable {
    
    
}


extension Animatable where Self :UIViewController {
    
    func showLoadingAnimation() {
        
        DispatchQueue.main.async {
            let hide = MBProgressHUD.showAdded(to: self.view, animated: true)
            hide.backgroundColor = UIColor.init(white: 0.5, alpha: 0.3)
        }
    }
    
    func hideLoadingAnimation() {
        
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        
    }
    
    func showToast(state: Loaf.State, massage: String, location:  Loaf.Location = .top, duration: TimeInterval = 1.0) {
        
        DispatchQueue.main.async {
            Loaf(massage, state: state, location: location, sender: self).show(.custom(duration))
        }
        
    }
    
    
}
