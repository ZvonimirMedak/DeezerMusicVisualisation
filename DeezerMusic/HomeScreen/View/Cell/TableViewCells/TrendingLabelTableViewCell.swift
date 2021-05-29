//
//  TrendingUICollectionHeader.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 04/06/2020.
//  Copyright © 2020 Zvonimir Medak. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class TrendingLabelTableViewCell: UITableViewCell{
    let trendingLabel: UILabel = {
        let label = UILabel()
        StyleManager.shared.apply(label: label)
        label.text = "Trending"
        label.font = UIFont.boldSystemFont(ofSize: 36)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        self.addSubview(trendingLabel)
        StyleManager.shared.apply(for: .ContentView, view: contentView)
        setupConstraints()
    }
    
    private func setupConstraints(){
        trendingLabel.snp.makeConstraints { (maker) in
            maker.leading.bottom.top.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 0))
        }
    }
}
