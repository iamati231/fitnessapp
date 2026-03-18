import SwiftUI

struct DayDetailView: View {
    @Bindable var day: TrainingDay
    @State private var showFinishAlert = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header Card
                VStack(spacing: 8) {
                    Image(systemName: day.type.systemImage)
                        .font(.system(size: 40))
                        .foregroundStyle(.teal)
                    Text(day.name)
                        .font(.title2.bold())
                    Text(day.type.focus)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color(.secondarySystemBackground))
                )
                .padding(.horizontal)

                // Exercises
                if !day.exercises.isEmpty {
                    VStack(spacing: 10) {
                        ForEach(day.exercises) { exercise in
                            NavigationLink(destination: LogExerciseView(exercise: exercise)) {
                                ExerciseRow(exercise: exercise)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                }

                // Einheit abschließen
                Button {
                    day.evaluateNextIntensity()
                    showFinishAlert = true
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                } label: {
                    Label("Einheit abschließen", systemImage: "checkmark.circle.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.teal)
                        )
                        .foregroundStyle(.white)
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .alert("Einheit gespeichert!", isPresented: $showFinishAlert) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text("Nächste Intensität: \(day.nextIntensity.rawValue)")
                }
            }
            .padding(.vertical)
        }
        .navigationTitle(day.type.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackground))
    }
}

struct ExerciseRow: View {
    let exercise: Exercise

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(exercise.name)
                    .font(.headline)

                HStack(spacing: 12) {
                    Label("\(exercise.sets) Sätze", systemImage: "repeat")
                    Label("\(exercise.repsMin)–\(exercise.repsMax) Wdh", systemImage: "arrow.up.arrow.down")
                    Label("\(exercise.restSeconds)s", systemImage: "timer")
                }
                .font(.caption)
                .foregroundStyle(.secondary)

                if let suggested = exercise.suggestedWeight {
                    Text("Vorschlag: \(Int(suggested)) kg")
                        .font(.caption.bold())
                        .foregroundStyle(.teal)
                }
            }

            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }
}
