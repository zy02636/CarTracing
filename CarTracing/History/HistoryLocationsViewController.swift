//
//  HistoryLocationsViewController.swift
//  CarTracing
//
//  Created by li pengxuan on 15/11/16.
//  Copyright © 2015年 li pengxuan. All rights reserved.
//

import UIKit

@objc class HistoryLocationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var dataArray = [Dictionary<String, Double>]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "historyLocationsTableViewCell")
        tableView.reloadData()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UITableView Delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("historyLocationsTableViewCell", forIndexPath: indexPath)
        let locationDic = dataArray[indexPath.row]
        let latitude = locationDic["latitude"]!
        let longitude = locationDic["longitude"]!
        let latitudeStr = String(format: "%.4f", latitude)
        let longitudeStr = String(format: "%.4f", longitude)
        cell.textLabel?.text = "latitude \(latitudeStr), longitude \(longitudeStr)"
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
