//
//  TimerManager.swift
//  HIIT Timer
//

import SwiftUI
import Combine
import AVFoundation

class TimerManager: ObservableObject {
    /// タイマー稼働中か
    @Published var isRunning: Bool = false
    /// 残り秒数
    @Published var remainingTime: Double = 0.0
    /// 表示秒数
    @Published var displayTime: Int = 0
    /// セット数
    @Published var currentSet: Int
    /// 運動時間
    @Published var exerciseTime: Int
    /// 休憩時間
    @Published var restTime: Int
    /// セット数
    @Published var numSets: Int
    /// プログレスバーの進捗
    @Published var duration: CGFloat = 0
    
    private var cancellable: AnyCancellable?
    private var timer: Timer?
    private var isRestTime = true
    var maxValue: Double = 0.0

    private let stopSound: AVAudioPlayer
    
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

    /// タイマー終了時の切り替え
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
