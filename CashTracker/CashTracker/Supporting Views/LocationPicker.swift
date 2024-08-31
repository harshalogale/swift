//
//  LocationPicker.swift
//  CashTracker
//
//  Created by Harshal Ogale
//

import SwiftUI
import MapKit

struct LocationPicker: UIViewRepresentable {
    @Environment(\.dismiss) var dismiss
    @State private var loc: CLLocation? = nil
    var pin: CLLocationCoordinate2D? = nil
    let onSelect: ((CLLocationCoordinate2D, String, String) -> Void)
    
    let map = MKMapView(frame: .zero)

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        map.mapType = .standard
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        map.isRotateEnabled = true
        map.showsUserLocation = true
        map.showsCompass = true
        map.delegate = context.coordinator
        
        context.coordinator.setup()
        
        return map
    }

    func updateUIView(_ view: MKMapView, context: Context) {

        let coordinator = context.coordinator
        if let loc, loc != coordinator.lastCenterLocation {
            let coordinate = loc.coordinate
            let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            view.setRegion(region, animated: true)
        }
        coordinator.lastCenterLocation = loc
        //
        if let loc = pin, loc != coordinator.lastPinLocation {
            for a in view.annotations {
                view.removeAnnotation(a)
            }
            
            coordinator.updateAnnotationView(CLLocation(latitude: loc.latitude, longitude: loc.longitude))
            
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = loc
//            view.addAnnotation(annotation)
        }
        coordinator.lastPinLocation = pin
    }
    
    class Coordinator: NSObject {
        var parent: LocationPicker
        
        var lastCenterLocation: CLLocation? = nil
        var lastPinLocation: CLLocationCoordinate2D? = nil
        
        let locationManager = CLLocationManager()
        var myLocation: CLLocationCoordinate2D?

        init(_ parent: LocationPicker) {
            self.parent = parent
        }
        
        func setup() {
            // to get location updates only when the app is in foreground
            locationManager.requestWhenInUseAuthorization()
            
            Coordinator.shouldUpdateLocation = true
            
            Task.detached { [weak self] in
                if CLLocationManager.locationServicesEnabled() {
                    self?.locationManager.delegate = self
                    self?.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                    await self?.getMyLocation()
                }
            }
            
            addLongPressGesture()
        }
        
        func addLongPressGesture() {
            let longPressRecogniser = UILongPressGestureRecognizer(target: self,
                                                                   action:#selector(handleLongPress(_:)))
            longPressRecogniser.minimumPressDuration = 1.0
            parent.map.addGestureRecognizer(longPressRecogniser)
        }
        
        @objc func handleLongPress(_ gestureRecognizer: UIGestureRecognizer) {
            if gestureRecognizer.state != .began {
                return
            }
            
            let touchPoint: CGPoint = gestureRecognizer.location(in: parent.map)
            let touchMapCoordinate: CLLocationCoordinate2D =
                parent.map.convert(touchPoint, toCoordinateFrom: parent.map)
            
            parent.pin = touchMapCoordinate
            parent.loc = CLLocation(latitude: touchMapCoordinate.latitude, longitude: touchMapCoordinate.longitude)
            
            updateAnnotationView(parent.loc!)
        }
        
        func resetTracking() {
            parent.map.removeAnnotations(parent.map.annotations)
            
            if (parent.map.showsUserLocation) {
                parent.map.showsUserLocation = false
                //parent.map.removeAnnotations(parent.map.annotations)
                locationManager.stopUpdatingLocation()
            }
        }
        
        func centerMap(_ center: CLLocationCoordinate2D) {
            saveCurrentLocation(center)
            print("centerMap")
            
            // get current region
//            var region = parent.map.region
//            // Update the center
//            region.center = CLLocationCoordinate2DMake(center.latitude, center.longitude);
//            // apply the new region
//            parent.map.region = region;
            
            parent.map.region.center = center
        }
        
        func saveCurrentLocation(_ center: CLLocationCoordinate2D) {
            myLocation = center
        }
        
        func updateAnnotationView(_ location: CLLocation) {
            getPinAddress(location) { [weak self] (name, address) in
                let annot = MKPointAnnotation(__coordinate: location.coordinate, title: name, subtitle: address)
                self?.resetTracking()
                self?.parent.map.addAnnotation(annot)
                self?.centerMap(location.coordinate)
            }
        }
        
        static var shouldUpdateLocation: Bool = true
        func getMyLocation() async {
            if CLLocationManager.locationServicesEnabled() {
                if Coordinator.shouldUpdateLocation {
                    locationManager.startUpdatingLocation()
                } else {
                    locationManager.stopUpdatingHeading()
                }
                Coordinator.shouldUpdateLocation.toggle()
            }
        }
        
        func getPinAddress(_ location: CLLocation, completionHandler: @escaping (String, String) -> Void) {
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                
                var name: String = ""
                var address: String = ""
                
                if placemarks?.isEmpty == false {
                    var lastpart = ""
                    
                    let placemark = placemarks![0]
                    if let pn = placemark.name {
                        name = pn
                        lastpart = name
                    }
                    
                    if let nn = placemark.name, let n1 = placemark.subThoroughfare, let n2 = placemark.thoroughfare {
                        var sep = ","
                        if nn == (n1 + ", " + n2) {
                            name = ""
                        } else if nn == (n1 + " " + n2) {
                            name = ""
                            sep = " "
                        }
                        address += (n1 + sep + n2)
                    } else {
                        if let loc = placemark.subThoroughfare {
                            if let nn = placemark.name, loc == nn {
                                name = ""
                            }
                            address += (address.isEmpty ? "": ", ") + loc
                            lastpart = loc
                        }
                        
                        if let loc = placemark.thoroughfare {
                            if let nn = placemark.name, loc == nn {
                                name = ""
                            }
                            address += (address.isEmpty ? "": ", ") + loc
                            lastpart = loc
                        }
                    }
                    
                    if lastpart != placemark.subLocality {
                        if let loc = placemark.subLocality {
                            address += (address.isEmpty ? "": ", ") + loc
                            lastpart = loc
                        }
                    }
                    
                    if lastpart != placemark.locality {
                        if placemark.subLocality != placemark.locality {
                            if let loc = placemark.locality {
                                address += (address.isEmpty ? "": ", ") + loc
                                lastpart = loc
                            }
                        }
                    }
                    
                    if lastpart != placemark.subAdministrativeArea {
                        if let loc = placemark.subAdministrativeArea {
                            address += (address.isEmpty ? "": ", ") + loc
                            lastpart = loc
                        }
                    }
                    
                    if placemark.subAdministrativeArea != placemark.administrativeArea {
                        if let loc = placemark.administrativeArea {
                            address += (address.isEmpty ? "": ", ") + loc
                            lastpart = loc
                        }
                    }
                    
                    if let loc = placemark.country {
                        address += (address.isEmpty ? "": ", ") + loc
                    }
                    
                    if let loc = placemark.postalCode {
                        address += (address.isEmpty ? "": ", ") + loc
                    }
                    
                    print("name: " + name)
                    print("address: " + address)
                    
                    completionHandler(name.isEmpty ? " ": name, address)
                }
            }
        }
    }
}

extension LocationPicker.Coordinator: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        parent.loc = manager.location!
        parent.pin = locValue
        updateAnnotationView(parent.loc!)
    }
}

extension LocationPicker.Coordinator: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pin"
        var view: MKMarkerAnnotationView
        
        if let dequeueView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeueView.annotation = annotation
            view = dequeueView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            
            let leftBtn = UIButton(type: .detailDisclosure)
            leftBtn.setImage(UIImage(systemName: "paperclip.circle"), for: UIControl.State.normal)
            leftBtn.setImage(UIImage(systemName: "paperclip.circle.fill"), for: UIControl.State.highlighted)
            view.leftCalloutAccessoryView = leftBtn
            
            view.rightCalloutAccessoryView = UIButton(type: .close)
            view.image = UIImage.init(systemName: "mappin.and.ellipse")
        }
        view.animatesWhenAdded = true
        view.isDraggable = true
        
        return view
    }
    
    func mapView(_ mapView: MKMapView,
                 annotationView view: MKAnnotationView,
                 didChange newState: MKAnnotationView.DragState,
                 fromOldState oldState: MKAnnotationView.DragState) {
        if newState == MKAnnotationView.DragState.ending {
            parent.pin = view.annotation!.coordinate
            parent.loc = CLLocation(latitude: view.annotation!.coordinate.latitude, longitude: view.annotation!.coordinate.longitude)
            
            updateAnnotationView(parent.loc!)
        }
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        mapView.selectAnnotation(mapView.annotations[0], animated: true)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if view.rightCalloutAccessoryView == control {
            print("remove annotation - close button tapped")
            parent.map.removeAnnotations(parent.map.annotations)
            lastPinLocation = nil
            parent.pin = nil
            parent.loc = nil
            resetTracking()
        } else {
            var name = ""
            var addr = ""
            if let temp = view.annotation!.title, let value = temp {
                name = value
            }
            if let temp = view.annotation!.subtitle, let value = temp {
                addr = value
            }
            
            parent.onSelect(parent.pin!, name, addr)
            parent.dismiss()
        }
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude
            && lhs.longitude == rhs.longitude
    }
}
