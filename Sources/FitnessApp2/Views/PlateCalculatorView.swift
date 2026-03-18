import SwiftUI

struct PlateConfig: Identifiable {
    let id = UUID()
    let plateWeight: Double
    let countPerSide: Int
}

struct PlateCalculator {
    static func calculate(target: Double, bar: Double, available: [Double]) -> [PlateConfig] {
        let perSide = (target - bar) / 2.0
        guard perSide > 0 else { return [] }
        var remaining = perSide
        var result: [PlateConfig] = []
        let sorted = available.sorted(by: >)
        for plate in sorted {
            if remaining <= 0 { break }
            let count: Int = Int(remaining / plate)
            if count > 0 {
                result.append(PlateConfig(plateWeight: plate, countPerSide: count))
                remaining = remaining - (Double(count) * plate)
            }
        }
        return result
    }
}

struct PlateCalculatorView: View {
    @State private var targetWeight: Double = 100
    @State private var barWeight: Double = 20
    @State private var plates: [PlateConfig] = []

    let availablePlates: [Double] = [25, 20, 15, 10, 5, 2.5, 1.25]

    var body: some View {
        NavigationStack {
            Form {
                Section("Zielgewicht") {
                    HStack {
                        Text("Gesamt (kg)")
                        Spacer()
                        TextField("100", value: $targetWeight, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Stange (kg)")
                        Spacer()
                        TextField("20", value: $barWeight, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                }

                Section {
                    Button("Berechnen") {
                        plates = PlateCalculator.calculate(
                            target: targetWeight,
                            bar: barWeight,
                            available: availablePlates
                        )
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.teal)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }

                if !plates.isEmpty {
                    Section("Scheiben pro Seite") {
                        ForEach(plates) { plate in
                            HStack {
                                Text("\(plate.plateWeight, specifier: "%.2f") kg")
                                Spacer()
                                Text("× \(plate.countPerSide)")
                                    .bold()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Scheiben-Rechner")
        }
    }
}
