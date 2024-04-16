//
//  CreatingNewTrackerViewController.swift
//  Tracker
//
//  Created by Кирилл Арефьев on 13.04.2024.
//

import UIKit

final class CreatingNewTrackerViewController: UIViewController {
    
    weak var delegate: SelectingNewTrackerViewController?
    
    private let typeTracker: TypeTracker?
    private var heightTable: CGFloat = 0
    
    private let emojis: [String] = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    private let selectionColors: [UIColor] = [
        .color1, .color2, .color3, .color4, .color5, .color6,
        .color7, .color8, .color9, .color10, .color11, .color12,
        .color13, .color14, .color15, .color16, .color17, .color18
    ]
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        switch typeTracker {
        case .habit:
            label.text = "Новая привычка"
        case .irregularEvent:
            label.text = "Новое нерегулярное событие"
        case nil:
            break
        }
        return label
    }()
    
    private lazy var inputTrackerNameField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.textColor = .trBlack
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.autocorrectionType = .no
        return textField
    }()
    
    private lazy var categoryAndScheduleTable: UITableView = {
        let tableView = UITableView()
        //        tableView.dataSource = self
        //        tableView.delegate = self
        //        tableView.register(CreatingNewTrackerViewController.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private lazy var textFieldAndTableViewStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 24.0
        return stackView
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.trRed, for: .normal)
        button.layer.borderColor = UIColor.trRed.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(didTapToCancelButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Создать", for: .normal)
        button.addTarget(self, action: #selector(didTapToCreateButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8.0
        return stackView
    }()
    
    init(typeTracker: TypeTracker?) {
        self.typeTracker = typeTracker
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .trWhite
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        [textLabel,
         textFieldAndTableViewStack,
         buttonStack].forEach { view.addSubview($0) }
        
        [inputTrackerNameField,
         categoryAndScheduleTable].forEach {
            $0.backgroundColor = .trBackground
            $0.layer.cornerRadius = 16
            $0.layer.masksToBounds = true
            
            textFieldAndTableViewStack.addArrangedSubview($0)
        }
        
        [cancelButton, createButton].forEach {
            $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            $0.layer.cornerRadius = 16
            $0.layer.masksToBounds = true
            
            buttonStack.addArrangedSubview($0)
        }
    }
    
    private func applyConstraints() {
        switch typeTracker {
        case .habit:
            self.heightTable = 150
        case .irregularEvent:
            self.heightTable = 75
        case nil:
            break
        }
        
        [textLabel, inputTrackerNameField, categoryAndScheduleTable, textFieldAndTableViewStack, cancelButton, createButton, buttonStack].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            
            textFieldAndTableViewStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  16),
            textFieldAndTableViewStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textFieldAndTableViewStack.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 38),
            
            inputTrackerNameField.heightAnchor.constraint(equalToConstant: 75),
            
            categoryAndScheduleTable.heightAnchor.constraint(equalToConstant: heightTable),
            
            buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        [inputTrackerNameField, categoryAndScheduleTable].forEach {
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: textFieldAndTableViewStack.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: textFieldAndTableViewStack.trailingAnchor)
            ])
        }
        
        [cancelButton, createButton].forEach {
            NSLayoutConstraint.activate([
                $0.heightAnchor.constraint(equalToConstant: 60)
            ])
        }
    }
    
    @objc private func didTapToCancelButton() {
        print("Отменить")
    }
    
    @objc private func didTapToCreateButton() {
        print("Создать")
    }
}
//// MARK: - Extesions
//extension CreatingNewTrackerViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
//        return cell
//    }
//    
//    
//}
//
//
//extension CreatingNewTrackerViewController: UITableViewDelegate {
//    
//}
