//
//  CalendarViewDelegate.swift
//  MyTasks
//
//  Created by MACBOOK on 18/06/1443 AH.
//

import Foundation


protocol CalendarViewDelegate:AnyObject {
    
    func calendarViewDidDate(date: Date)
    func calendarViewDidTapRemoveButton()
}
