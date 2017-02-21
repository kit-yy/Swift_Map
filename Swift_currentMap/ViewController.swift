//
//  ViewController.swift
//  Swift_currentMap
//
//  Created by Yasuaki K on 2017/02/21.
//  Copyright © 2017年 Yasuaki Kitaoka. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
  
    
    var myLocationManeger:CLLocationManager!
    
    var latitude:Double = Double()
    var longitude:Double = Double()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imAt()
        
    }

    
    func imAt(){
        myLocationManeger = CLLocationManager()
       
        myLocationManeger.delegate = self
        mapView.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        
        if(status == CLAuthorizationStatus.notDetermined){
            
            self.myLocationManeger.requestAlwaysAuthorization()
            
            self.myLocationManeger.requestWhenInUseAuthorization()
        }
        
        myLocationManeger.desiredAccuracy = kCLLocationAccuracyBest
        
        myLocationManeger.startUpdatingLocation()
        
        latitude = (myLocationManeger.location?.coordinate.latitude)!
        longitude = (myLocationManeger.location?.coordinate.longitude)!
        
        
        let cordinate = CLLocationCoordinate2DMake(latitude, longitude)
        
        let span = MKCoordinateSpanMake(0.003, 0.003)
        
        let region = MKCoordinateRegionMake(cordinate, span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = cordinate
        annotation.title = "ここから"
        annotation.subtitle = "現在地です。"
        
        self.mapView.addAnnotation(annotation)
        
    }
    
    // Called when the annotation was added
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.animatesDrop = true
            pinView?.canShowCallout = true
            pinView?.isDraggable = true
            pinView?.pinTintColor = .purple
            
            let rightButton: AnyObject! = UIButton(type: UIButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = rightButton as? UIView
        }
        else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    //ボタン押下時の呼び出しメソッド
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        //マップアプリに渡す目的地の位置情報を作る。
        let coordinate = CLLocationCoordinate2DMake(view.annotation!.coordinate.latitude, view.annotation!.coordinate.longitude)
        let placemark = MKPlacemark(coordinate:coordinate, addressDictionary:nil)
        let mapItem = MKMapItem(placemark: placemark)
        
        //起動オプション
        let option:[String:AnyObject] = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving as AnyObject, //車で移動
            MKLaunchOptionsMapTypeKey : MKMapType.hybrid.rawValue as AnyObject]  //地図表示はハイブリッド
        
        //マップアプリを起動する。
        mapItem.openInMaps(launchOptions: option)
        
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

