//
//  String+localize.swift
//  Tracker
//
//  Created by Ilia Liasin on 24/02/2025.
//

import Foundation

extension String {
    
    var localized: String {
        NSLocalizedString(self, comment: "NSLocalizedString")
    }
}
