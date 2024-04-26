//
//  SelectingTrackerViewController.swift
//  Tracker
//
//  Created by Кирилл Арефьев on 13.04.2024.
//

import UIKit

protocol SelectingTrackerViewControllerDelegate: AnyObject {
    func appendTrackerToTrackerCategory(_ trackerCategory: TrackerCategory)
}

final class SelectingTrackerViewController: UIViewController {
    weak var delegate: TrackersViewController?
    // MARK: - Private Properties
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = "Создание трекера"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .trBlack
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
        [habitButton, irregularEventButton].forEach {
            $0.backgroundColor = .trBlack
            $0.setTitleColor(.trWhite, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            $0.layer.cornerRadius = 16
            $0.clipsToBounds = true
            
            stackView.addArrangedSubview($0)
        }
        return stackView
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
         buttonsStack].forEach { view.addSubview($0) }
    }
    
    private func applyConstraints() {
        [textLabel,
         buttonsStack].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            
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
        let creatingTrackerViewController = CreatingTrackerViewController(.habit)
        creatingTrackerViewController.delegate = self
        present(creatingTrackerViewController, animated: true)
    }
    
    @objc private func didTapToIrregularEventButton() {
        let creatingTrackerViewController = CreatingTrackerViewController(.irregularEvent)
        creatingTrackerViewController.delegate = self
        present(creatingTrackerViewController, animated: true)
    }
}
// MARK: - CreationNewTrackerViewControllerDelegate
extension SelectingTrackerViewController: CreatingTrackerViewControllerDelegate {
    func appendTrackerToTrackerCategory(_ trackerCategory: TrackerCategory) {
        self.delegate?.appendTrackerToTrackerCategory(trackerCategory)
    }
}
