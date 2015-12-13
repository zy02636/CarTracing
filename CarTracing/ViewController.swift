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


class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

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
    
    //应用首次启动, 为了防止触发mapview的回调, tracing先设置成true
    //用户开始点击按钮后, tracing与用户是否trace状态一致
    var tracing = true;

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Custom UI
        let historyBtn : UIBarButtonItem = UIBarButtonItem(title: "History", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("historyBtnClick"))
        self.navigationItem.leftBarButtonItem = historyBtn
        startBtn.layer.cornerRadius = 5
        
        //Map
        mapView.delegate = self
        
        
        //LocationManager
        locationManager = CLLocationManager()
        locationManager.allowsBackgroundLocationUpdates = true
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

    
    //Mark : - Overlay
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = UIColor.blueColor()
        renderer.lineWidth = 5
        return renderer

    }
    

    //MARK : - Private Funcs
    
    
    //take screenshot
    func imageFromView(view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return snapshot;
    }
    
    //Add Region
    func addRegion() {
        //模拟器首次启动写了保护, 一直崩溃受不了了...
        //start trace的时候会再触发这个函数...
        if (locationManager.location == nil) {
            return;
        }
        //Map Region
        mapView.showsUserLocation = true
        let theSpan = MKCoordinateSpanMake(0.05, 0.05)
        let theRegion = MKCoordinateRegionMake((locationManager.location?.coordinate)!, theSpan)
        mapView.setRegion(theRegion, animated: true)
    }
    
    
    //Go to History page
    func historyBtnClick() {

        let historyTableViewController = HistoryTableViewController()
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
            
            locations.removeAll();
            addRegion();
            tracing = true;
        }else {
            timer.invalidate()
            timeLabel.text = "Time: "
            distanceLabel.text = "Distance: "
            stopLocationUpdates()
            startBtn.setTitle("Start", forState: .Normal)
            
            if (locations.count >= 1) {
                let firstLoc = locations.first!;
                let lastLoc  = locations.last!;
                let minLatitude  = firstLoc["latitude"];
                let minLongitude = firstLoc["longitude"];
                
                let maxLatitude  = lastLoc["latitude"];
                let maxLongitude = lastLoc["longitude"];

                let span       = MKCoordinateSpanMake(abs(maxLatitude! - minLatitude!) * 1.1, abs(maxLongitude! - minLongitude!) * 1.1);
                let coordinate = CLLocationCoordinate2DMake((maxLatitude! + minLatitude!) / 2, (maxLongitude! + minLongitude!) / 2);
                let region = MKCoordinateRegionMake(coordinate, span);
                mapView.setRegion(region, animated: true);
                tracing = false;
            }
        }

    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if (!tracing){
            saveRun()
        }
    }
    
    
    func startLocationUpdates() {
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }
    
    
    
    //画线路可视Region
    func mapRegion() -> MKCoordinateRegion {
        
        let firstLocationDic = self.locations.first

        var minLat = firstLocationDic!["latitude"]
        var minLng = firstLocationDic!["longitude"]
        var maxLat = minLat
        var maxLng = minLng
        for location in locations {
            minLat = min(minLat!, location["latitude"]!)
            minLng = min(minLng!, location["longitude"]!)
            maxLat = max(maxLat!, location["latitude"]!)
            maxLng = max(maxLng!, location["longitude"]!)
            
            
        }
        
        return MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: (minLat! + maxLat!)/2,
                longitude: (minLng! + maxLng!)/2),
            span: MKCoordinateSpan(latitudeDelta: (maxLat! - minLat!)*1.1,
                longitudeDelta: (maxLng! - minLng!)*1.1))
    }
    
    
    //Refresh UI perSecond
    func eachSecond(timer: NSTimer) {
        mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude:locations[locations.count - 1]["latitude"]!,
            longitude:locations[locations.count - 1]["longitude"]!), animated: true);
        
        seconds++
        let secondsQuantity = HKQuantity(unit: HKUnit.secondUnit(), doubleValue: seconds)
        timeLabel.text = "Time: " + secondsQuantity.description
        let distanceQuantity = HKQuantity(unit: HKUnit.meterUnit(), doubleValue: distance)
        distanceLabel.text = "Distance: " + distanceQuantity.description

        loadMap()
        
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
        
        //图片存储并保存路径
        let imgData = UIImagePNGRepresentation(imageFromView(mapView))
        let documentsPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
        
        let dat = NSDate(timeIntervalSinceNow: 0)
        let timerInterval = dat.timeIntervalSince1970

        let fileName = "/screenshot_\(timerInterval).png"
        let filePath = documentsPath.stringByAppendingString(fileName)
        imgData?.writeToFile(filePath, atomically: true)
        saveDic["image"] = filePath
        
        
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
        
        
//        //写到document
//        let manager = NSFileManager.defaultManager()
//        let path = NSHomeDirectory().stringByAppendingString("Documents").stringByAppendingString("saveData.txt")
//        if manager.fileExistsAtPath(path) {
//        
//        }else {
//        
//        }
        
        
    }
    
    
    
    func polyline() -> MKPolyline {
        var coords = [CLLocationCoordinate2D]()

        for location in locations {
            coords.append(CLLocationCoordinate2D(latitude: location["latitude"]!,
                longitude: location["longitude"]!))
        }
        
        return MKPolyline(coordinates: &coords, count: locations.count)
    }
    
    
    func loadMap() {
        if locations.count > 0 {
            mapView.removeOverlays(mapView.overlays)
            
            // Set the map bounds
//            mapView.region = mapRegion()
            
            // Make the line(s!) on the map
            mapView.addOverlay(polyline())
        }
    }
    
}

