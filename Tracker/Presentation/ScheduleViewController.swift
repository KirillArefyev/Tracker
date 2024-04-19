//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Кирилл Арефьев on 18.04.2024.
//

import UIKit

final class ScheduleViewController: UIViewController, UITableViewDelegate {
    
    weak var delegate: CreatingNewTrackerViewController?
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = "Расписание"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .trWhite
        
    }
}
