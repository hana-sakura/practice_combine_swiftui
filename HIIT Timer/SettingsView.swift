//
//  SettingsView.swift
//  HIIT Timer
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var timerManager: TimerManager
    @State private var restTimeInput = ""
    @State private var exerciseTimeInput = ""
    @State private var numSetsInput = ""
    
    var body: some View {
        VStack {

            HStack {
                Text("Rest Time")
                Spacer()
                TextField("10", text: $restTimeInput)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(TextAlignment.trailing)
                    .frame(width: 40)
            }.padding(.horizontal)

            HStack {
                Text("Exercise Time")
                Spacer()
                TextField("20", text: $exerciseTimeInput)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(TextAlignment.trailing)
                    .frame(width: 40)
            }.padding(.horizontal)

            HStack {
                Text("Set")
                Spacer()
                TextField("8", text: $numSetsInput)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(TextAlignment.trailing)
                    .frame(width: 40)
            }.padding(.horizontal)

            Button("Save") {
                guard let restTime = Int(restTimeInput),
                      let exerciseTime = Int(exerciseTimeInput),
                      let numSets = Int(numSetsInput) else {
                    // 入力が無効な場合のエラーハンドリング
                    return
                }
                
                timerManager.setTimerSettings(restTime: restTime, exerciseTime: exerciseTime, numSets: numSets)
                presentationMode.wrappedValue.dismiss()
            }
            .font(.title)
            .padding()
            .frame(width: 120, height: 50)
            .foregroundColor(Color.white)
            .background(Color.pink)
            .cornerRadius(25)
            .padding()
        }
        .onAppear {
            restTimeInput = String(timerManager.restTime)
            exerciseTimeInput = String(timerManager.exerciseTime)
            numSetsInput = String(timerManager.numSets)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(timerManager: TimerManager(exerciseTime: 20, restTime: 10, numSets: 8))
    }
}
