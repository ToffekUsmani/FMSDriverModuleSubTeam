import SwiftUI

struct ContentView: View {

    @State private var searchText = ""

    let fruits = ["Apple", "Banana", "Orange", "Mango", "Grapes"]

    var filteredFruits: [String] {
        if searchText.isEmpty {
            return fruits
        } else {
            return fruits.filter {
                $0.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationStack {
            List(filteredFruits, id: \.self) { fruit in
                Text(fruit)
            }
            .navigationTitle("Search")
            .searchable(text: $searchText,
                        prompt: "Search fruits")
        }
    }
}
#Preview {
    ContentView()
}
