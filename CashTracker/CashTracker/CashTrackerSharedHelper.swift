//
//  CashTrackerHelper.swift
//  CashTracker
//
//  Created by Harshal Ogale
//

import Foundation
import SwiftUI
import Combine
import CashTrackerShared

struct CenteringColumnPreferenceKey: PreferenceKey {
    typealias Value = [CenteringColumnPreference]

    static var defaultValue: [CenteringColumnPreference] = []

    static func reduce(value: inout [CenteringColumnPreference], nextValue: () -> [CenteringColumnPreference]) {
        value.append(contentsOf: nextValue())
    }
}

struct CenteringColumnPreference: Equatable {
    let width: CGFloat
}

struct CenteringView: View {
    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(Color.clear)
                .preference(
                    key: CenteringColumnPreferenceKey.self,
                    value: [CenteringColumnPreference(width: geometry.frame(in: CoordinateSpace.global).width)]
                )
        }
    }
}

class UserSettings: ObservableObject {
    let didChange = PassthroughSubject<UserSettings, Never>()
    
    @Published var currencyCode: String = CashTrackerSharedHelper.currencyCode {
        didSet {
            CashTrackerSharedHelper.currencyCode = currencyCode
            didChange.send(self)
            NotificationCenter.default.post(Notification(name: CashTrackerSharedHelper.UserSettingsChangedNotification))
        }
    }
}
