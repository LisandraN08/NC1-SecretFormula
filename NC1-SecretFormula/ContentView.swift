//
//  ContentView.swift
//  NC1-SecretFormula
//
//  Created by Lisandra Nicoline on 25/04/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Set background color using hex code
                Color(hex: "FDF4E3")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .padding()
                    Text("SECRET FORMULA")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.bottom, 4)
                    Text("UNLOCK THE SECRET TO PERFECT RECIPES")
                        .font(.custom("Akshar", size: 14))
                        .foregroundColor(.black)
                        .padding(.bottom, 100)
                    // Use NavigationLink to navigate to ScanPage
                    NavigationLink(destination: ScanPage()) {
                        Rectangle()
                            .fill(Color(hex: "AF8260"))
                            .frame(width: 280, height: 58) // Adjust size as needed
                            .overlay(
                                Text("SCAN YOUR RECIPE")
                                    .font(.custom("Akshar", size: 18))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            )
                            .cornerRadius(20) // Optional: Add corner radius for rounded corners
                    }
                }
            }
            .navigationBarHidden(true) // Hide navigation bar
        }
    }
}

// Extension to create Color from hex string
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0

        scanner.scanHexInt64(&rgb)

        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
