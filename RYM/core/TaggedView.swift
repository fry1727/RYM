//
//  TaggedView.swift
//  RYM
//
//  Created by Yauheni Skiruk on 2.11.22.
//

import Foundation
import SwiftUI
// swiftlint:disable all
struct TaggedView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let availableWidth: CGFloat
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content
    @State private var elementsSize: [Data.Element: CGSize] = [:]

    var body : some View {
        VStack(alignment: alignment, spacing: spacing) {
            ForEach(computeRows(), id: \.self) { rowElements in
                HStack(spacing: spacing) {
                    ForEach(rowElements, id: \.self) { element in
                        content(element)
                            .fixedSize()
                            .readSize { size in
                                elementsSize[element] = size
                            }
                    }
                }
            }
        }
    }

    func computeRows() -> [[Data.Element]] {
        var rows: [[Data.Element]] = [[]]
        var currentRow = 0
        var remainingWidth = availableWidth

        for element in data {
            let elementSize = elementsSize[element, default: CGSize(width: availableWidth, height: 1)]

            if remainingWidth - (elementSize.width + spacing) >= 0 {
                rows[currentRow].append(element)
            } else {
                currentRow = currentRow + 1
                rows.append([element])
                remainingWidth = availableWidth
            }

            remainingWidth = remainingWidth - (elementSize.width + spacing)
        }

        return rows
    }
}

struct TaggedView_Previews: PreviewProvider {
    static var previews: some View {
        let tags = ["Open right now", "Top rated", "Visited", "Haven't visited", "More filters", "Open now 2", "Top", "No", "Haven't visited twise", "Extra filters"]
        ScrollView {
            TaggedView(availableWidth: UIScreen.main.bounds.width,
                       data: tags,
                       spacing: 10,
                       alignment: .leading
            ) { item in
                Text(verbatim: item)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.2))
                    )
            }
            .padding(10)
        }
    }
}
// swiftlint:enable all
