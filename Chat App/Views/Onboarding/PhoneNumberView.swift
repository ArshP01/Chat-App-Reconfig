//
//  PhoneNumberView.swift
//  Chat App
//
//  Created by Arsh on 30/03/23.
//

import SwiftUI
import Combine

struct PhoneNumberView: View {
    
    @Binding var currentStep: OnboardingStep
    
    @State var phoneNumber = ""
    
    @State var isButtonDisabled = false
    
    var body: some View {
        
        VStack {
            
            Text("Verification")
                .font(Font.titleText)
                .padding(.top, 52)
            
            Text("Enter your mobile number below. We’ll send you a verification code after.")
                .font(Font.bodyParagraph)
                .padding(.top, 12)
            
            // Textfield
            ZStack {
                
                Rectangle()
                    .frame(height: 56)
                    .foregroundColor(Color("input"))
                
                HStack{
                    TextField("e.g. 91 12345 67890", text: $phoneNumber)
                        .font(Font.bodyParagraph)
                        .keyboardType(.numberPad)
                        .onReceive(Just(phoneNumber)) { _ in
                            TextHelper.applyPatternOnNumbers(&phoneNumber, pattern: "+## ##### #####", replacementCharacter: "#")
                        }
                    
                    Spacer()
                    
                    Button {
                        // Clear text field
                        phoneNumber = ""
                    } label: {
                        Image(systemName: "multiply.circle.fill")
                    }
                    .frame(width: 19, height: 19)
                    .tint(Color("icons-input"))
                    
                        
                        
                }
                .padding()
                
            }
            .padding(.top, 34)
            
            Spacer()
            
            Button {
                
                // Disable the button from multiple taps
                isButtonDisabled = true
                
                // Send their phone number to Firebase Auth
                
                AuthViewModel.sendPhoneNumber(phone: phoneNumber) { error in
                    
                    // Check for errors
                    if error == nil {
                        
                        // Move to the next step
                        currentStep = .verification
                    }
                    else {
                        // TODO: show an error
                    }
                    
                    // Reenable button
                    isButtonDisabled = false
                }
                
                
                
            } label: {
                
                HStack {
                    Text("Next")
                    
                    if isButtonDisabled {
                        ProgressView()
                            .padding(.leading, 2)
                    }
                }
            }
            .buttonStyle(OnboardingButtonStyle())
            .padding(.bottom, 87)
            .disabled(isButtonDisabled)

            
        }
        .padding(.horizontal)
        
    }
        
}

struct PhoneNumberView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNumberView(currentStep: .constant(.phonenumber))
    }
}
