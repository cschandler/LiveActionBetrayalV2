//
//  AttributeCell.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/23/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

final class AttributeCell: UITableViewCell {
    
    @IBOutlet weak var gradientView: AttributeGradientView!
    @IBOutlet weak var attribute: UILabel!
    @IBOutlet weak var stackViewHieghtConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var might: UILabel!
    @IBOutlet weak var speed: UILabel!
    @IBOutlet weak var knowledge: UILabel!
    @IBOutlet weak var sanity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectedBackgroundView = UIView()
        gradientView.alpha = 0.0
        stackViewHieghtConstraint.constant = 0.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        gradientView.alpha = 0.0
    }
    
    var isExpanded: Bool = false {
        didSet {
            stackViewHieghtConstraint.constant = isExpanded ? 100 : 0
        }
    }
    
    func setupLabels(withAttribute attribute: Attribute, andColor color: UIColor) {
        speed.text?.append(attribute.speed.toString())
        might.text?.append(attribute.might.toString())
        sanity.text?.append(attribute.sanity.toString())
        knowledge.text?.append(attribute.knowledge.toString())
        
        speed.textColor = color
        might.textColor = color
        sanity.textColor = color
        knowledge.textColor = color
    }
}
