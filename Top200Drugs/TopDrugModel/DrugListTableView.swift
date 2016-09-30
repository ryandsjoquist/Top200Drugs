//
//  DrugListTableView.swift
//  Top 200 Drugs 2016
//
//  Created by Ryan Sjoquist on 8/31/16.
//  Copyright © 2016 Ryan Sjoquist. All rights reserved.
//

import UIKit

class DrugListTableView: UITableViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseJSON()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drugListData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath:indexPath) as! DrugCell
        if let drug = drugListData[indexPath.row] as? Drug{
            cell.setUpCell(drug.genericName,
                           drugBrandName: drug.brandName,
                           drugRating: drug.rating,
                           drugClass: drug.classification,
                           drugMechanism: drug.mechanism)
        }
        return cell
    }
    
    //    MARK: - DRUG PARSING
    
    struct Drug {
        var genericName:String!
        var brandName:String!
        var rating:Int!
        var classification:String!
        var mechanism:String!
        
        init(genericName:String,brandName:String,rating:Int,classification:String,mechanism:String) {
            self.genericName = genericName
            self.brandName = brandName
            self.rating = rating
            self.classification = classification
            self.mechanism = mechanism
        }
        
    }
    
    var drugListData:Array< Drug > = Array < Drug >()
    
    
    func parseJSON() {
        if let path = NSBundle.mainBundle().pathForResource("Top200Drugs", ofType:"json") {
            do {
                let jsonData = try NSData(contentsOfFile:path, options: NSDataReadingOptions.DataReadingMappedAlways)
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .AllowFragments)
                    
                    if let drugsList = json["Drug List Result"] as? [[String:AnyObject]]{
                        drugListData = []
                        
                        for drug in drugsList{
                            if let drugGenericName = drug["Generic Name"] as? String{
                                print(drugGenericName)
                                if let drugBrandName = drug["Brand Name"] as? String{
                                    if let drugRatingNumber = drug["Rating"] as? NSNumber{
                                        let drugRating = drugRatingNumber.integerValue
                                        if let drugClass = drug["Class"] as? String{
                                            if let drugMechanism = drug["Mechanism of Action"] as? String{
                                               
                                                    let drug = Drug(genericName: drugGenericName,
                                                                    brandName: drugBrandName,
                                                                    rating: drugRating,
                                                                    classification: drugClass,
                                                                    mechanism: drugMechanism)
                                                
                                                    drugListData.append(drug)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }
    }
}
