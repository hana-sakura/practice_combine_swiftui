//
//  HIIT_TimerApp.swift
//  HIIT Timer
//

import SwiftUI

@main
struct HIIT_TimerApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(timerManager: TimerManager(exerciseTime: 20, restTime: 10, numSets: 8))
        }
    }
}
