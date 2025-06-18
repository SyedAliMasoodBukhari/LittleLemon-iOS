let kFirstName = "first name key"
let kLastName = "last name key"
let kEmail = "email key"
let kPhoneNumber = "phone number key"
let kProfileImage = "profile image key"
let kIsLoggedIn = "kIsLoggedIn"

import SwiftUI

struct OnBoardingView: View {
    let persistence = PersistenceController.shared
    
    @State var firstName = ""
    @State var lastName = ""
    @State var email = ""
    @State var phoneNumber = ""
    @State var isLoggedIn = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isSuccess = false
    @State private var selectedCountryCode: String = "+92"
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .shadow(radius: 5)
                    Spacer()
                }
                
                VStack(alignment: .leading) {
                    Text("Little Lemon")
                        .font(.custom("Times New Roman", size: 42))
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "F4CE14"))
                    Text("Pakistan")
                        .font(.custom("Times New Roman", size: 28))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    HStack(alignment: .center, spacing: 15) {
                        Text("We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                            .font(.system(size: 16))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.leading)
                            .lineSpacing(0)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top, 4)
                        
                        Image("Hero image")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 140, height: 140)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 5)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 25)
                .padding(.vertical, 15)
                .background(Color(hex: "495E57"))
                .cornerRadius(12)
                .shadow(radius: 3)
                
                Spacer()
                
                VStack(spacing: 15) {
                    
                    Text("Welcome to Little Lemon!")
                        .font(.custom("Times New Roman", size: 24))
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "F4CE14"))
                    
                    TextField("First Name", text: $firstName)
                        .padding()
                        .frame(height: 54)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .shadow(radius: 1)
                    
                    TextField("Last Name", text: $lastName)
                        .padding()
                        .frame(height: 54)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .shadow(radius: 1)
                    
                    TextField("Email", text: $email)
                        .padding()
                        .frame(height: 54)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .shadow(radius: 1)
                    
                    HStack(spacing: 0) {
                        Menu {
                            Button("+92", action: { selectedCountryCode = "+92" })
                            Button("+91", action: { selectedCountryCode = "+91" })
                            Button("+1", action: { selectedCountryCode = "+1" })
                        } label: {
                            HStack(spacing: 4) {
                                Text(selectedCountryCode)
                                Image(systemName: "chevron.down")
                            }
                            .foregroundStyle(Color(hex: "636363"))
                            .font(.subheadline)
                        }
                        
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 1, height: 30)
                            .padding(.horizontal, 14)
                        
                        TextField("Enter phone number", text: $phoneNumber)
                            .keyboardType(.numberPad)
                            .onChange(of: phoneNumber) {
                                phoneNumber = String(phoneNumber.prefix(10).filter { "0123456789".contains($0) })
                            }
                            .padding(.leading, 4)
                    }
                    .frame(height: 54)
                    .padding(.horizontal)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .shadow(radius: 1)
                    
                    Button(action: {
                        if !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty && isValidEmail(email) {
                            UserDefaults.standard.set(firstName, forKey: kFirstName)
                            UserDefaults.standard.set(lastName, forKey: kLastName)
                            UserDefaults.standard.set(email, forKey: kEmail)
                            if !phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty {
                                let fullPhoneNumber = selectedCountryCode + phoneNumber
                                UserDefaults.standard.set(fullPhoneNumber, forKey: kPhoneNumber)
                            } else {
                                UserDefaults.standard.removeObject(forKey: kPhoneNumber)
                            }
                            UserDefaults.standard.set(true, forKey: kIsLoggedIn)
                            alertMessage = "Registration successful!"
                            isSuccess = true
                            showAlert = true
                        } else {
                            alertMessage = "Please fill all fields correctly."
                            isSuccess = false
                            showAlert = true
                        }
                    }) {
                        Text("Register")
                            .font(.title3)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background(Color(hex: "F4CE14"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(hex: "495E57"))
                .cornerRadius(12)
                .shadow(radius: 3)
                
                
                
                Spacer()
            }
            .alert(alertMessage, isPresented: $showAlert) {
                Button("OK") {
                    if isSuccess {
                        isLoggedIn = true
                    }
                }
            }
            .padding()
            .navigationDestination(isPresented: $isLoggedIn) {
                HomeView()
                    .environment(\.managedObjectContext, persistence.container.viewContext)
                    .navigationBarBackButtonHidden(true)
            }
            .onAppear {
                if UserDefaults.standard.bool(forKey: kIsLoggedIn) {
                    isLoggedIn = true
                }
            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

#Preview {
    OnBoardingView()
}
