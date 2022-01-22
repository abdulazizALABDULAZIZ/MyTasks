//
//  ongoingTaskTableViewCell.swift
//  MyTasks
//
//  Created by MACBOOK on 17/06/1443 AH.
//

import UIKit

class OngoingTaskTableViewCell:UITableViewCell {
    
    var actionButtonDidTap: (() -> Void)?
    
    @IBOutlet weak var titleLable:UILabel!
    @IBOutlet weak var deadlineLabel:UILabel!
    
    func configuar(with task: Task) {
        
        titleLable.text = task.title
        deadlineLabel.text = task.deadLine?.toRelativeString()
        
        if task.deadLine?.overDue() == true {
            deadlineLabel.textColor = .red
            deadlineLabel.font = UIFont(name: "AvenirNext-Medium", size: 12)
            
        } else if task.deadLine?.overDue() == false {
            deadlineLabel.textColor = .lightGray
//            deadlineLabel.font = UIFont(name: "", size: 15)
        }
    }
    
    @IBAction func actionButton(_ sender: UIButton) {
        
        actionButtonDidTap?()
        
    }
    
}
