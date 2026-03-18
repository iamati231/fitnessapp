import SwiftUI
import AVFoundation

struct RestTimerState: Equatable {
    var timeRemaining: TimeInterval
    var isRunning: Bool   = false
    var isPaused: Bool    = false
    static let stopped    = RestTimerState(timeRemaining: 0)
}

struct RestTimerView: View {
    let restSeconds: Int
    @State private var state = RestTimerState.stopped
    @State private var timer: Timer?

    private var progress: Double {
        guard restSeconds > 0 else { return 0 }
        return max(0, state.timeRemaining / Double(restSeconds))
    }

    private var timeString: String {
        let m = Int(state.timeRemaining) / 60
        let s = Int(state.timeRemaining) % 60
        return String(format: "%d:%02d", m, s)
    }

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .stroke(Color.secondary.opacity(0.2), lineWidth: 10)
                    .frame(width: 130, height: 130)

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color.teal, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 0.1), value: progress)
                    .frame(width: 130, height: 130)

                VStack(spacing: 2) {
                    Text(timeString)
                        .font(.system(.title2, design: .monospaced).bold())
                    Text(state.isRunning ? (state.isPaused ? "Pausiert" : "Läuft...") : "Bereit")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }

            HStack(spacing: 20) {
                Button(action: resetTimer) {
                    Image(systemName: "arrow.clockwise")
                        .font(.title3)
                }
                .tint(.secondary)
                .buttonStyle(.bordered)

                if !state.isRunning {
                    Button(action: startTimer) {
                        Label("Start", systemImage: "play.fill")
                            .font(.headline)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.teal)
                } else {
                    Button(action: pauseResume) {
                        Label(state.isPaused ? "Weiter" : "Pause",
                              systemImage: state.isPaused ? "play.fill" : "pause.fill")
                            .font(.headline)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.teal)
                }
            }
        }
        .onDisappear { cleanup() }
    }

    private func startTimer() {
        state = RestTimerState(timeRemaining: Double(restSeconds), isRunning: true)
        haptic(.medium)
        startCounting()
    }

    private func pauseResume() {
        state.isPaused.toggle()
        haptic(.light)
        if !state.isPaused { startCounting() }
        else { timer?.invalidate(); timer = nil }
    }

    private func resetTimer() {
        state = .stopped
        haptic(.light)
        cleanup()
    }

    private func startCounting() {
        timer?.invalidate()
        let t = Timer(timeInterval: 0.1, repeats: true) { _ in
            guard !state.isPaused, state.timeRemaining > 0.05 else {
                if state.timeRemaining <= 0.05 { finishTimer() }
                return
            }
            state.timeRemaining -= 0.1
        }
        RunLoop.main.add(t, forMode: .common)
        timer = t
    }

    private func finishTimer() {
        state = .stopped
        cleanup()
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        AudioServicesPlaySystemSound(1052)   // iOS "Complete" Sound
    }

    private func cleanup() {
        timer?.invalidate()
        timer = nil
    }

    private func haptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}
