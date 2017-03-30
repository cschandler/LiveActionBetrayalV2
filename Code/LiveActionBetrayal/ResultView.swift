//
//  ResultView.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/30/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

class ResultView: UIView {
    
    typealias Result = (Int, String)
    
    required init(frame: CGRect, color: UIColor, result: Result) {
        super.init(frame: frame)
        
        layer.cornerRadius = min(bounds.height, bounds.width) / 4
        backgroundColor = color
        alpha = 0.0
        clipsToBounds = true
        
        let resultLabel = UILabel()
        resultLabel.text = result.1
        resultLabel.font = UIFont.boldSystemFont(ofSize: 40)
        resultLabel.backgroundColor = color
        resultLabel.textColor = .white
        resultLabel.textAlignment = .center
        resultLabel.numberOfLines = 2
        addSubview(resultLabel)
        
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        resultLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        resultLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        resultLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension String {
    public func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
    
    public func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.width
    }
}
