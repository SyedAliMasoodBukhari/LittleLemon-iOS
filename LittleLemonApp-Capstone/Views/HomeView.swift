import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var menuItems: [MenuItem] = []
    @State private var searchText: String = ""
    @State private var originalImageData: Data? = UserDefaults.standard.data(forKey: kProfileImage)
    @State private var selectedCategory: String = "All"
    @State private var isSearching: Bool = false
    @FocusState private var isSearchFocused: Bool
    private let categories = ["All", "Starters", "Mains", "Desserts", "Drinks"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isSearchFocused = false
                    }
                
                VStack(spacing: 10) {
                    HStack {
                        Spacer()
                        
                        Image("Logo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                            .shadow(radius: 5)
                        
                        Spacer()
                        
                        NavigationLink(destination: UserProfileView().navigationBarBackButtonHidden(true)) {
                            Image(uiImage: UIImage(data: originalImageData ?? Data()) ?? UIImage(named: "profile-image-placeholder")!)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())
                                .shadow(radius: 3)
                        }
                    }
                    .padding([.leading, .trailing], 15)
                    
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
                        
                        ZStack(alignment: .leading) {
                            HStack {
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        isSearching.toggle()
                                    }
                                }) {
                                    Image(systemName: "magnifyingglass")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .frame(width: 35, height: 35)
                                        .background(Circle().fill(Color(hex: "F4CE14")))
                                        .shadow(radius: 5)
                                }
                            }
                            .frame(height: 40)
                            
                            if isSearching {
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.gray)
                                    TextField("Search", text: $searchText)
                                        .textFieldStyle(.plain)
                                        .focused($isSearchFocused)
                                }
                                .padding(.horizontal)
                                .frame(height: 40)
                                .background(Color.white)
                                .clipShape(Capsule())
                                .offset(x: isSearching ? 0 : -40)
                                .opacity(isSearching ? 1 : 0)
                                .animation(.easeInOut(duration: 0.3), value: isSearching)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onChange(of: isSearchFocused) { oldValue, newValue in
                            if oldValue == true && newValue == false {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    if !isSearchFocused {
                                        withAnimation {
                                            isSearching = false
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.top, 5)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 25)
                    .padding(.vertical, 15)
                    .background(Color(hex: "495E57"))
                    .cornerRadius(12)
                    .shadow(radius: 3)
                    
                    VStack (alignment: .leading, spacing: 10) {
                        Text("ORDER FOR DELIVERY!")
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(categories, id: \.self) { category in
                                    Button(action: {
                                        selectedCategory = category
                                    }) {
                                        Text(category)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(selectedCategory == category ? Color(hex: "F4CE14") : Color(hex: "495E57").opacity(0.2))
                                            .foregroundStyle(selectedCategory == category ? .white : Color(hex: "495E57"))
                                            .cornerRadius(10)
                                            .font(.system(size: 14, weight: .bold))
                                    }
                                }
                            }
                        }
                    }
                    .padding([.leading, .trailing], 20)
                    .padding([.top, .bottom], 10)
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(maxWidth: .infinity, minHeight: 1, maxHeight: 1)
                        .padding([.leading, .trailing], 20)
                    
                    FetchedObjects(
                        predicate: buildPredicate(),
                        sortDescriptors: buildSortDescriptors()
                    ) { (dishes: [Dish]) in
                        List {
                            ForEach(dishes) { dish in
                                NavigationLink(destination: DishDetailView(dish: dish)) {
                                    HStack(alignment: .center, spacing: 10) {
                                        VStack(alignment: .leading, spacing: 7) {
                                            Text("\(dish.title ?? "")")
                                                .font(.title3)
                                                .fontWeight(.semibold)
                                            Text("\(dish.dishDescription ?? "")")
                                                .font(.headline)
                                                .foregroundStyle(.secondary)
                                            Text("$\(dish.price ?? "")")
                                                .font(.title3)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(Color(hex: "495E57"))
                                        }
                                        Spacer()
                                        AsyncImage(url: URL(string: dish.image ?? "")) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 70, height: 70)
                                                .cornerRadius(10)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                    }
                                    .listRowBackground(Color.clear)
                                }
                            }
                        }
                        .listStyle(.plain)
                    }
                    
                }
                .padding()
                .onAppear {
                    getMenuData()
                }
            }
        }
    }
    
    func getMenuData() {
        let urlString = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(MenuList.self, from: data)
                    DispatchQueue.main.async {
                        PersistenceController.shared.clear()
                        for item in decoded.menu {
                            let dish = Dish(context: viewContext)
                            dish.title = item.title
                            dish.image = item.image
                            dish.price = item.price
                            dish.dishDescription = item.description
                            dish.category = item.category
                        }
                        
                        try? viewContext.save()
                    }
                } catch {
                    print("Decoding failed:", error)
                }
            } else {
                print("Network error:", error ?? "Unknown error")
            }
        }
        
        task.resume()
    }
    
    func buildSortDescriptors() -> [NSSortDescriptor] {
        return [
            NSSortDescriptor(
                key: "title",
                ascending: true,
                selector: #selector(NSString.localizedStandardCompare(_:))
            )
        ]
    }
    
    func buildPredicate() -> NSPredicate {
        if searchText.isEmpty {
            return NSPredicate(value: true)
        } else {
            return NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        }
    }
}

#Preview {
    HomeView()
}
