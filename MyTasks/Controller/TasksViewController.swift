//
//  ViewController.swift
//  MyTasks
//
//  Created by MACBOOK on 16/06/1443 AH.
//

import UIKit

class TasksViewController: UIViewController, Animatable {

    @IBOutlet weak var menuSegmentedControl: UISegmentedControl!
    @IBOutlet weak var ongoingTasksContainerView:UIView!
    @IBOutlet weak var doneTasksContainerView:UIView!
    
    private let datebaseManager = DatabaseManager()
    private let authManager = AuthManager()
    private let navigationManager = NavigationManager.shared

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentedControl()
        // Do any additional setup after loading the view.
        
    }

    private func setupSegmentedControl(){
        
        menuSegmentedControl.removeAllSegments()
        MenuSection.allCases.enumerated().forEach { (index,section) in
            menuSegmentedControl.insertSegment(withTitle: section.rawValue, at: index, animated: false)
        }
        
        menuSegmentedControl.selectedSegmentIndex = 0
        showContainerView(for: .ongoing)
    }
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            showContainerView(for: .ongoing)
        case 1:
            showContainerView(for: .done)
        default: break
        }
        
    }
    
    private func logoutUser() {
        
        authManager.logout { [unowned self] (result) in
            switch result {
                
            case .success:
                navigationManager.show(scene: .onboarding)
                // redirect user to the onboard screen
            case .failure(let error):
                self.showToast(state: .error, massage: error.localizedDescription)
                
            }
        }
    }
    
    private func menuOptions() {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let logOutAction = UIAlertAction(title: "LogOut", style: .default) { [unowned self] _ in
            self.logoutUser()
            print("Log Out here")
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(logOutAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func menuButton(_ sender: UIButton) {
        
        menuOptions()
    }
    
    private func showContainerView(for section:MenuSection){
        
        switch section {
        case .ongoing:
            ongoingTasksContainerView.isHidden = false
            doneTasksContainerView.isHidden = true
        case .done:
            ongoingTasksContainerView.isHidden = true
            doneTasksContainerView.isHidden = false
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNewTask" ,
           let destination = segue.destination as? NewTaskViewController {
            destination.delegate = self
            
        } else if segue.identifier == "showOngoingTasks" {
            
            let destination = segue.destination as? OngoingTasksTableViewController
            destination?.delegate = self
        } else if segue.identifier == "showEditTasks", let destination = segue.destination as? NewTaskViewController, let taskToEdit = sender as? Task {
            
            destination.delegate = self
            destination.taskToEdit = taskToEdit
            
        }
        
    }
    
    private func deleteTask(id:String) {
        
        datebaseManager.deleteTask(id: id) { [weak self] (result) in
            switch result {
                
            case .success:
                self?.showToast(state: .success, massage: "Task deleted successfully")
            case .failure(let error):
                self?.showToast(state: .error, massage: error.localizedDescription)
                
            }
        }
    }
    
    private func editTask(task: Task) {
        performSegue(withIdentifier: "showEditTasks", sender: task)
        
    }
    
    @IBAction func addTasksButtonTapped() {
        

        performSegue(withIdentifier: "showNewTask", sender: nil)
    }
    
}

extension TasksViewController: OngoingTasksTVCDelegate {
    
     func showOptions(for task: Task) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [unowned self] _ in
            guard let id = task.id else { return }
            self.deleteTask(id: id)
            print("Delete Task: \(task.title)")
        }
         
         let editAction = UIAlertAction(title: "Edit", style: .default) { [unowned self] _ in
             self.editTask(task: task)
         }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
         alertController.addAction(editAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

extension TasksViewController: NewTasksVCDelegate {
    
    
    func didEditTask(_ task: Task) {
        presentedViewController?.dismiss(animated: true, completion: {
            guard let id = task.id else {return}
            self.datebaseManager.editTask(id: id, title: task.title, deadline: task.deadLine) { [weak self] (result) in
                
                switch result {
                case .success:
                    self?.showToast(state: .success, massage: "Task updated successfully")
                case .failure(let error):
                    self?.showToast(state: .error, massage: error.localizedDescription)
                }
                
            }
        })
    }
    
    func didAddTask(_ task: Task) {
        
        presentedViewController?.dismiss(animated: true, completion: { [unowned self] in
            
            self.datebaseManager.addTask(task) { [weak self] (result) in
                switch result {
                case .success: break
                case .failure(let error):
                    self?.showToast(state: .error, massage: error.localizedDescription)
                }
            }
            
        })
        
        
    }
    
    
    
}

