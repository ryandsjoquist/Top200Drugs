//
//  DrugCell.swift
//  Top 200 Drugs 2016
//
//  Created by Ryan Sjoquist on 8/31/16.
//  Copyright © 2016 Ryan Sjoquist. All rights reserved.
//

import UIKit

class DrugCell: UITableViewCell {
    
    
    @IBOutlet weak var drugGenericNameLabel: UILabel!
    @IBOutlet weak var drugBrandNameLabel: UILabel!
    @IBOutlet weak var drugClassNameLabel: UILabel!
    
    var individualDrugGenericName:String!
    var individualDrugClass:String!
    var individualDrugMechanism:String!
    var individualDrugBrandName:String!
    var individualDrugRating:Int!
    
    override func awakeFromNib() {
        
        drugGenericNameLabel.adjustsFontSizeToFitWidth = true
        drugClassNameLabel.adjustsFontSizeToFitWidth = true
    }
    
    func setUpCell(drugGenericName:String, drugBrandName:String, drugRating:Int, drugClass:String, drugMechanism:String){
        
        individualDrugGenericName = drugGenericName
        individualDrugBrandName = drugBrandName
        individualDrugRating = drugRating
        individualDrugClass = drugClass
        individualDrugMechanism = drugMechanism
        
        drugGenericNameLabel.text = individualDrugGenericName
        drugClassNameLabel.text = individualDrugClass
        drugBrandNameLabel.text = individualDrugBrandName
        
    }
    
   
    
    
}
