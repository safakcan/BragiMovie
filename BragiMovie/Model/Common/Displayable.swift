//
//  Displayable.swift
//  BragiMovie
//
//  Created by Can Bas on 5.09.2023.
//

import Foundation

protocol DetailDisplayable {
    var name: String { get }
    var description: String { get }
    var imageUrlString: String? { get }
    var releaseDate: String { get }
    var rating: String { get }
    // ... other common properties will be added
}
