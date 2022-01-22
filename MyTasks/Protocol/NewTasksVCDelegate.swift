//
//  TasksVCDelegate.swift
//  MyTasks
//
//  Created by MACBOOK on 17/06/1443 AH.
//

import Foundation

protocol NewTasksVCDelegate: class {
    
    func didAddTask(_ task: Task)
    func didEditTask(_ task: Task)
    
}
