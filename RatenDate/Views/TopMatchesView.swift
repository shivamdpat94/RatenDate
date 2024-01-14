//
//  TopMatchesView.swift
//  RatenDate
//
//  Created by Mitchell Buff on 1/13/24.
//

import SwiftUI

struct TopMatchesView: View {
    // This would be your source of truth for matches data
    var matches: [Match]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(matches) { match in
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                        // Placeholder for where you'd put a view or image representing the match
                }
            }
            .padding()
        }
    }
}
