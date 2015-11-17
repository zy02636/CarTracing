//
//  ViewController.swift
//  CarTracing
//
//  Created by li pengxuan on 15/10/30.
//  Copyright © 2015年 li pengxuan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import HealthKit


class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!

    @IBOutlet weak var startBtn: UIButton!
    var locationManager: CLLocationManager!
    
    //记录数据
    var seconds = 0.0
    var distance = 0.0
    var locations = [Dictionary<String, Double>]()
    var timer = NSTimer()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Custom UI
        let historyBtn : UIBarButtonItem = UIBarButtonItem(title: "History", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("historyBtnClick"))
        self.navigationItem.leftBarButtonItem = historyBtn
        startBtn.layer.cornerRadius = 5
        
        //LocationManager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .AutomotiveNavigation
        //Movement threshold for new events
        locationManager.distanceFilter = 10.0
        
        locationManager.requestAlwaysAuthorization()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
//        timer.invalidate()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK : - CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            if location.horizontalAccuracy < 20 {
                
                //update distance
                if self.locations.count > 0 {
                    let lastLocationDic = self.locations.last!
                    let latitude = lastLocationDic["latitude"]!
                    let longitude = lastLocationDic["longitude"]!
                    let lastLocation = CLLocation(latitude: latitude, longitude: longitude)
                    distance += location.distanceFromLocation(lastLocation)
                }
                
                //save location
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude
                let locationDic = ["latitude": latitude, "longitude": longitude];
                self.locations.append(locationDic)
            }
        }
    }
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedAlways || status == CLAuthorizationStatus.AuthorizedWhenInUse {
            addRegion()
        }else {
            //todo 没授权定位提示
        }
    }

    //MARK : - Private Funcs
    
    //Add Region
    func addRegion() {
        //Map Region
        mapView.showsUserLocation = true
        let theSpan = MKCoordinateSpanMake(0.05, 0.05)
        let theRegion = MKCoordinateRegionMake((locationManager.location?.coordinate)!, theSpan)
        mapView.setRegion(theRegion, animated: true)
    }
    
    
    //Go to History page
    func historyBtnClick() {

        let historyTableViewController = HistoryTableViewController(homeView: self)
        let nav = UINavigationController(rootViewController: historyTableViewController)
        self.presentViewController(nav, animated: true, completion: nil)
        
    }
    
    
    //GPS start/stop
    @IBAction func traceBtnClick() {

        if startBtn.titleForState(.Normal) == "Start" {
            
            seconds = 0.0
            distance = 0.0
            locations.removeAll(keepCapacity: false)
            timer = NSTimer.scheduledTimerWithTimeInterval(1,
                target: self,
                selector: "eachSecond:",
                userInfo: nil,
                repeats: true)
            startLocationUpdates()
            
            startBtn.setTitle("Stop", forState: .Normal)
        }else {
            timer.invalidate()
            
            timeLabel.text = "Time: "
            distanceLabel.text = "Distance: "
            
            stopLocationUpdates()
            
            saveRun()
            
            startBtn.setTitle("Start", forState: .Normal)
        }

    }
    
    
    func startLocationUpdates() {
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }
    
    
    
    //Refresh UI perSecond
    func eachSecond(timer: NSTimer) {
        seconds++
        let secondsQuantity = HKQuantity(unit: HKUnit.secondUnit(), doubleValue: seconds)
        timeLabel.text = "Time: " + secondsQuantity.description
        let distanceQuantity = HKQuantity(unit: HKUnit.meterUnit(), doubleValue: distance)
        distanceLabel.text = "Distance: " + distanceQuantity.description
        
        //Pace
//        let paceUnit = HKUnit.secondUnit().unitDividedByUnit(HKUnit.meterUnit())
//        let paceQuantity = HKQuantity(unit: paceUnit, doubleValue: seconds / distance)
//        paceLabel.text = "Pace: " + paceQuantity.description
    }
    
    
    
    //["finish": "2015-11-16 19:00", "locations": [(123,456), (789,012)], "seconds": "500s", "distance": "1500m"]
    func saveRun() {
        
        var saveDic = Dictionary<String, AnyObject>()
        
        // 获取系统当前时间
        let date = NSDate()
        let sec = date.timeIntervalSinceNow
        let currentDate = NSDate(timeIntervalSinceNow: sec)
        saveDic["finish"] = currentDate
        
        //获取locations
        saveDic["locations"] = locations
        
        //获取seconds
        saveDic["seconds"] = NSNumber(double: seconds)
        
        //获取distance
        saveDic["distance"] = NSNumber(double: distance)
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        var saveDataArray = [Dictionary<String, AnyObject>]()
        if let getSaveDataArray = userDefault.objectForKey("saveDataArray") as? [Dictionary<String, AnyObject>] {
            saveDataArray = getSaveDataArray
            saveDataArray.append(saveDic)
            userDefault.setObject(saveDataArray, forKey: "saveDataArray")
            userDefault.synchronize()
        }else {
            saveDataArray = [saveDic]
            userDefault.setObject(saveDataArray, forKey: "saveDataArray")
            userDefault.synchronize()
        }
        
        
        //写到document
        let manager = NSFileManager.defaultManager()
        let path = NSHomeDirectory().stringByAppendingString("Documents").stringByAppendingString("saveData.txt")
        if manager.fileExistsAtPath(path) {
        
        }else {
        
        }
        
        
    }
    
    
    
}

