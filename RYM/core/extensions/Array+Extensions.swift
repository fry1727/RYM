//
//  Array+Extensions.swift
//  RYM
//
//  Created by Yauheni Skiruk on 3.11.22.
//

import Foundation

extension Array {
    func safeGet(_ index: Int) -> Element? {
        if count > index, index >= 0 {
            return self[index]
        }
        return nil
    }
}
