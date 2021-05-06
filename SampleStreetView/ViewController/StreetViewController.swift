//
//  ViewController.swift
//  SampleStreetView
//
//  Created by 肥沼英里 on 2021/03/30.
//

import UIKit
import GoogleMaps

protocol StreetViewControllerDelegate: AnyObject{
    func didMove(to location: CLLocationCoordinate2D, heading: CLLocationDegrees)
    func didMoveCamera(to heading: CLLocationDegrees)
}

final class StreetViewController: UIViewController {
    
    @IBOutlet private weak var panoView: GMSPanoramaView!
    weak var delegate: StreetViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPanoView()
    }
    
    private func setUpPanoView(){
        let tokyoStation = CLLocationCoordinate2D(latitude: 35.6809591, longitude: 139.7673068)
        panoView.moveNearCoordinate(tokyoStation)
        panoView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let mapVC = segue.destination as? MapViewController else {return}
        self.addChild(mapVC)
        mapVC.delegate = self
    }
}
extension StreetViewController: GMSPanoramaViewDelegate{
    
    func panoramaView(_ view: GMSPanoramaView, didMoveTo panorama: GMSPanorama?) {
        guard let panorama = panorama else {return}
        let heading = view.camera.orientation.heading
        delegate?.didMove(to: panorama.coordinate, heading: heading)
    }
    
    func panoramaView(_ panoramaView: GMSPanoramaView, didMove camera: GMSPanoramaCamera) {
        let heading = camera.orientation.heading
        delegate?.didMoveCamera(to: heading)
    }
}

extension StreetViewController: MapViewControllerDelegate{
    
    func didTapMarker(of location: CLLocationCoordinate2D) {
        panoView.moveNearCoordinate(location)
    }
}
