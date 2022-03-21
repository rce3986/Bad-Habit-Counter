//
//  ViewController.swift
//  Bad Habit Counter
//
//  Created by Ryan Elliott on 3/6/22.
//

import UIKit
import FSCalendar

class ViewController: UIViewController {

    fileprivate weak var calendarView: FSCalendar!
    
    fileprivate weak var addHabitView: UIView!
    fileprivate weak var habitLabel: UILabel!
    fileprivate weak var habitTextField: UITextField!
    fileprivate weak var addHabitButton: UIButton!
    
    fileprivate weak var tableView: UITableView!
    
    var data: BadHabitCounterData!
    var selectedDate: Date!
    
    let CELL_REUSE_IDENTIFIER: String = "poop"
    let SPACING: CGFloat = 25
    let COLOR_STEP_MAX: CGFloat = 10
    let TABLE_VIEW_ROW_HEIGHT: CGFloat = 50
    let TOP_PADDING: CGFloat = 50
    let BOTTOM_PADDING: CGFloat = 50
    let ADD_HABIT_BUTTON_SIDE: CGFloat = 50
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // used to clear data, remove if testing for continuity
        //_ = Bad_Habit_Counter.write(data: BadHabitCounterData())
        
        guard let data = load() else {
            print("you changed the model and forgot this could happen lmao")
            return
        }
        self.data = data
        selectedDate = today()
        
        // testing data
        /*
        self.data = BadHabitCounterData()
        self.data.startDate = iso("2022-02-02")!
        let monkey = Habit("monkey")
        monkey.total = 22
        monkey.put(date: iso("2022-02-03")!, count: 7)
        monkey.put(date: iso("2022-02-04")!, count: 3)
        monkey.put(date: iso("2022-02-05")!, count: 10)
        monkey.put(date: iso("2022-02-06")!, count: 2)
        self.data.habits.append(monkey)
        */
    
        
        
        setUpCalendarView()
        setUpAddHabitView()
        setUpTableView()
    }
    
    func setUpCalendarView() {
        let parent: UIView = view
        let child: FSCalendar = FSCalendar()
        
        setUp(child, in: parent, top: parent.topAnchor, bottom: nil, leading: parent.leadingAnchor, trailing: parent.trailingAnchor, spacing: [TOP_PADDING, 0, 0, 0])
        child.heightAnchor.constraint(equalTo: child.widthAnchor).isActive = true
        
        child.dataSource = self
        child.delegate = self
        
        child.appearance.headerTitleColor = .orange
        child.appearance.weekdayTextColor = .green
        //child.appearance.titleDefaultColor = .systemBackground
        //child.appearance.titleTodayColor = child.appearance.titleDefaultColor
        child.appearance.selectionColor = .clear
        child.appearance.todayColor = child.appearance.selectionColor
        //child.appearance.titleSelectionColor = .white
        child.appearance.borderSelectionColor = .white
        //child.appearance.titlePlaceholderColor = .clear
        //child.appearance.subtitlePlaceholderColor = .clear
        child.placeholderType = .none
        
        calendarView = child
    }
    
    func setUpAddHabitView() {
        let parent: UIView = view
        let child: UIView = UIView()
        
        setUp(child, in: parent, top: calendarView.bottomAnchor, bottom: nil, leading: parent.leadingAnchor, trailing: parent.trailingAnchor)
        
        child.backgroundColor = .systemGray
        
        addHabitView = child
        
        setUpHabitLabel()
        setUpHabitTextField()
        setUpAddHabitButton()
    }
    
    func setUpHabitLabel() {
        let parent: UIView = addHabitView
        let child: UILabel = UILabel()
        
        setUp(child, in: parent, top: nil, bottom: nil, leading: parent.leadingAnchor, trailing: nil, spacing: [0, 0, SPACING, 0])
        child.centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
        child.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        child.text = "Habit"
        
        habitLabel = child
    }
    
    func setUpHabitTextField() {
        let parent: UIView = addHabitView
        let child: UITextField = UITextField()
        
        setUp(child, in: parent, top: nil, bottom: nil, leading: habitLabel.trailingAnchor, trailing: nil, spacing: [0, 0, SPACING, 0])
        child.centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
        
        child.borderStyle = .bezel
        child.addTarget(self, action: #selector(doneWithKeyboard), for: .primaryActionTriggered)
        
        habitTextField = child
    }
    
    func setUpAddHabitButton() {
        let parent: UIView = addHabitView
        let child: UIButton = UIButton()
        
        setUp(child, in: parent, top: parent.topAnchor, bottom: parent.bottomAnchor, leading: habitTextField.trailingAnchor, trailing: parent.trailingAnchor, spacing: [SPACING / 2, SPACING / 2, SPACING, SPACING])
        child.heightAnchor.constraint(equalToConstant: ADD_HABIT_BUTTON_SIDE).isActive = true
        child.widthAnchor.constraint(equalTo: child.heightAnchor).isActive = true
        
        child.backgroundColor = .systemGreen
        child.setImage(UIImage(systemName: "plus"), for: .normal)
        child.layer.cornerRadius = ADD_HABIT_BUTTON_SIDE / 2
        
        child.addTarget(self, action: #selector(addHabitButtonTapped), for: .touchUpInside)
        
        addHabitButton = child
    }
    
    func setUpTableView() {
        let parent: UIView = view
        let child: UITableView = UITableView()
        
        setUp(child, in: parent, top: addHabitView.bottomAnchor, bottom: parent.bottomAnchor, leading: parent.leadingAnchor, trailing: parent.trailingAnchor, spacing: [0, BOTTOM_PADDING, 0, 0])
        child.rowHeight = TABLE_VIEW_ROW_HEIGHT
        
        child.dataSource = self
        child.delegate = self
        
        child.register(HabitTableViewCell.self, forCellReuseIdentifier: CELL_REUSE_IDENTIFIER)
        child.allowsSelection = false

        tableView = child
    }

    // Actions
    
    @objc func addHabitButtonTapped() {
        guard let habit = habitTextField.text else {
            print("you need to enter a name for the habit idiot")
            return
        }
        
        if habit == "" {
            print("you need to enter a name for the habit idiot")
            return
        }
        
        data.habits.insert(Habit(habit), at: 0)
        habitTextField.text = nil
        habitTextField.resignFirstResponder()
        reloadAndWrite()
    }
    
    @objc func doneWithKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    // Helpers

    func load() -> BadHabitCounterData? {
        return Bad_Habit_Counter.load()
    }
    
    func write() -> Bool {
        return Bad_Habit_Counter.write(data: data)
    }
    
    func reloadData() {
        calendarView.reloadData()
        tableView.reloadData()
    }
    
    func reloadAndWrite() {
        reloadData()
        _ = write()
    }

    // count shouldn't be negative
    func color(for count: Int) -> UIColor? {
        let count: CGFloat = CGFloat(count)
        
        if count == 0 {
            return nil
        }
        
        if count <= COLOR_STEP_MAX/2 {
            return UIColor(red: count/(COLOR_STEP_MAX/2), green: 1, blue: 0, alpha: 1)
        }
        
        if count <= COLOR_STEP_MAX  {
            return UIColor(red: 1, green: 1-(count-COLOR_STEP_MAX/2)/(COLOR_STEP_MAX/2), blue: 0, alpha: 1)
        }
        
        return .red
    }
    
    func color(for date: Date) -> UIColor? {
        return calendar(calendarView, appearance: calendarView.appearance, fillDefaultColorFor: date)
    }
    
    func scroll(to date: Date) {
        selectedDate = date
        refreshSelectionColor(for: date)
        calendarView.select(date, scrollToDate: true)
    }
    
    func refreshSelectionColor(for date: Date) {
        calendarView.appearance.selectionColor = color(for: date)
    }

}

extension ViewController: FSCalendarDataSource {
    func minimumDate(for calendar: FSCalendar) -> Date {
        return data?.startDate ?? today()
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
}

extension ViewController: FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        refreshSelectionColor(for: date)
        tableView.reloadData()
    }


}

extension ViewController: FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        return color(for: data.count(for: date))
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        return titleColor(for: date)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        return titleColor(for: date)
    }
    
    func titleColor(for date: Date) -> UIColor {
        if endOfDay(for: date) < data.startDate || Date() < date || 0 < data.count(for: date) {
            return .systemBackground
        }
        return .white
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.habits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HabitTableViewCell = tableView.dequeueReusableCell(withIdentifier: CELL_REUSE_IDENTIFIER) as! HabitTableViewCell
        let habit: Habit = data.habits[indexPath.row]
        
        cell.viewController = self
        cell.habit = habit
        
        cell.habitLabel.text = habit.name
        cell.totalCountLabel.text = String(habit.total)
        cell.currCountLabel.text = String(habit.get(selectedDate))
        
        cell.selectButton.backgroundColor = habit.show ? .blue : .systemBackground
        cell.selectButton.setTitleColor(habit.show ? .white : .blue, for: .normal)
        cell.selectButton.setTitle(habit.show ? "Hide" : "Show", for: .normal)
                
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            data.habits.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            refreshSelectionColor(for: selectedDate)
            reloadAndWrite()
        }
    }

}

extension ViewController: UITableViewDelegate {
    
}
