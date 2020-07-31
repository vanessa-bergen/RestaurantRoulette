//
//  GoogleMapsView.swift
//  RestaurantRoulette
//
//  Created by Vanessa Bergen on 2020-07-31.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import GoogleMaps
import SwiftUI

struct GoogleMapsView: UIViewRepresentable {
    
    @EnvironmentObject var locationManager: LocationManager
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var mapMoved = false
 
    // a zoom level of 15 shows streets
    private let zoom: Float = 15.0
    
    // marker that will be in the center of the map
    let marker : GMSMarker = GMSMarker()
    
    func makeUIView(context: Self.Context) -> GMSMapView {
       
        // set the map to the user's current location
        let camera = GMSCameraPosition.camera(withLatitude: locationManager.latitude, longitude: locationManager.longitude, zoom: zoom)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        mapView.delegate = context.coordinator

        // enables the blue marker that shows the current location of the user
        mapView.isMyLocationEnabled = true
        // enables the location marker to be a button so that when pressed the marker will be in the center of the map
        mapView.settings.myLocationButton = true
        
        // setting the marker to the center of the map
        marker.position = CLLocationCoordinate2D(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
        marker.title = "test"
        marker.map = mapView
        
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        
        // if the user hasn't moved the map yet, defualt it's location to the user's location
        if !self.mapMoved {
            mapView.animate(toLocation: CLLocationCoordinate2D(latitude: locationManager.latitude, longitude: locationManager.longitude))
        } else {
            mapView.animate(toLocation: CLLocationCoordinate2D(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude))
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: GoogleMapsView
        
        init(_ parent: GoogleMapsView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
            // user has moved the map
            parent.mapMoved = true
        }

        func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
            // moving the center marker as the map moves
            parent.marker.position = CLLocationCoordinate2D(latitude: position.target.latitude, longitude: position.target.longitude)
        }
        
        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
            // updating the centerCoordinate to be in the center of the map when the map stops moving
            parent.centerCoordinate = CLLocationCoordinate2D(latitude: position.target.latitude, longitude: position.target.longitude)

        }
    }
}
