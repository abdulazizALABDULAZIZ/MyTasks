//
//  DoneTasksTableViewController.swift
//  MyTasks
//
//  Created by MACBOOK on 16/06/1443 AH.
//

import UIKit

class DoneTasksTableViewController: UITableViewController, Animatable {
    
    let databaseManager = DatabaseManager()
    private let authManager = AuthManager()
    
    private var tasks:[Task] = [] {
        
        didSet {
            
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addTasksListener()
    }
    
    private func addTasksListener() {
        
        guard let uid = authManager.getUserId() else {
            
            print("No user Found")
            
            return}
        
        databaseManager.addTasksListener(forDoneTasks: true,uid: uid) { [weak self] (result) in
            switch result {
                
            case .success(let tasks):
                self?.tasks = tasks
            case .failure(let error):
                self?.showToast(state: .error, massage: error.localizedDescription)
            }
        }
        
    }
    
    private func handleActionButton(for task: Task) {
        
        guard let id = task.id else { return }
        
        databaseManager.updateTaskStatus(id: id, isDone: false) { [weak self ] (result) in
            switch result {
                
            case .success:
                
                self?.showToast(state: .info, massage: "Move To Ongoing", duration: 2.0)
            case .failure(let error):
                self?.showToast(state: .error, massage: error.localizedDescription)
                // print(error.localizedDescription)
            }
        }
    }
    

 
}
    // MARK: - Table view data source

    extension DoneTasksTableViewController {

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                // #warning Incomplete implementation, return the number of rows
            return tasks.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath) as! DoneTaskTableViewCell
            
            let task = tasks[indexPath.row]
            cell.configuare(with: task)
            cell.actionButtonDidTap = { [weak self] in
                self?.handleActionButton(for: task)
                
                
            }
            return cell
        }
          
    }
//

 

