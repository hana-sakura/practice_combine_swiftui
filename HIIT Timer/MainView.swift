//
//  MainView.swift
//  HIIT Timer
//

import SwiftUI

struct MainView: View {
    @StateObject private var timerManager: TimerManager
    @State private var isSettingPresented = false
    @Environment(\.colorScheme) var colorScheme
        
    init(timerManager: TimerManager) {
        self._timerManager = StateObject(wrappedValue: timerManager)
    }
    
    var body: some View {
        VStack {
            Text("HIIT Timer")
                .font(.largeTitle)
                .padding()

            ZStack(alignment: .center) {
                Circle()
                    .stroke(Color.gray, style: StrokeStyle(lineWidth:10))
                    .scaledToFit()
                    .padding(20)

                Text("\(timerManager.displayTime)")
                    .font(.system(size: 100))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .padding()

                Circle()
                    .trim(from: 0.0, to: timerManager.duration)
                    .stroke(Color.pink, style: StrokeStyle(lineWidth:10, lineCap: .round))
                    .scaledToFit()
                    .padding(20)
                    .rotationEffect(.degrees(-90))

            }.onAppear() {
                timerManager.displayTime = 0
                timerManager.maxValue = 5
            }

            HStack(alignment: .center) {
                Text("\(timerManager.currentSet) set")
                    .font(.title)

                if timerManager.isRunning {
                    Button("Stop") {
                        timerManager.stopTimer()
                    }
                    .font(.title)
                    .padding()
                    .frame(width: 120, height: 50)
                    .foregroundColor(Color.pink)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.pink, lineWidth: 3)
                    )
                    .padding()
                } else {
                    Button("Start") {
                        timerManager.startTimer()
                    }
                    .font(.title)
                    .padding()
                    .frame(width: 120, height: 50)
                    .foregroundColor(Color.white)
                    .background(Color.pink)
                    .cornerRadius(25)
                    .padding()
                }
            }

            Button(
                action: { isSettingPresented = true },
                label: {
                Image(systemName: "gear.circle")
                  .font(.system(size: 40))
                  .foregroundColor(.gray)
                  .padding()
                })
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity,
                       alignment: .bottomTrailing)
                .sheet(isPresented: $isSettingPresented) {
                    SettingsView(timerManager: timerManager)
                        .presentationDetents([.height(300)])
                }
        }
        .padding()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let timerManager = TimerManager(exerciseTime: 20, restTime: 10, numSets: 8)
        return MainView(timerManager: timerManager)
    }
}
