//
//  InputView.swift
//  HIIT Timer
//

import SwiftUI

struct TimerInputView: View {
    let title: String
    @Binding var inputText: String

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            TextField("", text: $inputText)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.trailing)
                .frame(width: 40)
        }
        .padding(.horizontal)
    }
}
