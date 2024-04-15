//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Кирилл Арефьев on 07.04.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    var categories: [TrackerCategory]?
    var completedTrakers: [TrackerRecord]?
    
    private lazy var noTrackersImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Star")
        return imageView
    }()
    
    private lazy var noTrakersText: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .trBlack
        label.textAlignment = .center
        return label
    }()
    
    private lazy var noTrackersStub: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8.0
        return stackView
    }()
    
    private lazy var errorImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var errorText: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var errorStub: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    private lazy var addTrackerButton: UIBarButtonItem = {
        let addTrackerButton = UIBarButtonItem(barButtonSystemItem: .add,
                                               target: self,
                                               action: #selector(didTapToAddNewTracker))
        return addTrackerButton
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.tintColor = .trBlue
        datePicker.locale = Locale(identifier: "ru_RU")
        return datePicker
    }()
    
    private lazy var searchField: UISearchController = {
        let searchField = UISearchController()
        searchField.searchBar.placeholder = "Поиск"
        searchField.searchBar.tintColor = .trBlue
        searchField.hidesNavigationBarDuringPresentation = false
        searchField.searchBar.searchTextField.clearButtonMode = .whileEditing
        searchField.searchBar.setValue("Отменить", forKey: "cancelButtonText")
        return searchField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .trWhite
        setupNavBar()
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        [noTrackersStub].forEach { view.addSubview($0) }
        
        [noTrackersImage, noTrakersText].forEach { noTrackersStub.addArrangedSubview($0) }
    }
    
    private func applyConstraints() {
        [noTrackersImage, noTrakersText, noTrackersStub].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            noTrackersStub.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            noTrackersStub.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
    
    private func setupNavBar() {
        if let navBar = navigationController?.navigationBar {
            navBar.backgroundColor = .trWhite
            navBar.tintColor = .trBlack
            navBar.prefersLargeTitles = true
            navigationItem.title = "Трекеры"
            navigationItem.leftBarButtonItem = self.addTrackerButton
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.datePicker)
            navigationItem.searchController = self.searchField
        }
    }
    
    @objc private func didTapToAddNewTracker() {
        let selectingNewTrackerViewController = SelectingNewTrackerViewController()
        selectingNewTrackerViewController.delegate = self
        present(selectingNewTrackerViewController, animated: true)
        print("Добавление трекера")
    }
}
