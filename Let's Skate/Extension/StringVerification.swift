//
//  StringVerification.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 27/04/2022.
//

import Foundation

extension String {
    var isOnlyNumberAndLetter: Bool {
        return self.allSatisfy{ $0.isNumber || $0.isLetter }
    }
}
