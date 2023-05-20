//
//  TimerManager.swift
//  HIIT Timer
//

import SwiftUI
import Combine
import AVFoundation

class TimerManager: ObservableObject {
    @Published var isRunning = false
    @Published var remainingTime: Double = 0.0
    @Published var displayTime: Int = 0
    @Published var currentSet: Int
    @Published var exerciseTime: Int
    @Published var restTime: Int
    @Published var numSets: Int
    @Published var isTimerRunning: Bool = false
    @Published var duration: CGFloat = 0
    
    private var cancellable: AnyCancellable?
    private var timer: Timer?
    var maxValue: Double = 0.0

    private let stopSound: AVAudioPlayer
    
    private var isRestTime = true
    
    init(exerciseTime: Int, restTime: Int, numSets: Int) {
        self.exerciseTime = exerciseTime
        self.restTime = restTime
        self.numSets = numSets
        self.currentSet = numSets

        if let stopSoundURL = Bundle.main.url(forResource: "sound", withExtension: "mp3") {
            stopSound = try! AVAudioPlayer(contentsOf: stopSoundURL)
        } else {
            stopSound = AVAudioPlayer()
        }
    }

    func startTimer(_ interval: Double = 0.1) {
        guard !isRunning else { return }

        isRunning = true
        isRestTime = true
        currentSet = numSets
        displayTime = isRestTime ? restTime : exerciseTime
        maxValue = Double(displayTime)
        remainingTime = Double(displayTime)

        cancellable = Timer.publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                if self.remainingTime > 0.1 {
                    self.remainingTime -= interval
                    self.displayTime = Int(ceil(self.remainingTime))
                    self.duration = CGFloat((self.remainingTime / self.maxValue))
                } else {
                    self.handleTimerEnd()
                }
            }
    }
    
    func stopTimer() {
        isRunning = false
        isRestTime = false
        timer?.invalidate()
        cancellable?.cancel()
        remainingTime = 0
        currentSet = numSets
        duration = 0
        displayTime = 0
    }
    
    func setTimerSettings(restTime: Int, exerciseTime: Int, numSets: Int) {
        self.restTime = restTime
        self.exerciseTime = exerciseTime
        self.numSets = numSets
    }
    
    private func handleTimerEnd() {
        if isRestTime {
            displayTime = exerciseTime
            remainingTime = Double(displayTime)
            maxValue = remainingTime
            isRestTime = false
            stopSound.play()
        } else {
            if currentSet > 1 {
                displayTime = restTime
                remainingTime = Double(displayTime)
                maxValue = remainingTime
                isRestTime = true
                currentSet -= 1
                stopSound.play()
            } else {
                isRunning = false
                displayTime = 0
                currentSet = numSets
                stopSound.play()
                stopTimer()
            }
        }
    }
}
