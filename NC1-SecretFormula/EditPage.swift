//
//  EditPage.swift
//  NC1-SecretFormula
//
//  Created by Lisandra Nicoline on 27/04/24.
//

import SwiftUI

struct EditPage: View {
    @Binding var scannedText: String // Define scannedText as a binding parameter

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    ZStack {
                        Color(red: 0.992, green: 0.957, blue: 0.890) // Background color
                            .ignoresSafeArea()
                        
                        TextEditor(text: $scannedText) // Allow editing of scanned text
                            .padding()
                            .transparentScrolling()
                            .background(Color(red: 0.992, green: 0.957, blue: 0.890))
                    }
                }
                .frame(minHeight: 500)
                .frame(maxHeight: .infinity) // Fill available space
                
                Spacer() // Pushes everything above the button to the top
            }
            
            NavigationLink(destination: ConvertPage()) {
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
