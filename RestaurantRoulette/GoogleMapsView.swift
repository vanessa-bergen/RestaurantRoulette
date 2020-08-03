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
    //@ObservedObject var googleData = GoogleData()
    @EnvironmentObject var googleData: GoogleData
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var mapMoved = false
 
    // a zoom level of 15 shows streets
    private let zoom: Float = 15.0
    
    // marker that will be in the center of the map
    let marker : GMSMarker = GMSMarker()
    
    func makeUIView(context: Self.Context) -> GMSMapView {
        print(self.mapMoved)
        // set the map to the user's current location
        let camera = GMSCameraPosition.camera(withLatitude: locationManager.latitude, longitude: locationManager.longitude, zoom: zoom)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        mapView.delegate = context.coordinator

        // enables the blue marker that shows the current location of the user
        mapView.isMyLocationEnabled = true
        // enables the location marker to be a button so that when pressed the marker will be in the center of the map
        mapView.settings.myLocationButton = true
        
        // setting the marker to the center of the map
        //marker.position = CLLocationCoordinate2D(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
        marker.position = CLLocationCoordinate2D(latitude: locationManager.latitude, longitude: locationManager.longitude)
        marker.isDraggable = true
        marker.appearAnimation = .pop
        marker.icon = GMSMarker.markerImage(with: UIColor.blue)
        print(marker.icon?.size ?? "no size")
        //marker.setIconSize(scaledToSize: .init(width: 40, height: 40))
        marker.setIconScale(originalSize: marker.icon?.size ?? .init(width: 26, height: 41), scaledBy: 2)
        marker.map = mapView
        
        
        
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        //print("Map moved \(self.mapMoved)")
        // if the user hasn't moved the map yet, defualt it's location to the user's location
//        if !self.mapMoved {
//            mapView.animate(toLocation: CLLocationCoordinate2D(latitude: locationManager.latitude, longitude: locationManager.longitude))
//        } else {
//            mapView.animate(toLocation: CLLocationCoordinate2D(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude))
//        }
        if !self.mapMoved {
            mapView.animate(toLocation: CLLocationCoordinate2D(latitude: locationManager.latitude, longitude: locationManager.longitude))
            marker.position = CLLocationCoordinate2D(latitude: locationManager.latitude, longitude: locationManager.longitude)
        }
        //else {
//            mapView.animate(toLocation: CLLocationCoordinate2D(latitude: marker.position.latitude, longitude: marker.position.longitude))
//        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: GoogleMapsView
        
        init(_ parent: GoogleMapsView) {
            self.parent = parent
        }
        
//        func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
//            // user has moved the map
//            parent.mapMoved = true
//        }
//
        func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
            // moving the center marker as the map moves
//            parent.marker.position = CLLocationCoordinate2D(latitude: position.target.latitude, longitude: position.target.longitude)
            print("did change")
            if !self.parent.mapMoved {
                self.parent.marker.position = CLLocationCoordinate2D(latitude: self.parent.locationManager.latitude, longitude: self.parent.locationManager.longitude)
            }
            
        }
//        
//        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
//            // updating the centerCoordinate to be in the center of the map when the map stops moving
//            parent.centerCoordinate = CLLocationCoordinate2D(latitude: position.target.latitude, longitude: position.target.longitude)
//            parent.marker.position = CLLocationCoordinate2D(latitude: position.target.latitude, longitude: position.target.longitude)
//
//        }
        
        func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
            print("dragging")
        }
        func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
            print("began dragging")
            self.parent.mapMoved = true
        }
        func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
            print(marker.position)
            mapView.animate(toLocation: CLLocationCoordinate2D(latitude: marker.position.latitude, longitude: marker.position.longitude))
            
            
        }
        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
            self.parent.googleData.loadData(near: position.target)
            print(self.parent.googleData.results)
        }
    }
}


extension GMSMarker {
    func setIconSize(scaledToSize newSize: CGSize) {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        icon?.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        icon = newImage
    }
    
    func setIconScale(originalSize: CGSize, scaledBy scale: CGFloat) {
        let newSize = CGSize(width: originalSize.width * scale, height: originalSize.height * scale)
            //originalSize.width * 2 * originalSize.height
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        icon?.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        icon = newImage
    }
}
