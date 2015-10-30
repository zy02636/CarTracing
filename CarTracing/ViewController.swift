//
//  ViewController.swift
//  CarTracing
//
//  Created by li pengxuan on 15/10/30.
//  Copyright © 2015年 li pengxuan. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //MARK : - Private Funcs
    @IBAction func historyBtnClick() {
        let historyViewController = HistoryViewController(nibName: "HistoryViewController", bundle: nil)
        self.presentViewController(historyViewController, animated: true, completion: nil)
    }
    
}

