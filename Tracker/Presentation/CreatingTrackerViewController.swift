//
//  CreatingTrackerViewController.swift
//  Tracker
//
//  Created by Кирилл Арефьев on 13.04.2024.
//

import UIKit

protocol CreatingTrackerViewControllerDelegate: AnyObject {
    func appendTrackerToTrackerCategory(_ trackerCategory: TrackerCategory)
}

final class CreatingTrackerViewController: UIViewController {
    // MARK: - Public Properties
    weak var delegate: SelectingTrackerViewController?
    
    // MARK: - Private Properties
    private var typeTracker: TypeTracker
    private var trackerName: String = ""
    private var trackerColor: UIColor = .clear
    private var trackerEmoji: String = ""
    private var trackerCategory: String = "Какая-то категория"
    private var trackerSchedule: [WeekDay] = []
    private var scheduleForTable: String = "" {
        didSet {
            tableView.reloadData()
        }
    }
    private var emojiIndexPath: IndexPath? = nil
    private var colorIndexPath: IndexPath? = nil
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.text = typeTracker.title
        label.textColor = .trBlack
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .trBackground
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.placeholder = "Введите название трекера"
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.textColor = .trBlack
        textField.clearButtonMode = .whileEditing
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.resignFirstResponder()
        textField.keyboardType = .default
        textField.returnKeyType = .go
        textField.autocorrectionType = .no
        textField.delegate = self
        textField.addTarget(self, action: #selector(setTrackerName), for: .editingDidEndOnExit)
        return textField
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tableCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .trBackground
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.separatorInset =  UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorColor = .trGray
        tableView.isScrollEnabled = false
        tableView.reloadData()
        return tableView
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.trRed, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.trRed.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .trGray
        button.setTitle("Создать", for: .normal)
        button.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8.0
        [cancelButton, createButton].forEach {
            $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            $0.layer.cornerRadius = 16
            $0.layer.masksToBounds = true
            
            stackView.addArrangedSubview($0)
        }
        return stackView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(EmojiAndColorCell.self, forCellWithReuseIdentifier: EmojiAndColorCell.identifier)
        collectionView.register(HeaderTrackersCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderTrackersCollectionView.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsMultipleSelection = true
        return collectionView
    }()
    
    // MARK: - Inits
    init(_ typeTracker: TypeTracker) {
        self.typeTracker = typeTracker
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
        trackerSchedule = typeTracker.trackerSchedule
    }
    
    // MARK: - Private Methods
    private func addSubviews() {
        [textLabel,
         nameTextField,
         tableView,
         collectionView,
         buttonStack].forEach { view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            
            nameTextField.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 38),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            tableView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24 ),
            tableView.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: typeTracker.heightTable),
            
            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
            collectionView.bottomAnchor.constraint(equalTo: buttonStack.topAnchor, constant: -16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        [cancelButton, createButton].forEach {
            NSLayoutConstraint.activate([
                $0.heightAnchor.constraint(equalToConstant: 60)
            ])
        }
    }
    
    private func activationCreateButton() {
        createButton.isEnabled = true
        createButton.backgroundColor = .trBlack
    }
    
    private func deactivationCreateButton() {
        createButton.isEnabled = false
        createButton.backgroundColor = .trGray
    }
    
    private func validationOfRequiredValues() {
        if (trackerName != "" &&
            trackerCategory.isEmpty != true &&
            trackerSchedule.isEmpty != true &&
            trackerColor != UIColor.clear &&
            trackerEmoji != "") {
            activationCreateButton()
        } else {
            deactivationCreateButton()
        }
    }
    
    private func newTracker() -> Tracker {
        let tracker = Tracker(id: UUID(),
                              name: trackerName,
                              color: trackerColor,
                              emoji: trackerEmoji,
                              schedule: trackerSchedule)
        return tracker
    }
    
    private func createCategory(with newTracker: () -> Tracker) -> TrackerCategory {
        let category = TrackerCategory(name: trackerCategory,
                                       trackers: [newTracker()])
        return category
    }
    
    @objc private func setTrackerName(_ sender: UITextField) {
        if sender.text != nil {
            trackerName = sender.text ?? ""
            validationOfRequiredValues()
        }
    }
    
    @objc private func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTapCreateButton() {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            let trackerCategory = self.createCategory(with: self.newTracker)
            self.delegate?.appendTrackerToTrackerCategory(trackerCategory)
        }
    }
}

// MARK: - TableViewDataSource
extension CreatingTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeTracker.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "tableCell")
        cell.accessoryType = .disclosureIndicator
        cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        cell.backgroundColor = .clear
        cell.textLabel?.text = typeTracker.cellName[indexPath.row]
        cell.detailTextLabel?.textColor = .trGray
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.selectionStyle = .none
        
        switch indexPath.row {
        case 0:
            cell.detailTextLabel?.text = trackerCategory // TODO: - позже подставлять значение из вью создания и выбора категории
        case 1:
            if trackerSchedule.count != 7 {
                cell.detailTextLabel?.text = scheduleForTable
            } else {
                cell.detailTextLabel?.text = "Каждый день"
            }
        default:
            break
        }
        
        if indexPath.row == typeTracker.cellName.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        return cell
    }
    
    private func convertScheduleToString(_ sellectedDays: [WeekDay]) -> String {
        let newSchedule = sellectedDays.map { $0.shortName }
        let list = newSchedule.joined(separator: ", ")
        return list
    }
}

// MARK: - TableViewDelegate
extension CreatingTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("➡️ Переход к экрану создания и выбора категории")
        case 1:
            let scheduleViewController = ScheduleViewController()
            scheduleViewController.delegate = self
            present(scheduleViewController, animated: true)
        default:
            break
        }
    }
}

// MARK: - CollectionViewDataSource
extension CreatingTrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return HelperData.sectionTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return HelperData.emojis.count
        case 1:
            return HelperData.selectionColors.count
        default:
            return Int()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiAndColorCell.identifier, for: indexPath) as? EmojiAndColorCell else {
            assertionFailure("❌ no cell")
            return UICollectionViewCell()
        }
        
        cell.configurate(at: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderTrackersCollectionView.identifier, for: indexPath) as? HeaderTrackersCollectionView else {
            assertionFailure("❌ no header")
            return UICollectionReusableView()
        }
        
        let setTitle: () = view.setSectionTitle(HelperData.sectionTitles[indexPath.section])
        switch indexPath.section {
        case 0:
            setTitle
        case 1:
            setTitle
        default:
            break
        }
        return view
    }
}

// MARK: - CollectionViewDelegate
extension CreatingTrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let spacing = CGFloat(collectionView.frame.width - 18 * 2 - 52 * 6) / 5
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingCompressedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? EmojiAndColorCell {
            switch indexPath.section {
            case 0:
                selectCellInSection(in: collectionView, where: cell, currentIndexPath: indexPath, selectedCellIndexPath: &emojiIndexPath)
            case 1:
                selectCellInSection(in: collectionView, where: cell, currentIndexPath: indexPath, selectedCellIndexPath: &colorIndexPath)
            default:
                break
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? EmojiAndColorCell {
            cell.didDeselect(at: indexPath)
            removeTrackerEmojiAndColor(at: indexPath)
        }
    }
    
    private func selectCellInSection(in collectionView: UICollectionView, where cell: EmojiAndColorCell, currentIndexPath indexPath: IndexPath, selectedCellIndexPath emojiOrColorCellIndexPath: inout IndexPath?) {
        if emojiOrColorCellIndexPath == nil {
            cell.didSelect(at: indexPath)
            emojiOrColorCellIndexPath = indexPath
            setTrackerEmojiAndColor(at: indexPath)
        } else {
            if let oldCell = collectionView.cellForItem(at: emojiOrColorCellIndexPath ?? IndexPath()) as? EmojiAndColorCell {
                oldCell.didDeselect(at: indexPath)
                emojiOrColorCellIndexPath = nil
                cell.didSelect(at: indexPath)
                emojiOrColorCellIndexPath = indexPath
                setTrackerEmojiAndColor(at: indexPath)
            }
        }
    }
    
    private func setTrackerEmojiAndColor(at indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            trackerEmoji = HelperData.emojis[indexPath.item]
        case 1:
            trackerColor = HelperData.selectionColors[indexPath.item]
        default:
            break
        }
        validationOfRequiredValues()
    }
    
    private func removeTrackerEmojiAndColor(at indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            trackerEmoji = ""
        case 1:
            trackerColor = UIColor.clear
        default:
            break
        }
        validationOfRequiredValues()
    }
}

// MARK: - TextFieldDelegate
extension CreatingTrackerViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newLength = currentText.count + string.count - range.length
        return newLength <= 38
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

// MARK: - ScheduleViewControllerDelegate
extension CreatingTrackerViewController: ScheduleViewControllerDelegate {
    func createSchedule(_ selectedDays: [WeekDay]) {
        scheduleForTable = convertScheduleToString(selectedDays)
        trackerSchedule = selectedDays
        validationOfRequiredValues()
    }
}
