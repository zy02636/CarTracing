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
    
    func startTrace() {
        if !CLLocationManager.locationServicesEnabled() {
            
            var alert = UIAlertController(title: "隐私定位没打开", message: nil, preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: {
                (alert: UIAlertAction!) -> Void in
                
                
            })
            /*
            //TODO 拍照问题，编辑页面优化
            let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            
            let photoAction = UIAlertAction(title: "拍照", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            var picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .Camera
            picker.modalPresentationStyle = .CurrentContext;
            self.presentViewController(picker, animated: true, completion: nil)
            
            })
            
            let albumAction = UIAlertAction(title: "相册", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            var picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .PhotoLibrary
            picker.modalPresentationStyle = .CurrentContext;
            self.presentViewController(picker, animated: true, completion: nil)
            
            })
            
            let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
            })
            
            optionMenu.addAction(photoAction)
            optionMenu.addAction(albumAction)
            optionMenu.addAction(cancelAction)
            
            self.presentViewController(optionMenu, animated: true, completion: nil)
            */
            
            
            
            
        }
        
        locationManager.startUpdatingLocation()
    }
    
    func stopTrace() {
        locationManager.stopUpdatingLocation()
    }
    
    
    
}
