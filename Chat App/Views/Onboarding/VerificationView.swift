//
//  VerificationView.swift
//  Chat App
//
//  Created by Arsh on 30/03/23.
//

import SwiftUI
import Combine

struct VerificationView: View {
    
    @EnvironmentObject var contactsViewModel: ContactsViewModel
    @EnvironmentObject var chatViewModel: ChatViewModel
    
    @Binding var currentStep: OnboardingStep
    @Binding var isOnboarding: Bool
    
    @State var verificationcode = ""
    
    @State var isButtonDisabled = false
    
    var body: some View {
        
        VStack {
            
            Text("Verification")
                .font(Font.titleText)
                .padding(.top, 52)
            
            Text("Enter the 6-digit verification code we sent to your device.")
                .font(Font.bodyParagraph)
                .padding(.top, 12)
            
            // Textfield
            ZStack {
                
                Rectangle()
                    .frame(height: 56)
                    .foregroundColor(Color("input"))
                
                HStack {
                    TextField("", text: $verificationcode)
                        .font(Font.bodyParagraph)
                        .keyboardType(.numberPad)
                        .onReceive(Just(verificationcode)) { _ in
                            TextHelper.limitText(&verificationcode, 6)
                        }
                    
                    Spacer()
                    
                    Button {
                        // Clear text field
                        verificationcode = ""
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
                
                // Disable the button
                isButtonDisabled = true
                
                // Send the verification code to Firebase
                AuthViewModel.verifyCode(code: verificationcode) { error in
                    
                    // Check for errors
                    if error == nil {
                        
                        // Check if this user has a profile
                        DatabaseService().checkUserProfile { exists in
                            
                            if exists {
                                // End the onboarding
                                isOnboarding = false
                                
                                // Load contacts
                                contactsViewModel.getLocalContacts()
                                
                                // Load chats
                                chatViewModel.getChats()
                            }
                            else {
                                // Move to the profile creation step
                                currentStep = .profile
                            }
                        }
                    }
                    else {
                        // TODO: Show error message
                    }
                    
                    // Reenable the button
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

struct VerificationView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationView(currentStep: .constant(.verification), isOnboarding: .constant(true))
    }
}
