//
//  ConvertPage.swift
//  NC1-SecretFormula
//
//  Created by Lisandra Nicoline on 27/04/24.
//


import SwiftUI

struct ConvertPage: View {
    let convertedText: String // Property to receive converted text
    @State private var isShareSheetPresented = false

    var body: some View {
        VStack{
            HStack{
                Spacer()
            }
            VStack {
                Text("CONVERTED")
                    .fontWeight(.bold)
                    .tracking(2.24)
                    .foregroundColor(.black)
                    .font(.largeTitle)
                    .padding(.top, 10)
                Text("RECIPE")
                    .fontWeight(.bold)
                    .tracking(2.24)
                    .foregroundColor(.black)
                    .font(.largeTitle)
                    .padding(.bottom,35)
                
            }
            Spacer()
            ScrollView {
                Text(convertedText)
            }
            
            
            Button(action: {
                isShareSheetPresented.toggle()
            }) {
                Rectangle()
                    .fill(Color(hex: "AF8260"))
                    .frame(width: 280, height: 58) // Adjust size as needed
                    .overlay(
                        Text("SHARE")
                            .font(.custom("Akshar", size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    )
                    .cornerRadius(20) // Optional: Add corner radius for rounded corners
            }
            .padding()
            .sheet(isPresented: $isShareSheetPresented, content: {
                ActivityViewController(activityItems: [convertedText])
            })
        }
        .navigationBarBackButtonHidden(true)
        .background(Color(red: 0.992, green: 0.957, blue: 0.890))
    }
}

struct ConvertPage_Previews: PreviewProvider {
    static var previews: some View {
        ConvertPage(convertedText: "Sample Converted Text") // Provide a sample converted text
    }
}

struct ActivityViewController: UIViewControllerRepresentable {
    var activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    }
}

//
//
//#Preview {
//    ConvertPage()
//}
