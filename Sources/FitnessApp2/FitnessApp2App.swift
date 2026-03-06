import SwiftUI
import SwiftData

@main
struct FitnessApp2App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [TrainingPlan.self, TrainingDay.self, Exercise.self, ExerciseLog.self])
    }
}
