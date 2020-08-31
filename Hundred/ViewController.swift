//
//  ViewController.swift
//  Hundred
//
//  Created by jc on 2020-07-31.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit
import CalendarHeatmap
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    var data: [String: UIColor]!
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 30, bottom:  50, trailing: 30)
        scrollView.addSubview(stackView)
        return stackView
    }()
    
    lazy var calendarHeatMap: CalendarHeatmap = {
        var config = CalendarHeatmapConfig()
        config.backgroundColor = UIColor(ciColor: .white)
        // config item
        config.selectedItemBorderColor = .white
        config.allowItemSelection = true
        // config month header
        config.monthHeight = 30
        config.monthStrings = DateFormatter().shortMonthSymbols
        config.monthFont = UIFont.systemFont(ofSize: 18)
        config.monthColor = UIColor(ciColor: .black)
        // config weekday label on left
        config.weekDayFont = UIFont.systemFont(ofSize: 12)
        config.weekDayWidth = 30
        config.weekDayColor = UIColor(ciColor: .black)

        var dateComponent = DateComponents()
        let yearsBefore = -1
        dateComponent.year = yearsBefore
        if let startDate = Calendar.current.date(byAdding: dateComponent, to: Date()) {
            let calendar = CalendarHeatmap(config: config, startDate: startDate, endDate: Date())
            calendar.delegate = self
            return calendar
        } else {
            let calendar = CalendarHeatmap(config: config, startDate: Date(2019, 1, 1), endDate: Date())
            calendar.delegate = self
            return calendar
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
                
        var dataImporter = DataImporter(goalTitle: nil)
        data = dataImporter.data
        
        configureUI()
        setConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendarHeatMap.reload()
        
        calculateStreak()

    }
    
    func configureUI() {
        navigationController?.title = "Home"
        navigationController?.navigationBar.isHidden = true
        
        addCard(text: "Calendar", subItem: calendarHeatMap, stackView: stackView, containerHeight: 270)
    }
    
    func setConstraints() {
        stackView.pin(to: scrollView)
    }
    
    func calculateStreak() {
        struct FakeGoal {
            var title: String!
            var longestStreak: Int16
            var streak: Int16
        }
        
        let goal1 = FakeGoal(title: "Bike", longestStreak: 100, streak: 3)
        let goal2 = FakeGoal(title: "Boat", longestStreak: 23, streak: 23)
        let goal3 = FakeGoal(title: "Car", longestStreak: 34, streak: 2)
        let goal4 = FakeGoal(title: "Running", longestStreak: 56, streak: 45)
        let goal5 = FakeGoal(title: "Drum", longestStreak: 78, streak: 6)
        
        let fakeGoals = [goal1, goal2, goal3, goal4, goal5]
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Goal")
        do {
            let result = try self.context.fetch(fetchRequest)
            let goals = result as! [Goal]
            
            for goal in fakeGoals {
                let streakContainer = UIView()
                let currentStreak = UILabel()
                currentStreak.text = String(goal.streak)
                let longestStreak = UILabel()
                longestStreak.text = String(goal.longestStreak)
                streakContainer.addSubview(currentStreak)
                streakContainer.addSubview(longestStreak)
                
                
                currentStreak.translatesAutoresizingMaskIntoConstraints = false
                currentStreak.widthAnchor.constraint(equalTo: streakContainer.widthAnchor, multiplier: 0.5).isActive = true
                currentStreak.leadingAnchor.constraint(equalTo: streakContainer.leadingAnchor).isActive = true
                longestStreak.translatesAutoresizingMaskIntoConstraints = false
                longestStreak.widthAnchor.constraint(equalTo: streakContainer.widthAnchor, multiplier: 0.5).isActive = true
                longestStreak.leadingAnchor.constraint(equalTo: currentStreak.trailingAnchor).isActive = true
                
                addCard(text: goal.title, subItem: streakContainer, stackView: stackView, containerHeight: 130, bottomSpacing: 40)
            }
        } catch {
            print("error")
        }
    }
}

extension ViewController: CalendarHeatmapDelegate {
    func didSelectedAt(dateComponents: DateComponents) {
        guard let year = dateComponents.year,
            let month = dateComponents.month,
            let day = dateComponents.day else { return }
 
        if let vc = storyboard?.instantiateViewController(withIdentifier: "CalendarDetail") as? CalendarDetailTableViewController {
            vc.date = [year, month, day]
            present(vc, animated: true)
        }
    }
    
    func colorFor(dateComponents: DateComponents) -> UIColor {
        guard let year = dateComponents.year,
            let month = dateComponents.month,
            let day = dateComponents.day else { return .clear}
        let dateString = "\(year).\(month).\(day)"
        return data[dateString] ?? UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
    }
    
    func finishLoadCalendar() {
        calendarHeatMap.scrollTo(date: Date(), at: .right, animated: false)
    }
}

