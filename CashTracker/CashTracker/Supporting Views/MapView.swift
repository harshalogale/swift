/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view that hosts an `MKMapView`.
*/

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subTitle: String?
    
    let map = MKMapView(frame: .zero)
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        map.delegate = context.coordinator
        
        return map
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: true)
        
        view.removeAnnotations(view.annotations)
        
        let annot = MKPointAnnotation(__coordinate: coordinate, title: title, subtitle: subTitle)
        view.addAnnotation(annot)
    }
}

#Preview {
    MapView(coordinate: CLLocationCoordinate2D(latitude: 21.13, longitude: 79.05))
}


class Coordinator: NSObject, MKMapViewDelegate {
    var parent: MapView
    
    init(_ parent: MapView) {
        self.parent = parent
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pin1"
        var view: MKMarkerAnnotationView
        
        if let dequeueView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeueView.annotation = annotation
            view = dequeueView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.showsLargeContentViewer = true
            
            // set dummy view as accessory view just to ensure that the callout box shows up
            view.rightCalloutAccessoryView = UIView(frame: .zero)
        }
        view.animatesWhenAdded = true
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        mapView.selectAnnotation(mapView.annotations[0], animated: true)
    }
}
