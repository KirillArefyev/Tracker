//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Кирилл Арефьев on 18.04.2024.
//

import UIKit

final class ScheduleViewController: UIViewController {
    weak var delegate: CreatingNewTrackerViewController?
    // MARK: - Private Properties
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = "Расписание"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .trBlack
        return label
    }()
    
    private lazy var weekDaysTable: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .trBackground
        tableView.layer.cornerRadius = 16
        tableView.layer.maskedCorners = [.layerMinXMinYCorner,
                                         .layerMinXMaxYCorner,
                                         .layerMaxXMinYCorner,
                                         .layerMaxXMaxYCorner]
        tableView.separatorInset =  UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorColor = .trGray
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private lazy var readyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .trBlack
        button.setTitle("Готово", for: .normal)
        button.addTarget(self, action: #selector(didTapReadyButton), for: .touchUpInside)
        return button
    }()
    // MARK: - Inits
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Overriding Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .trWhite
        addSubviews()
        applyConstraints()
        
    }
    // MARK: - Private Methods
    private func addSubviews() {
        [textLabel,
         weekDaysTable,
         readyButton].forEach { view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            textLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            
            weekDaysTable.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 30),
            weekDaysTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            weekDaysTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            weekDaysTable.heightAnchor.constraint(equalToConstant: 525),
            
            readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            readyButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func didTapReadyButton() {
        dismiss(animated: true)
    }
}
// MARK: - Extension: TableViewDataSource
extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.backgroundColor = .clear
        return cell
    }
}
// MARK: - Extension: TableViewDelegate
extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
