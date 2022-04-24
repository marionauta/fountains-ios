//
//  File.swift
//  
//
//  Created by Mario on 24/4/22.
//

import Foundation

protocol IntoDomain {
    associatedtype DomainType

    func intoDomain() -> DomainType
}
