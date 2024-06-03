//
//  QuakeMapViewControllerTests.swift
//  SampleQuake
//
//  Created by Harshal Ogale on 3/4/17.
//  Copyright © 2017. All rights reserved.
//

import XCTest
import MapKit
@testable import SampleQuake

final class QuakeMapViewControllerTests: XCTestCase {
    var mapVC: QuakeMapViewController!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        mapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mapVC") as? QuakeMapViewController

        // force loading subviews and setting outlets
        let _ = mapVC.view
        mapVC.viewDidLoad()
    }

    func testMapViewDelegate() {
        XCTAssertTrue(mapVC.isKind(of: UIViewController.self))
        XCTAssertTrue(mapVC.conforms(to: MKMapViewDelegate.self))
    }

    func testAnnotationCreationThroughQuakeSetter() {
        var quake = Quake()
        quake.code = "15442458";
        quake.datetime = 1488746079.539;
        quake.depth = 41.9;
        quake.identifier = "ak15442458";
        quake.latitude = 62.1421;
        quake.longitude = -150.059;
        quake.magnitude = 2.1;
        quake.magnitudeType = "ml";
        quake.place = "11km W of Y = Alaska";
        quake.status = "automatic";
        quake.title = "M 2.1 - 11km W of Y = Alaska";
        quake.type = "earthquake";

        mapVC.quakes = [quake]

        mapVC.viewWillAppear(false)

        XCTAssertEqual(mapVC.mapView.annotations.count, 1)
        XCTAssertTrue(mapVC.mapView.annotations[0].isKind(of: QuakeMKPointAnnotation.self))
        XCTAssertEqual(mapVC.mapView.annotations[0].title!!, "M 2.1 - 11km W of Y = Alaska")
        XCTAssertEqual(mapVC.mapView.annotations[0].subtitle!!, "ak15442458, 3/5/17, 20:34:39 UTC, 62.1421, -150.059")
        XCTAssertEqual(mapVC.mapView.annotations[0].coordinate.latitude, 62.1421)
        XCTAssertEqual(mapVC.mapView.annotations[0].coordinate.longitude, -150.059)
    }

}
