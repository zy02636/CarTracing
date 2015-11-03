//
//  TracePart.swift
//  CarTracing
//
//  Created by li pengxuan on 15/11/3.
//  Copyright © 2015年 li pengxuan. All rights reserved.
//

import UIKit

import CoreLocation
import HealthKit


class TracePart: NSObject, CLLocationManagerDelegate {
    
    //行驶时间
    var seconds = 0.0
    //行驶距离
    var distance = 0.0
    //行驶记录
    var locations = [CLLocation]()
    //timer刷新UI用
    var timer = NSTimer()
    
    var locationManager: CLLocationManager {
        let _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.activityType = .AutomotiveNavigation
        _locationManager.distanceFilter = 10.0
        return _locationManager
    }
    
    
    override init() {
        super.init()
    }
    
}
