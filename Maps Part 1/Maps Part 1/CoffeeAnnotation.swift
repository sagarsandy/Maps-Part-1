//
//  CoffeeAnnotation.swift
//  Maps Part 1
//
//  Created by Sagar Sandy on 23/11/18.
//  Copyright © 2018 Sagar Sandy. All rights reserved.
//

import Foundation
import MapKit

class CoffeeAnnotation: MKPointAnnotation {

    // We have created this class to add image to the annotation, because we've subclassed this from MKPointAnnotation, all the properties are assigned defaultly to this class. So we just added image.
    var imageURL : String!
}
