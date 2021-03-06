//
//  AttributeCell.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/23/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

final class AttributeCell: UITableViewCell, ClassNameNibLoadable {
    
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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        backgroundColor = .clear
        speedValues.text = ""
        mightValues.text = ""
        sanityValues.text = ""
        knowledgeValues.text = ""
    }
    
    func setupLabels(withAttribute attribute: Attribute) {
        speedValues.text?.append(attribute.speed.toString())
        mightValues.text?.append(attribute.might.toString())
        sanityValues.text?.append(attribute.sanity.toString())
        knowledgeValues.text?.append(attribute.knowledge.toString())
    }
}
