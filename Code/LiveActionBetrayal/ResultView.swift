//
//  ResultView.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/30/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

class ResultView: UIView {
    
    let color: UIColor
    let result: Int
    
    required init(frame: CGRect, color: UIColor, result: Int) {
        self.color = color
        self.result = result
        
        super.init(frame: frame)
        
        layer.cornerRadius = bounds.width / 2
        backgroundColor = color
        alpha = 0.0
        clipsToBounds = true
        
        let resultLabel = UILabel()
        resultLabel.frame = bounds
        resultLabel.text = "\(result)"
        resultLabel.font = UIFont.boldSystemFont(ofSize: 40)
        resultLabel.backgroundColor = color
        resultLabel.textColor = .white
        resultLabel.textAlignment = .center
        addSubview(resultLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
