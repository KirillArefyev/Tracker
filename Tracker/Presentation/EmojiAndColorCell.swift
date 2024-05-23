//
//  EmojiAndColorCell.swift
//  Tracker
//
//  Created by Кирилл Арефьев on 13.05.2024.
//

import UIKit

final class EmojiAndColorCell: UICollectionViewCell {
    static let identifier = "emojiAndColorCell"
    
    private lazy var cellView: UILabel = {
        let label = UILabel(frame: bounds)
        label.font = UIFont.systemFont(ofSize: 32)
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(cellView)
        
        cellView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cellView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cellView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellView.widthAnchor.constraint(equalToConstant: 40),
            cellView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurate(at indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            cellView.text = HelperData.emojis[indexPath.item]
        case 1:
            cellView.backgroundColor = HelperData.selectionColors[indexPath.item]
        default:
            break
        }
    }
    
    func didSelect(at indexPath: IndexPath) {
        switch  indexPath.section {
        case 0:
            contentView.backgroundColor = .trLightGray
            contentView.layer.cornerRadius = 16
            contentView.layer.masksToBounds = true
        case 1:
            contentView.layer.borderColor = cellView.backgroundColor?.withAlphaComponent(0.3).cgColor
            contentView.layer.borderWidth = 3
            contentView.layer.cornerRadius = 12
            contentView.layer.masksToBounds = true
        default:
            break
        }
    }
    
    func didDeselect(at indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            contentView.backgroundColor = .clear
        case 1:
            contentView.layer.borderColor = UIColor.clear.cgColor
        default:
            break
        }
    }
}
