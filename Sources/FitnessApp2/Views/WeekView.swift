import SwiftUI
import SwiftData

struct WeekView: View {
    @Query private var plans: [TrainingPlan]
    @Environment(\.modelContext) private var context

    private let weekdays = ["Montag","Dienstag","Mittwoch","Donnerstag","Freitag","Samstag","Sonntag"]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 12, pinnedViews: .sectionHeaders) {
                    if let plan = plans.first {
                        ForEach(1...7, id: \.self) { weekday in
                            let days = plan.days.filter { $0.weekday == weekday }
                            if !days.isEmpty {
                                Section {
                                    ForEach(days) { day in
                                        NavigationLink(destination: DayDetailView(day: day)) {
                                            DayCard(day: day)
                                                .padding(.horizontal)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                } header: {
                                    Text(weekdays[weekday - 1])
                                        .font(.caption.bold())
                                        .foregroundStyle(.secondary)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal)
                                        .padding(.top, 4)
                                }
                            }
                        }
                    } else {
                        Button("Plan initialisieren") {
                            SeedData.seed(context: context)
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top, 40)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Dein Plan")
            .background(Color(.systemBackground))
        }
    }
}

struct DayCard: View {
    let day: TrainingDay

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: day.type.systemImage)
                .font(.title2)
                .foregroundStyle(.teal)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text(day.name)
                    .font(.headline)
                Text(day.type.focus)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            if day.nextIntensity != .normal {
                Text(day.nextIntensity.rawValue)
                    .font(.caption2.bold())
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(day.nextIntensity == .light
                                ? Color.orange.opacity(0.2)
                                : Color.teal.opacity(0.2))
                    .foregroundStyle(day.nextIntensity == .light ? .orange : .teal)
                    .clipShape(Capsule())
            }

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }
}
