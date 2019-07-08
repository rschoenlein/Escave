//
//  HuntStartedViewController.swift
//  Escave
//
//  Created by Ryan Schoenlein on 6/5/19.
//  Copyright © 2019 Ryan Schoenlein. All rights reserved.
//

import UIKit
import MapKit

class HuntStartedViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //show user location
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        
        //TODO go to city of current item (found in EscaveViewController)

    }
    
    //This variable will hold a starting value of seconds. It could be any amount above 0.
    var seconds = 60
    
    var timer = Timer()
    //This will be used to make sure only one timer is created at a time.
    var isTimerRunning = false
    
    //MARK: - Properties
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    fileprivate let locationManager:CLLocationManager = CLLocationManager();
    
    //MARK: - Actions
   
   
    
    //start scavenger hunt timer
    @IBAction func startTapped(_ sender: UIButton) {
        runTimer();
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Private methods
    
    
    //create timer
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(HuntStartedViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    //uses objective c
    @objc private func updateTimer() {
        //This will decrement(count down)the seconds.
        seconds -= 1
        //This will update the label.
        timerLabel.text = "\(seconds)"
      
    }
    

}
