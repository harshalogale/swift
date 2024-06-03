//
//  QuakeMapViewController.swift
//  SampleQuake
//
//  Created by Harshal Ogale on 2/26/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import MapKit

/// View Controller to display earthquake locations on a map view.
final class QuakeMapViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!
    
    var annotations = [QuakeMKPointAnnotation]()
    
    static let DEFAULT_MAP_SPAN = MKCoordinateSpan(latitudeDelta: 180.0, longitudeDelta: 360.0)
    
    // variable to hold the list of earthquakes to be displayed on the map view
    var quakes: [Quake]? {
        didSet {
            if let quakes = quakes {
                // remove existing annotations
                annotations.removeAll()
                
                for quake in quakes {
                    if let lat = quake.latitude, let lon = quake.longitude {
                        var strDate: String
                        if let dt = quake.datetime {
                            strDate = "\(QuakeListViewController.dateFormatter.string(from: Date.init(timeIntervalSince1970: dt))) UTC"
                        } else {
                            strDate = ""
                        }
                        
                        let strLatLon = String.localizedStringWithFormat("%g, %g", lat, lon)
                        
                        let qId = quake.identifier ?? ""
                        
                        // create one annotation pin for each earthquake location
                        let qa = QuakeMKPointAnnotation()
                        qa.magnitude = quake.magnitude
                        qa.coordinate = CLLocationCoordinate2DMake(lat, lon)
                        qa.title = quake.title
                        qa.subtitle = "\(qId), \(strDate), \(strLatLon)"
                        
                        annotations.append(qa)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        mapView.showAnnotations(annotations, animated: false)
        mapView.setRegion(MKCoordinateRegion.init(center: mapView.centerCoordinate, span: QuakeMapViewController.DEFAULT_MAP_SPAN), animated: true)
        
        if annotations.count > 0 {
            mapView.selectAnnotation(annotations[0], animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

/// Extension to handle map view delegate methods
extension QuakeMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "quakePin")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "quakePin")
            annotationView?.isEnabled = true
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation;
        }
        
        let qa = annotation as! QuakeMKPointAnnotation
        
        annotationView?.image = mapPinImageForQuakeMagnitude(qa.magnitude)
        
        return annotationView;
    }
    
    func mapPinImageForQuakeMagnitude(_ magnitude:Double?) -> UIImage {
        
        var image = #imageLiteral(resourceName: "map_pin_0")
        
        if let mag = magnitude {
            switch mag {
            case let x where x < 2:
                image = #imageLiteral(resourceName: "map_pin_1")
            case let x where x < 3:
                image = #imageLiteral(resourceName: "map_pin_2")
            case let x where x < 5:
                image = #imageLiteral(resourceName: "map_pin_3")
            case let x where x < 6:
                image = #imageLiteral(resourceName: "map_pin_4")
            default:
                image = #imageLiteral(resourceName: "map_pin_5")
            }
        }
        
        return image
    }
}
