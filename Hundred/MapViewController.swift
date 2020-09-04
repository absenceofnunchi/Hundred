//
//  MapViewController.swift
//  Hundred
//
//  Created by jc on 2020-09-03.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    var selectedPin: MKPlacemark? = nil
    var resultSearchController: UISearchController? = nil
    let locationManager = CLLocationManager()
    var fetchPlacemarkDelegate: NewViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        mapView.register(MyAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        configureUI()
        checkLocationServices()
        configureLocationSearch()
        
//        let initialLocation = CLLocation(latitude: 43.6532, longitude: -79.3832)

    }
    
//    func setupLocationManager() {
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//    }
    
    func configureUI() {
//        let _annotation = MyAnnotation(title: "My Location", locationName: "The 6ix", discipline: "6ix", coordinate: CLLocationCoordinate2D(latitude: 43.6532, longitude: -79.3832))
//        mapView.addAnnotation(_annotation)
    }
    
    func configureLocationSearch() {
        // Set up the search results table
        let locationSearchTable = storyboard!.instantiateViewController(identifier: "LocationSearch") as! LocationSearchViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable as UISearchResultsUpdating
        
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.obscuresBackgroundDuringPresentation = true
        definesPresentationContext = true
    }
    
    // MARK:- Location permission
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization()
        } else {
            showAlert()
        }
    }
    
    func showAlert() {
        let ac = UIAlertController(title: "Your location settings need to be turned on", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            if let bundleId = Bundle.main.bundleIdentifier,
               let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let popoverController = ac.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(ac, animated: true)
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            centerMapOnLocation()
        case .denied:
            showAlert()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            showAlert()
        case .authorizedAlways:
            break
        default:
            break
        }
    }
    
    let regionRadius: CLLocationDistance = 10000
    func centerMapOnLocation() {
        if let location = locationManager.location?.coordinate {
            selectedPin = MKPlacemark(coordinate: location)
            let coorindateRegion = MKCoordinateRegion.init(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            mapView.setRegion(coorindateRegion, animated: true)
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        guard let annotation = annotation as? MyAnnotation else { return nil }
        let identifier = "marker"
        var annotationView: MKMarkerAnnotationView
        if let deqeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            deqeuedView.annotation = annotation
            annotationView = deqeuedView
        } else {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.isEnabled = true
            annotationView.canShowCallout = true
            annotationView.calloutOffset = CGPoint(x: -5, y: 5)
            
            let mapButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30)))
            mapButton.setBackgroundImage(UIImage(systemName: "book"), for: UIControl.State())
            mapButton.addTarget(self, action: #selector(mapButtonPressed), for: .touchUpInside)
            annotationView.rightCalloutAccessoryView = mapButton
        }

        return annotationView
    }

    @objc func mapButtonPressed() {
        if let selectedPin = selectedPin {
            fetchPlacemarkDelegate?.fetchPlacemark(placemark: selectedPin)
            _ = navigationController?.popViewController(animated: true)
        }
    }
}

protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark)
}

extension MapViewController: HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark) {
        // cache the pin
        selectedPin = placemark
        
        // clear the existing pins
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(placemark)
        
        print(placemark.coordinate.latitude is Double)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
    }
}
