//
//  SelectingNewTrackerViewController.swift
//  Tracker
//
//  Created by Кирилл Арефьев on 13.04.2024.
//

import UIKit

final class SelectingNewTrackerViewController: UIViewController {
    
    weak var delegate: TrackersViewController?
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = "Создание трекера"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var habitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Привычка", for: .normal)
        button.addTarget(self, action: #selector(didTapToHabitButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var irregularEventButton: UIButton = {
        let button = UIButton()
        button.setTitle("Нерегулярное событие", for: .normal)
        button.addTarget(self, action: #selector(didTapToIrregularEventButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16.0
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .trWhite
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        [textLabel, buttonsStack].forEach { view.addSubview($0) }
        
        [habitButton, irregularEventButton].forEach {
            $0.backgroundColor = .trBlack
            $0.setTitleColor(.trWhite, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            $0.layer.cornerRadius = 16
            $0.clipsToBounds = true
            
            buttonsStack.addArrangedSubview($0)
        }
    }
    
    private func applyConstraints() {
        [textLabel, habitButton, irregularEventButton, buttonsStack].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            
            buttonsStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        [habitButton, irregularEventButton].forEach {
            NSLayoutConstraint.activate([
                $0.heightAnchor.constraint(equalToConstant: 60),
                $0.leadingAnchor.constraint(equalTo: buttonsStack.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: buttonsStack.trailingAnchor),
            ])
        }
    }
    
    @objc private func didTapToHabitButton() {
        let creatingNewTrackerViewController = CreatingNewTrackerViewController(typeTracker: .habit)
        creatingNewTrackerViewController.delegate = self
        present(creatingNewTrackerViewController, animated: true)
        print("Создание новой привычки")
    }
    
    @objc private func didTapToIrregularEventButton() {
        let creatingNewTrackerViewController = CreatingNewTrackerViewController(typeTracker: .irregularEvent)
        creatingNewTrackerViewController.delegate = self
        present(creatingNewTrackerViewController, animated: true)
        print("Создание нового нерегулярного события")
    }
}
