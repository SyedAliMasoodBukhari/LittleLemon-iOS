import SwiftUI

struct UserProfileView: View {
    let persistenceController = PersistenceController.shared
    
    @Environment(\.presentationMode) var presentation
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var selectedCountryCode: String = "+92"
    @State private var phoneNumber: String = ""
    @State private var selectedImage: UIImage? = {
        guard let imageData = UserDefaults.standard.data(forKey: kProfileImage),
              let image = UIImage(data: imageData) else {
            return nil
        }
        return image
    }()
    @State private var originalImageData: Data? = UserDefaults.standard.data(forKey: kProfileImage)
    @State private var isImagePickerPresented = false
    @State private var isImageSelected = false
    @State private var isEditingProfile = false
    @State private var shouldNavigateToOnboarding = false
    
    @State private var emailNotificationOptions = [
        (title: "Order updates", isOn: false),
        (title: "Password changes", isOn: false),
        (title: "Special offers", isOn: false),
        (title: "Newsletter", isOn: false)
    ]
    
    let firstNameKey = UserDefaults.standard.string(forKey: kFirstName)
    let lastNameKey = UserDefaults.standard.string(forKey: kLastName)
    let emailKey = UserDefaults.standard.string(forKey: kEmail)
    let phoneNumberKey = UserDefaults.standard.string(forKey: kPhoneNumber)
    
    let defaultPlaceholdeImage: String = "profile-image-placeholder"
    
    var body: some View {
        NavigationStack {
            VStack (spacing: 0) {
                HStack {
                    Button(action: {
                        self.presentation.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 35, height: 35)
                            .background(Circle().fill(Color(hex: "495E57")))
                            .shadow(radius: 5)
                    }
                    
                    Spacer()
                    
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .shadow(radius: 5)
                    
                    Spacer()
                    
                    Image(uiImage: UIImage(data: originalImageData ?? Data()) ?? UIImage(named: defaultPlaceholdeImage)!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        .shadow(radius: 3)
                }
                .padding([.leading, .trailing], 25)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Personal information")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(.bottom, 5)
                        
                        if !isEditingProfile {
                            Spacer()
                            
                            Button(action: {
                                withAnimation {
                                    isEditingProfile = true
                                }
                            }) {
                                Image(systemName: "square.and.pencil")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color(hex: "495E57"))
                                    .shadow(radius: 5)
                            }
                        }
                    }
                    
                    Text("Avatar")
                        .font(.caption)
                        .foregroundStyle(Color(hex: "636363"))
                    
                    HStack(spacing: isEditingProfile ? 15 : 0) {
                        Image(uiImage: selectedImage ?? UIImage(named: defaultPlaceholdeImage)!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                            .frame(maxWidth: .infinity, alignment: isEditingProfile ? .leading : .center)
                            .animation(.easeInOut(duration: 0.3), value: isEditingProfile)
                        
                        if isEditingProfile {
                            Button("Change") {
                                isImagePickerPresented = true
                            }
                            .font(.system(size: 14, weight: .semibold))
                            .padding(.horizontal, 18)
                            .padding(.vertical, 14)
                            .background(Color(hex: "495E57"))
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            
                            Button("Remove") {
                                selectedImage = nil
                                originalImageData = nil
                                UserDefaults.standard.removeObject(forKey: kProfileImage)
                            }
                            .font(.system(size: 14, weight: .semibold))
                            .padding(.horizontal, 18)
                            .padding(.vertical, 14)
                            .foregroundStyle(Color(hex: "636363"))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(hex: "495E57"), lineWidth: 1)
                            )
                        }
                    }
                    .animation(.easeInOut(duration: 0.3), value: isEditingProfile)
                    
                    
                    
                    VStack (alignment: .leading, spacing: 5) {
                        Text("First name")
                            .font(.caption)
                            .foregroundStyle(Color(hex: "636363"))
                        
                        TextField(firstNameKey ?? "Enter first name", text: $firstName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(height: 34)
                            .disabled(!isEditingProfile)
                    }
                    .padding(.top, 10)
                    
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Last name")
                            .font(.caption)
                            .foregroundStyle(Color(hex: "636363"))
                        
                        TextField(lastNameKey ?? "Enter last name", text: $lastName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(height: 34)
                            .disabled(!isEditingProfile)
                    }
                    .padding(.top, 10)
                    
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Email")
                            .font(.caption)
                            .foregroundStyle(Color(hex: "636363"))
                        
                        TextField(emailKey ?? "Enter your email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(height: 34)
                            .disabled(!isEditingProfile)
                    }
                    .padding(.top, 10)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Phone number")
                            .font(.caption)
                            .foregroundStyle(Color(hex: "636363"))
                        
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
                                .padding(.leading, 10)
                                .font(.subheadline)
                            }
                            
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 1, height: 20)
                                .padding(.horizontal, 10)
                            
                            TextField(phoneNumberKey ?? "Enter number", text: $phoneNumber)
                                .keyboardType(.numberPad)
                                .onChange(of: phoneNumber) {
                                    phoneNumber = String(phoneNumber.prefix(10).filter { "0123456789".contains($0) })
                                }
                                .frame(height: 34)
                                .padding(.leading, 4)
                                .disabled(!isEditingProfile)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.4), style: StrokeStyle(lineWidth: 0.5))
                                )
                        )
                    }
                    .padding(.top, 10)
                    
                    Text("Email notifications")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                        .padding(.bottom, 1)
                    
                    ForEach(emailNotificationOptions.indices, id: \.self) { index in
                        Toggle(isOn: $emailNotificationOptions[index].isOn) {
                            Text(emailNotificationOptions[index].title)
                                .font(.footnote)
                                .padding([.leading,.bottom],3)
                        }
                        .toggleStyle(CheckboxToggleStyle())
                    }
                    
                    if isEditingProfile {
                        HStack(alignment: .center, spacing: 10) {
                            Button("Discard changes") {
                                if let data = originalImageData {
                                    selectedImage = UIImage(data: data)
                                } else {
                                    selectedImage = nil
                                }
                                withAnimation {
                                    isEditingProfile = false
                                }
                            }
                            .font(.system(size: 14, weight: .semibold))
                            .padding(.horizontal, 18)
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(Color(hex: "636363"))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(hex: "495E57"), lineWidth: 1)
                            )
                            
                            Button("Save changes") {
                                if let image = selectedImage,
                                   let imageData = image.jpegData(compressionQuality: 0.8) {
                                    UserDefaults.standard.set(imageData, forKey: kProfileImage)
                                    originalImageData = imageData
                                }
                                UserDefaults.standard.set(firstName, forKey: kFirstName)
                                UserDefaults.standard.set(lastName, forKey: kLastName)
                                UserDefaults.standard.set(email, forKey: kEmail)
                                if !phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty {
                                    let fullPhoneNumber = selectedCountryCode + phoneNumber
                                    UserDefaults.standard.set(fullPhoneNumber, forKey: kPhoneNumber)
                                } else {
                                    UserDefaults.standard.removeObject(forKey: kPhoneNumber)
                                }
                                isEditingProfile = false
                            }
                            .font(.system(size: 14, weight: .semibold))
                            .padding(.horizontal, 18)
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: "495E57"))
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                    } else {
                        Button("Logout") {
                            UserDefaults.standard.set(false, forKey: kIsLoggedIn)
                            shouldNavigateToOnboarding = true
                        }
                        .font(.system(size: 14, weight: .semibold))
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .background(Color(hex:"F4CE14"))
                        .foregroundStyle(.black)
                        .cornerRadius(10)
                        .padding(.vertical, 15)
                    }
                }
                .padding()
                .background(Color(.systemGroupedBackground))
                .cornerRadius(15)
                .padding(.horizontal, 15)
                .padding(.top, 10)
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(image: $selectedImage)
            }
        }
        .navigationDestination(isPresented: $shouldNavigateToOnboarding) {
            OnBoardingView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .foregroundStyle(configuration.isOn ? Color(hex: "495E57") : .secondary)
                    .fontWeight(.bold)
                
                configuration.label
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    UserProfileView()
}
