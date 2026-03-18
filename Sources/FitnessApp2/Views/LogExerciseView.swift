import SwiftUI
import AVFoundation

struct LogExerciseView: View {
    @Bindable var exercise: Exercise
    @Environment(\.dismiss) private var dismiss

    @State private var setIndex  = 1
    @State private var weight: Double = 0
    @State private var reps      = 0
    @State private var rpe       = 7.5
    @State private var rir       = 2
    @State private var comment   = ""
    @State private var showTimer = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // Satz-Header
                HStack {
                    Text("Satz")
                        .font(.subheadline.bold())
                        .foregroundStyle(.secondary)
                    Spacer()
                    Stepper("Satz \(setIndex) / \(exercise.sets)", value: $setIndex, in: 1...exercise.sets)
                        .fixedSize()
                }
                .padding()
                .background(cardBackground)

                // Gewicht & Wiederholungen
                VStack(spacing: 14) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Gewicht (kg)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            TextField("0", value: $weight, format: .number.precision(.fractionLength(1)))
                                .keyboardType(.decimalPad)
                                .font(.title.bold().monospacedDigit())
                                .foregroundStyle(.teal)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("Wiederholungen")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            HStack {
                                Button { if reps > 0 { reps -= 1 } } label: {
                                    Image(systemName: "minus.circle.fill").font(.title2)
                                }
                                .tint(.secondary)
                                Text("\(reps)")
                                    .font(.title.bold().monospacedDigit())
                                    .frame(minWidth: 40)
                                Button { reps += 1 } label: {
                                    Image(systemName: "plus.circle.fill").font(.title2)
                                }
                                .tint(.teal)
                            }
                        }
                    }
                }
                .padding()
                .background(cardBackground)

                // RPE / RIR
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("RPE").font(.subheadline.bold())
                            Spacer()
                            Text(String(format: "%.1f", rpe)).font(.subheadline.monospacedDigit())
                                .foregroundStyle(.teal)
                        }
                        Slider(value: $rpe, in: 6...10, step: 0.5).tint(.teal)
                        Text("Ziel: RPE 7–9 (1–3 Wdh vor Muskelversagen)")
                            .font(.caption2).foregroundStyle(.tertiary)
                    }

                    Divider()

                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("RIR (Reps in Reserve)").font(.subheadline.bold())
                            Spacer()
                            Text("\(rir)").font(.subheadline.monospacedDigit())
                                .foregroundStyle(.teal)
                        }
                        HStack(spacing: 10) {
                            ForEach(0...5, id: \.self) { value in
                                Button {
                                    rir = value
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                } label: {
                                    Text("\(value)")
                                        .font(.subheadline.bold())
                                        .frame(width: 40, height: 40)
                                        .background(rir == value
                                            ? Color.teal
                                            : Color(.tertiarySystemBackground))
                                        .foregroundStyle(rir == value ? .white : .primary)
                                        .clipShape(Circle())
                                }
                            }
                        }
                        Text("0 = Muskelversagen, 3 = idealer Bereich, 5 = leicht")
                            .font(.caption2).foregroundStyle(.tertiary)
                    }
                }
                .padding()
                .background(cardBackground)

                // Rest Timer
                DisclosureGroup("Rest Timer (\(exercise.restSeconds)s)", isExpanded: $showTimer) {
                    RestTimerView(restSeconds: exercise.restSeconds)
                        .padding(.top, 8)
                }
                .padding()
                .background(cardBackground)
                .accentColor(.teal)

                // Notiz
                VStack(alignment: .leading, spacing: 6) {
                    Text("Notiz").font(.subheadline.bold())
                    TextField("Optional...", text: $comment, axis: .vertical)
                        .lineLimit(2...4)
                }
                .padding()
                .background(cardBackground)

                // Progressions-Hinweis
                if !progressHint.isEmpty {
                    HStack(spacing: 8) {
                        Image(systemName: "lightbulb.fill")
                            .foregroundStyle(.yellow)
                        Text(progressHint)
                            .font(.caption)
                    }
                    .padding()
                    .background(Color.yellow.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 4)
                }

                // Speichern Button
                Button(action: saveLog) {
                    Label("Satz speichern", systemImage: "checkmark.circle.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.teal)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
            }
            .padding()
        }
        .navigationTitle(exercise.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let s = exercise.suggestedWeight { weight = s }
            else if let last = exercise.logs.sorted(by: { $0.date > $1.date }).first { weight = last.weight }
        }
    }

    private var cardBackground: some ShapeStyle {
        Color(.secondarySystemBackground)
    }

    private var progressHint: String {
        guard reps > 0 else { return "" }
        if reps >= exercise.repsMax + 2 {
            return "Sehr gut! Nächste Einheit ca. +2,5 kg."
        } else if reps < exercise.repsMin {
            return "Unter Zielbereich – ggf. Gewicht leicht senken."
        }
        return ""
    }

    private func saveLog() {
        let log = ExerciseLog(
            setIndex: setIndex,
            weight: weight,
            reps: reps,
            rpe: rpe,
            rir: rir,
            comment: comment.isEmpty ? nil : comment
        )
        exercise.logs.append(log)
        exercise.updateSuggestedWeight()
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        comment = ""
        if setIndex < exercise.sets {
            setIndex += 1
            showTimer = true
        } else {
            dismiss()
        }
    }
}
