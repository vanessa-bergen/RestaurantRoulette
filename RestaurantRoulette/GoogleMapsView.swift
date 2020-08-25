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
//    @Binding var centerCoordinate: CLLocationCoordinate2D
    @State private var mapMoved = false
    
    @State private var initialLoad = true
    
//    @Binding var radius: Double
//    @Binding var openNow: Bool
//    @Binding var price: Int
 
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
            //self.googleData.centerCoordinate = CLLocationCoordinate2D(latitude: locationManager.latitude, longitude: locationManager.longitude)
            
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
        
        func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
            // user has moved the map
            if gesture {
                self.parent.mapMoved = true
            }
        }
         
        func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
            self.parent.mapMoved = true
        }
        
        func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
            print("dragged")
            print(marker.position)
            mapView.animate(toLocation: CLLocationCoordinate2D(latitude: marker.position.latitude, longitude: marker.position.longitude))
            self.parent.googleData.centerCoordinate = marker.position
//            self.parent.googleData.loadData(
//                near: marker.position,
//                radius: self.parent.radius,
//                openNow: self.parent.openNow
//            )
 
        }
        
        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
            print("idle position \(position)")
            
            if self.parent.initialLoad {
                print("setting center coordinate")
                self.parent.googleData.centerCoordinate = CLLocationCoordinate2D(latitude: self.parent.locationManager.latitude, longitude: self.parent.locationManager.longitude)
                self.parent.initialLoad = false
            }
        }
        
        func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
            print("tapped")
            self.parent.mapMoved = true
            self.parent.marker.position = coordinate
            mapView.animate(toLocation: coordinate)
            
            self.parent.googleData.centerCoordinate = coordinate
//            self.parent.googleData.loadData(
//                near: coordinate,
//                radius: self.parent.radius,
//                openNow: self.parent.openNow
//            )
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


