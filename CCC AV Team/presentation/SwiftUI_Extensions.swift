//
//  SwiftUI_Extensions.swift
//  CCC AV Team
//
//  Created by Asher Pope on 8/22/24.
//

import SwiftUI

extension View {
    func cornerRadius(_ radius: Double) -> some View {
        clipShape(.rect(cornerRadius: radius))
    }
}
