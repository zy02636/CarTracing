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
    
    var tracePart = TracePart()
    //timer刷新UI用
    var timer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //MARK : - Private Funcs
    
    //Go to History page
    @IBAction func historyBtnClick() {
//        let historyViewController = HistoryViewController(nibName: "HistoryViewController", bundle: nil)
//        self.presentViewController(historyViewController, animated: true, completion: nil)
        let historyTableViewController = HistoryTableViewController(homeView: self)
        
        let naviController = UINavigationController(rootViewController: historyTableViewController)
        let window = UIApplication.sharedApplication().keyWindow
        window?.rootViewController = naviController
        self.navigationController?.pushViewController(historyTableViewController, animated: true)
        //self.presentViewController(historyTableViewController, animated: true, completion: nil)

    }
    
    
    //GPS start/stop
    @IBAction func traceBtnClick() {
        
        
        
        
        tracePart.startTrace()
    }
}

