//
//  NewTaskViewController.swift
//  MyTasks
//
//  Created by MACBOOK on 17/06/1443 AH.
//

import UIKit
import Combine

class NewTaskViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewButtonConst: NSLayoutConstraint!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var saveButton:UIButton!
    @IBOutlet weak var deadLineLabel:UILabel!
    
    private var subscribers = Set<AnyCancellable>()
    private let authManager = AuthManager()
    
    var taskToEdit: Task?
    
    @Published private var taskString:String?
    @Published private var deadLine:Date?
    
    weak var delegate:NewTasksVCDelegate?
    
    private lazy var calendarView:CalendarView = {
        let view = CalendarView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupGuster()
        observeKeyboard()
        observeForm()
        // Do any additional setup after loading the view.
    }
    
    private func observeForm() {
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification).map({
            
            ($0.object as? UITextField)?.text
        }).sink { [unowned self] (text) in
            self.taskString = text
        }.store(in: &subscribers)
        $taskString.sink { [unowned self] (text) in
            self.saveButton.isEnabled = text?.isEmpty == false
        }.store(in: &subscribers)
        
        $deadLine.sink { (date) in
            self.deadLineLabel.text = date?.toString() ?? ""
        }.store(in: &subscribers)
    }
    
    private func setupViews() {
        
        backgroundView.backgroundColor = UIColor.init(white: 0.3, alpha: 0.4)
        containerViewButtonConst.constant = -containerView.frame.height
        
        if let taskToEdit = taskToEdit {
            taskTextField.text = taskToEdit.title
            taskString = taskToEdit.title
            deadLine = taskToEdit.deadLine
            saveButton.setTitle("Update", for: .normal)
            // update calendar
            calendarView.selectedDate(date: taskToEdit.deadLine)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        taskTextField.becomeFirstResponder()
        
    }
    
    private func setupGuster() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        view.addGestureRecognizer(tap)
        tap.delegate = self
    }
    
    private func observeKeyboard() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification , object: nil)
    }
    
    
    
    @objc func showKeyboard(_ notification: Notification) {
        
        let keyboardHight = getKeyboard(notification: notification)
        
        print("KeyboardHight:\(keyboardHight)")
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: { [unowned self] in
            
            self.containerViewButtonConst.constant = keyboardHight - (200 + 8)
            self.view.layoutIfNeeded()
        }, completion: nil )
        
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        
        containerViewButtonConst.constant = -containerView.frame.height
    }
    
    private func getKeyboard(notification: Notification) -> CGFloat {
        
        guard let keyboardHight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return 0 }
        
        return keyboardHight
        
        
        
    }
    
    private func showCalendar() {
        
        view.addSubview(calendarView)
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func dissmissCalendarView(completion: () -> Void) {
        
        calendarView.removeFromSuperview()
        completion()
        
    }
    
    @objc private func dissmissKeyboard() {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func calendarButton(_ sender: Any) {
        
        
        taskTextField.resignFirstResponder()
        showCalendar()
        
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        guard let taskString = self.taskString,
        let uid = authManager.getUserId() else { return }
        
        

        var task = Task(title: taskString,deadLine: deadLine, uid: uid)
        
        if let id = taskToEdit?.id {
            
            task.id = id
        }
        
        if taskToEdit == nil {
            delegate?.didAddTask(task)
        } else {
            
            delegate?.didEditTask(task)
            
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

extension NewTaskViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if calendarView.isDescendant(of: view) {
            if touch.view?.isDescendant(of: calendarView) == false {
                
                // dissmiss calendar view
                dissmissCalendarView { [unowned self] in
                    
                    self.taskTextField.becomeFirstResponder()
                }
                print("dissmiss calendar View ")
            }
            
            return false
        }
        return true
    }
}

extension NewTaskViewController: CalendarViewDelegate {
    
    
    func calendarViewDidDate(date: Date) {
    
        dissmissCalendarView { [unowned self] in
            deadLine = date
            self.taskTextField.becomeFirstResponder()
        }
    }
    
    func calendarViewDidTapRemoveButton() {
        
        dissmissCalendarView {
            self.taskTextField.becomeFirstResponder()
            self.deadLine = nil
        }
        
    }
    
}
