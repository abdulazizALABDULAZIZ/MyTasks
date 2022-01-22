//
//  Task.swift
//  MyTasks
//
//  Created by MACBOOK on 17/06/1443 AH.
//

import Foundation
import FirebaseFirestoreSwift

struct Task: Identifiable,Codable {
    @DocumentID var id: String?
    @ServerTimestamp var createdAt:Date?
    
    let title:String
    var isDone:Bool = false
    var doneAt:Date?
    var deadLine:Date?
    let uid: String
    
}
