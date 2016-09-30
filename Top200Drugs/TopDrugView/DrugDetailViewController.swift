//
//  DrugDetailViewController.swift
//  Top 200 Drugs 2016
//
//  Created by Ryan Sjoquist on 8/30/16.
//  Copyright © 2016 Ryan Sjoquist. All rights reserved.
//

import UIKit

class DrugDetailViewController: UIViewController {

    @IBOutlet weak var drugGenericNameLabel: UILabel!
    @IBOutlet weak var drugBrandNameLabel: UILabel!
    @IBOutlet weak var drugRankingNameLabel: UILabel!
    @IBOutlet weak var drugClassNameLabel: UILabel!
    @IBOutlet weak var drugMechanismLabel: UILabel!


    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let genericNameLabel = self.drugGenericNameLabel {
                genericNameLabel.text = detail.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

