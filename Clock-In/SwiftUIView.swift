//
//  SwiftUIView.swift
//  Clock-In
//
//  Created by William Lee on 2022/8/4.
//

import SwiftUI

struct SwiftUIView: View {
    @ State var currentTime = Date()
    var closedRange = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
    
    var body: some View {
        Form{
            Section(header: Text("請假日期")){
                DatePicker("日期/時間", selection: $currentTime, in: Date()...)
            }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
