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
    @IBOutlet weak var mightValues: UILabel!
    @IBOutlet weak var speed: UILabel!
    @IBOutlet weak var speedValues: UILabel!
    @IBOutlet weak var knowledge: UILabel!
    @IBOutlet weak var knowledgeValues: UILabel!
    @IBOutlet weak var sanity: UILabel!
    @IBOutlet weak var sanityValues: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectedBackgroundView = UIView()
        gradientView.alpha = 0.0
        isExpanded = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        gradientView.alpha = 0.0
        gradientView.startColor = .clear
        gradientView.endColor = .clear
        isExpanded = false
        
        speedValues.text = ""
        mightValues.text = ""
        sanityValues.text = ""
        knowledgeValues.text = ""
    }
    
    var isExpanded: Bool = false {
        didSet {
            stackViewHieghtConstraint.constant = isExpanded ? 100 : 0
        }
    }
    
    func setupLabels(withAttribute attribute: Attribute, andColor color: UIColor) {
        speedValues.text?.append(attribute.speed.toString())
        mightValues.text?.append(attribute.might.toString())
        sanityValues.text?.append(attribute.sanity.toString())
        knowledgeValues.text?.append(attribute.knowledge.toString())
        
        speed.textColor = color
        might.textColor = color
        sanity.textColor = color
        knowledge.textColor = color
        
        speedValues.textColor = .white
        mightValues.textColor = .white
        sanityValues.textColor = .white
        knowledgeValues.textColor = .white
    }
}
