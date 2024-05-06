//
//  EditPage.swift
//  NC1-SecretFormula
//
//  Created by Lisandra Nicoline on 27/04/24.
//

import SwiftUI

struct EditPage: View {
    @Binding var scannedText: String // Define scannedText as a binding parameter

    private func convertText(_ text: String) -> String {
        var convertedText = ""
        let lines = text.components(separatedBy: "\n") // Split text into lines
        
        for line in lines {
            if let cupRange = line.range(of: "cup") {
                // Extract number before "cup"
                let lineComponents = line.components(separatedBy: " ")
                for (index, component) in lineComponents.enumerated() {
                    if let number = parseNumber(from: component) {
                        let unitIndex = index + 1
                        if unitIndex < lineComponents.count && lineComponents[unitIndex] == "cup" {
                            var convertedValue = Double(number)
                            if line.contains("flour") {
                                convertedValue = Double(number * 125)
                            } else if line.contains("bread flour") {
                                convertedValue = Double(number * 136)
                            } else if line.contains("sugar") {
                                convertedValue = Double(number * 200)
                            } else if line.contains("cocoa powder") {
                                convertedValue = Double(number * 85)
                            } else if line.contains("rolled oats") {
                                convertedValue = Double(number * 85)
                            } else if line.contains("rice") {
                                convertedValue = Double(number * 185)
                            } else if line.contains("honey") {
                                convertedValue = Double(number * 340)
                            } else if line.contains("molasses") {
                                convertedValue = Double(number * 340)
                            } else if line.contains("syrup") {
                                convertedValue = Double(number * 340)
                            } else if line.contains("water") {
                                convertedValue = Double(number * 237)
                            } else if line.contains("milk") {
                                convertedValue = Double(number * 249)
                            } else if line.contains("butter") {
                                convertedValue = Double(number * 227)
                            }
                            
                            convertedText += "\(convertedValue) g " + lineComponents.suffix(from: unitIndex + 1).joined(separator: " ")
                            break
                        }
                    }
                }
            } else if let ozRange = line.range(of: "oz") {
                // Extract number before "oz" and multiply by 28.35
                let lineComponents = line.components(separatedBy: " ")
                for (index, component) in lineComponents.enumerated() {
                    if let number = parseNumber(from: component) {
                        let unitIndex = index + 1
                        if unitIndex < lineComponents.count && lineComponents[unitIndex] == "oz" {
                            let convertedValue = Double(number * 28.35)
                            convertedText += "\(convertedValue) g " + lineComponents.suffix(from: unitIndex + 1).joined(separator: " ")
                            break
                        }
                    }
                }
            } else {
                // If "cup" is not found in the line, keep the original line
                convertedText += line
            }
            convertedText += "\n"
        }
        
        return convertedText
    }

    private func parseNumber(from string: String) -> Double? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        if let number = numberFormatter.number(from: string)?.doubleValue {
            return number
        } else {
            let fractionComponents = string.components(separatedBy: "/")
            if fractionComponents.count == 2,
               let numerator = Double(fractionComponents[0]),
               let denominator = Double(fractionComponents[1]),
               denominator != 0 {
                return numerator / denominator
            }
        }
        return nil
    }

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                    Text("SCANNED RECIPE")
                        .fontWeight(.bold)
                        .tracking(2.24)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .font(.largeTitle)
                        .padding(.top, 35)
                        .padding(.bottom,8)
                    Spacer()

            }
            HStack{
                Text("")
                    .padding(.leading, 38)
                Text("Feel free to tweak any errors in your scanned recipes, ensuring culinary accuracy with just a few taps!")
                    .font(Font.custom("SF", size: 13))
                    .tracking(1.04)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                Text("")
                    .padding(.trailing, 38)
            }
            .padding(.bottom, 8)

            ScrollView {
                VStack {
                    ZStack {
                        Color(red: 0.992, green: 0.957, blue: 0.890) // Background color
                            .ignoresSafeArea()

                        TextEditor(text: $scannedText) // Allow editing of scanned text
                            .padding()
                            .transparentScrolling()
                            .border(Color(hex: "AF8260"))
                            .background(Color(red: 0.992, green: 0.957, blue: 0.890))
                    }
                }
                .frame(minHeight: 400)
                .frame(maxHeight: .infinity)
                .frame(maxWidth: 300)

                Spacer() // Pushes everything above the button to the top
            }

            NavigationLink(destination: ConvertPage(convertedText: convertText(scannedText))) {
                Rectangle()
                    .fill(Color(hex: "AF8260"))
                    .frame(width: 280, height: 58) // Adjust size as needed
                    .overlay(
                        Text("CONVERT UNITS")
                            .font(.custom("Akshar", size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    )
                    .cornerRadius(20) // Optional: Add corner radius for rounded corners
            }
            .padding(.bottom, 20) // Add some padding to lift the button off the bottom edge
            .background(Color(red: 0.992, green: 0.957, blue: 0.890))
        }
        .navigationBarBackButtonHidden(true) // Hide the "Back" button
        .background(Color(red: 0.992, green: 0.957, blue: 0.890))
    }
}


public extension View {
    func transparentScrolling() -> some View {
        if #available(iOS 16.0, *) {
            return scrollContentBackground(.hidden)
        } else {
            return onAppear {
                UITextView.appearance().backgroundColor = .clear
            }
        }
    }
}

struct EditPage_Previews: PreviewProvider {
    static var previews: some View {
        EditPage(scannedText: .constant("Sample Scanned Text")) // Provide a sample scanned text
    }
}
