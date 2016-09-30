//
//  ViewController.swift
//  LocationSwift
//
//  Created by MasujimaNobuyasu on 2016/09/27.
//  Copyright © 2016年 MasujimaNobuyasu. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController {
  @IBOutlet weak var mapView: MKMapView! {
    didSet {
      self.mapView.delegate = self
    }
  }
  @IBOutlet weak var notificationLabel: UILabel!
  private let manager = CLLocationManager()
  private var monitoredRegion: CLCircularRegion?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.requestPrivasyAccess()
    self.startMonitoring()
  }
  
  private func requestPrivasyAccess() {
    self.manager.requestAlwaysAuthorization()
  }
  
  private func startMonitoring() {
    let status = CLLocationManager.authorizationStatus()
    if status == .denied || status == .restricted {
      return
    }
    self.manager.delegate = self
    let center = CLLocationCoordinate2DMake(35.674302, 139.756769)
    self.monitoredRegion = CLCircularRegion(center: center, radius: 500, identifier: "region1")
    self.manager.startMonitoring(for: self.monitoredRegion!)
  }
  
  private func stopMonitoring() {
    if let monitoredRegion = self.monitoredRegion {
      self.manager.stopMonitoring(for: monitoredRegion)
    }
  }
  
  fileprivate func addCircle(region: CLCircularRegion) {
    let circle = MKCircle(center: region.center, radius: region.radius)
    mapView.add(circle)
  }
  
  @IBAction func tapMayLocation(_ sender: AnyObject) {
    let span = MKCoordinateSpanMake(0.05, 0.05);
    let region = MKCoordinateRegionMake(mapView.userLocation.coordinate , span);
    mapView.setRegion(region, animated: true)
  }
}

extension ViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
    print("観測を開始しました！")
    self.addCircle(region: region as! CLCircularRegion)
  }
  
  func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
    print("観測の開始に失敗しました！")
  }
  
  func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
    self.notificationLabel.text = "領域に入りました！"
    self.notificationLabel.textColor = UIColor.blue
  }
  
  func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
    self.notificationLabel.text = "領域から出ました！"
    self.notificationLabel.textColor = UIColor.red

  }
}

extension ViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    let circleRenderer : MKCircleRenderer = MKCircleRenderer(overlay: overlay);
    circleRenderer.strokeColor = UIColor.red
    circleRenderer.fillColor = UIColor(red: 0.7, green: 0.0, blue: 0.0, alpha: 0.5)
    circleRenderer.lineWidth = 1.0
    return circleRenderer
  }
}
