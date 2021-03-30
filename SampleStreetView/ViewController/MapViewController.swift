//
//  MapViewController.swift
//  SampleStreetView
//
//  Created by 肥沼英里 on 2021/03/30.
//

import UIKit
import GoogleMaps

protocol MapViewControllerDelegate: class{
    func didTapMarker(of location: CLLocationCoordinate2D)
}

final class MapViewController: UIViewController {
    
    weak var delegate: MapViewControllerDelegate?
    private let mapView = GMSMapView(frame: .zero)
    //現在表示されているマーカーを格納する変数
    private var presentingMarker = GMSMarker()
    
    override func loadView() {
        self.view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    private func setUpView(){
        let tokyoStation = CLLocationCoordinate2D(latitude: 35.6809591, longitude: 139.7673068)
        let marker = GMSMarker(position: tokyoStation)
        marker.map = mapView
        let tokyoCamera = GMSCameraPosition(latitude: 35.6809591, longitude: 139.7673068, zoom: 15.0)
        mapView.camera = tokyoCamera
        mapView.delegate = self
        
        guard let streetVC = self.parent as? StreetViewController else {return}
        streetVC.delegate = self
    }
    
    private func makeMarker(position: CLLocationCoordinate2D, heading: CLLocationDegrees?){
        mapView.clear()
        let marker = GMSMarker(position: position)
        marker.icon = UIImage(named: "marker")?.resize(size: CGSize(width: 35, height: 35))
        marker.map = mapView
        presentingMarker = marker
    }
}

extension MapViewController: GMSMapViewDelegate{
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        makeMarker(position: coordinate, heading: nil)
        mapView.animate(toLocation: coordinate)
        delegate?.didTapMarker(of: coordinate)
    }
    
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location: CLLocationCoordinate2D) {
        makeMarker(position: location, heading: nil)
        mapView.animate(toLocation: location)
        delegate?.didTapMarker(of: location)
    }
}

extension MapViewController: StreetViewControllerDelegate{
    
    func didMove(to location: CLLocationCoordinate2D, heading: CLLocationDegrees) {
        makeMarker(position: location, heading: nil)
        presentingMarker.rotation = heading
        mapView.animate(toLocation: location)
    }
    
    func didMoveCamera(to heading: CLLocationDegrees) {
        //現在表示されているマーカーを取得して回転させる
        presentingMarker.rotation = heading
    }
}
