//
//  MapCell.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 4..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit
import GoogleMaps

class MapCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var mapView: GMSMapView!

    //MARK: Google Maps Setting
    override func awakeFromNib() {
        super.awakeFromNib()
        increaseSeparatorHeight()
        
        let camera = GMSCameraPosition.camera(withLatitude: 37.511298, longitude: 127.073753, zoom: 17.09)
        mapView.camera = camera
        mapView.settings.scrollGestures = false
        mapView.settings.setAllGesturesEnabled(false)
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 37.511298, longitude: 127.073753)
        marker.title = "집결지"
        marker.map = mapView
    }
}
