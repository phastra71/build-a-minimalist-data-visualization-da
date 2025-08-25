// 3v0o_build_a_minimal.swift

import SwiftUI
import CorePlot

struct DataPoint: Identifiable {
    let id = UUID()
    var value: Double
    var label: String
}

struct DashboardView: View {
    @StateObject var data = DashboardData()
    
    var body: some View {
        VStack {
            PlotView(data: data.points)
                .frame(height: 300)
                .padding()
            Button("Refresh") {
                data.fetchData()
            }
            .padding()
        }
    }
}

class DashboardData: ObservableObject {
    @Published var points: [DataPoint] = []
    
    func fetchData() {
        // API Call to fetch data
        let url = URL(string: "https://api.example.com/data")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data returned")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                var newPoints: [DataPoint] = []
                for item in json ?? [] {
                    if let value = item["value"] as? Double, let label = item["label"] as? String {
                        newPoints.append(DataPoint(value: value, label: label))
                    }
                }
                self.points = newPoints
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}

struct PlotView: View {
    let data: [DataPoint]
    
    var body: some View {
        // Use Core Plot to create a line graph
        // For simplicity, this is just a placeholder
        GeometryReader { geometry in
            Rectangle()
                .fill(Color.blue)
                .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}