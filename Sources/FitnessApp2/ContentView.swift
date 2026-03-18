import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            WeekView()
                .tabItem { Label("Plan", systemImage: "calendar") }
            PlateCalculatorView()
                .tabItem { Label("Plates", systemImage: "scalemass") }
        }
        .tint(.teal)
    }
}
