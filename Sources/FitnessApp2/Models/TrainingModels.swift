import SwiftData
import Foundation

// MARK: - Enums

enum DayType: String, Codable, CaseIterable {
    case strengthA       = "Tag A"
    case strengthB       = "Tag B"
    case strengthC       = "Tag C"
    case footballTraining = "Fußballtraining"
    case footballMatch   = "Spiel"
    case rest            = "Ruhetag"

    var focus: String {
        switch self {
        case .strengthA:        return "Quadrizeps, Brust, Rücken"
        case .strengthB:        return "Kreuzheben, Pull, Schultern, Core"
        case .strengthC:        return "Beine, Gesäß, Rücken, hintere Schulter"
        case .footballTraining: return "Ausdauer, Spielpraxis"
        case .footballMatch:    return "Wettkampfleistung"
        case .rest:             return "Regeneration"
        }
    }

    var systemImage: String {
        switch self {
        case .strengthA, .strengthB, .strengthC: return "dumbbell.fill"
        case .footballTraining:                  return "figure.run"
        case .footballMatch:                     return "sportscourt.fill"
        case .rest:                              return "moon.fill"
        }
    }
}

enum DayIntensity: String, Codable {
    case normal = "Normal"
    case light  = "Leicht"
    case heavy  = "Schwer"
}

// MARK: - Models

@Model
class TrainingPlan {
    var name: String
    var descriptionText: String
    var weeks: Int
    @Relationship(deleteRule: .cascade) var days: [TrainingDay] = []

    init(name: String = "Fettabbau & Muskelerhalt",
         descriptionText: String = "3x Ganzkörper, 45 Minuten, RPE 7–9.",
         weeks: Int = 12) {
        self.name = name
        self.descriptionText = descriptionText
        self.weeks = weeks
    }
}

@Model
class TrainingDay {
    var name: String
    var weekday: Int          // 1=Montag … 7=Sonntag
    var type: DayType
    var nextIntensity: DayIntensity = DayIntensity.normal
    @Relationship(deleteRule: .cascade) var exercises: [Exercise] = []

    init(name: String, weekday: Int, type: DayType) {
        self.name = name
        self.weekday = weekday
        self.type = type
    }

    /// Berechnet nextIntensity anhand des Durchschnitts-RIR aller Logs dieses Tages.
    func evaluateNextIntensity() {
        let allLogs = exercises.flatMap { $0.logs }
        guard !allLogs.isEmpty else { return }
        let avgRIR = Double(allLogs.map { $0.rir }.reduce(0, +)) / Double(allLogs.count)
        if avgRIR <= 1 {
            nextIntensity = .light
        } else if avgRIR >= 4 {
            nextIntensity = .heavy
        } else {
            nextIntensity = .normal
        }
    }
}

@Model
class Exercise {
    var name: String
    var sets: Int
    var repsMin: Int
    var repsMax: Int
    var restSeconds: Int
    var notes: String?
    var suggestedWeight: Double?      // wird nach jedem Log aktualisiert
    @Relationship(deleteRule: .cascade) var logs: [ExerciseLog] = []

    init(name: String, sets: Int, repsMin: Int, repsMax: Int,
         restSeconds: Int, notes: String? = nil) {
        self.name = name
        self.sets = sets
        self.repsMin = repsMin
        self.repsMax = repsMax
        self.restSeconds = restSeconds
        self.notes = notes
    }

    /// RIR-basierte Autoregulation: neues Vorschlagsgewicht berechnen.
    func updateSuggestedWeight() {
        guard let lastTopSet = logs
            .sorted(by: { $0.date > $1.date })
            .max(by: { $0.setIndex < $1.setIndex }) else { return }

        let multiplier: Double
        switch lastTopSet.rir {
        case 0:        multiplier = 0.97
        case 1:        multiplier = 1.00
        case 2...3:    multiplier = 1.02
        default:       multiplier = 1.04
        }

        let raw    = lastTopSet.weight * multiplier
        let step   = 2.5
        suggestedWeight = max(step, (raw / step).rounded() * step)
    }
}

@Model
class ExerciseLog {
    var date: Date    = Date()
    var setIndex: Int
    var weight: Double
    var reps: Int
    var rpe: Double
    var rir: Int
    var comment: String?

    init(setIndex: Int, weight: Double, reps: Int,
         rpe: Double, rir: Int, comment: String? = nil) {
        self.setIndex = setIndex
        self.weight   = weight
        self.reps     = reps
        self.rpe      = rpe
        self.rir      = rir
        self.comment  = comment
    }
}
