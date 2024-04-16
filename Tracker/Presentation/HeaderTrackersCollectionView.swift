//
//  HeaderTrackersCollectionView.swift
//  Tracker
//
//  Created by Кирилл Арефьев on 15.04.2024.
//

import UIKit

final class HeaderTrackersCollectionView: UICollectionReusableView {
    
    private lazy var titleCategory: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = .trBlack
        label.text = "Домашний уют"
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleCategory)
        
        titleCategory.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleCategory.topAnchor.constraint(equalTo: topAnchor),
            titleCategory.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleCategory.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
