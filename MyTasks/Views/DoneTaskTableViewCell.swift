//
//  DoneTaskTableViewCell.swift
//  MyTasks
//
//  Created by MACBOOK on 17/06/1443 AH.
//

import UIKit

class DoneTaskTableViewCell: UITableViewCell {
    
    
    var actionButtonDidTap: (() -> Void)?

    
    @IBOutlet weak var titleLabel:UILabel!
    
    func configuare(with task:Task) {
        
        titleLabel.text = task.title
        
    }

    
    @IBAction func actionButtonTap(_ sender: UIButton) {
        
        actionButtonDidTap?()
        
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
