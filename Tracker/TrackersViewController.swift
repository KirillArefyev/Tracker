//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Кирилл Арефьев on 07.04.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    private lazy var noTrackersImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Star")
        return imageView
    }()
    
    private lazy var noTrakersText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Что будем отслеживать?"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .trBlack
        label.textAlignment = .center
        return label
    }()
    
    private lazy var noTrackersStub: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8.0
        stackView.addArrangedSubview(noTrackersImage)
        stackView.addArrangedSubview(noTrakersText)
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        view.backgroundColor = .trWhite
        [noTrackersStub].forEach { view.addSubview($0) }
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            noTrackersStub.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            noTrackersStub.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.backgroundColor = .trWhite
        navigationController?.navigationBar.tintColor = .trBlack
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Трекеры"
        
        lazy var addTrackerButton: UIBarButtonItem = {
            let addTrackerButton = UIBarButtonItem()
            addTrackerButton.image = UIImage(systemName: "plus")
            addTrackerButton.target = self
            addTrackerButton.action = #selector(didTapToAddNewTracker)
            return addTrackerButton
        }()
        navigationItem.leftBarButtonItem = addTrackerButton
    }
    
    @objc private func didTapToAddNewTracker() {
        print("Создание нового трекера")
    }
}
