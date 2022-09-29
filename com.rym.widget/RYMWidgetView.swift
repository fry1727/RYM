//
//  RYMWidgetView.swift
//  RYM
//
//  Created by Yauheni Skiruk on 29.09.22.
//

import SwiftUI

struct RYMWidgetView: View {
    let remainders: [MedicineRemainder]
    var body: some View {
        ZStack {
            Color.black
            ForEach(remainders) { remainder in
                Text(remainder.title ?? "nill")
            }
        }
    }
}

//struct RYMWidgetView_Previews: PreviewProvider {
//    static var previews: some View {
//        RYMWidgetView(remainders: FetchedResults<MedicineRemainder>)
//    }
//}
