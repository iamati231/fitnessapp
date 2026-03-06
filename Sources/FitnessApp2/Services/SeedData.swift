import SwiftData

struct SeedData {
    static func seed(context: ModelContext) {
        let plan = TrainingPlan()

        // --- Montag: Tag A ---
        let dayA = TrainingDay(name: "Tag A – Unterkörper Push", weekday: 1, type: .strengthA)
        dayA.exercises = [
            Exercise(name: "Kniebeuge (Back Squat)",     sets: 3, repsMin: 4,  repsMax: 6,  restSeconds: 150,
                     notes: "Knie über Fußspitzen, Brust hoch, mindestens parallel. RPE 7–9."),
            Exercise(name: "Bankdrücken (LH/KH)",        sets: 3, repsMin: 6,  repsMax: 8,  restSeconds: 120,
                     notes: "Schulterblätter zusammen, leichter Bogen im unteren Rücken."),
            Exercise(name: "Rumänisches Kreuzheben",     sets: 3, repsMin: 6,  repsMax: 8,  restSeconds: 120,
                     notes: "Hüfte nach hinten, fast gestreckte Beine, Rücken neutral."),
            Exercise(name: "Rudern vorgebeugt",          sets: 3, repsMin: 8,  repsMax: 10, restSeconds: 90,
                     notes: "Rücken neutral, Ellbogen eng."),
            Exercise(name: "Plank",                      sets: 3, repsMin: 30, repsMax: 45, restSeconds: 60,
                     notes: "Fester Core, keine durchhängende Hüfte. Sekunden statt Wdh."),
        ]

        // --- Dienstag: Fußball ---
        let dayFb1 = TrainingDay(name: "Fußballtraining", weekday: 2, type: .footballTraining)

        // --- Mittwoch: Tag B ---
        let dayB = TrainingDay(name: "Tag B – Oberkörper & Core", weekday: 3, type: .strengthB)
        dayB.exercises = [
            Exercise(name: "Kreuzheben (konventionell)", sets: 3, repsMin: 3,  repsMax: 5,  restSeconds: 180,
                     notes: "Schienbeine nah an der Stange, Hüfte tief genug, Lat aktivieren."),
            Exercise(name: "Schrägbankdrücken (KH/LH)",  sets: 3, repsMin: 6,  repsMax: 8,  restSeconds: 120,
                     notes: "Schulterblätter nach unten, voller ROM."),
            Exercise(name: "Klimmzüge / Latzug",         sets: 3, repsMin: 6,  repsMax: 10, restSeconds: 120,
                     notes: "Schulterblätter nach unten ziehen (Depression), Brust zur Stange."),
            Exercise(name: "Schulterdrücken (KH/Maschine)", sets: 3, repsMin: 8, repsMax: 10, restSeconds: 90,
                     notes: "Core aktivieren, kein Hohlkreuz. Voller ROM."),
            Exercise(name: "Hanging Leg Raises / Kabel-Crunch", sets: 3, repsMin: 10, repsMax: 15, restSeconds: 60),
        ]

        // --- Donnerstag: Fußball ---
        let dayFb2 = TrainingDay(name: "Fußballtraining", weekday: 4, type: .footballTraining)

        // --- Freitag: Tag C ---
        let dayC = TrainingDay(name: "Tag C – Power & Volumen", weekday: 5, type: .strengthC)
        dayC.exercises = [
            Exercise(name: "Front Squat / Beinpresse",   sets: 3, repsMin: 6,  repsMax: 8,  restSeconds: 120,
                     notes: "Ellbogen hoch, Oberkörper aufrecht. Alternative: Beinpresse Fe schulterbreit."),
            Exercise(name: "Hip Thrust (LH)",            sets: 3, repsMin: 8,  repsMax: 10, restSeconds: 90,
                     notes: "Schulterblätter auf Bank, Hüfte volle Extension, Gesäß-Kontraktion 1 Sek halten."),
            Exercise(name: "Langhantel-/Kabelrudern",    sets: 3, repsMin: 8,  repsMax: 12, restSeconds: 90,
                     notes: "Rücken neutral, Schulterblätter am Ende zusammenziehen."),
            Exercise(name: "Face Pulls / Reverse Flys",  sets: 3, repsMin: 12, repsMax: 15, restSeconds: 60,
                     notes: "Seil zur Nase/Stirn, externe Rotation der Schulter."),
            Exercise(name: "Wadenheben (stehend/sitzend)", sets: 3, repsMin: 10, repsMax: 15, restSeconds: 60),
        ]

        // --- Samstag: Spiel ---
        let dayMatch = TrainingDay(name: "Fußballspiel / Wettkampf", weekday: 6, type: .footballMatch)

        // --- Sonntag: Ruhetag ---
        let dayRest = TrainingDay(name: "Ruhetag", weekday: 7, type: .rest)

        plan.days = [dayA, dayFb1, dayB, dayFb2, dayC, dayMatch, dayRest]
        context.insert(plan)
    }
}
