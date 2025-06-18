import SwiftUI

struct DishDetailView: View {
    let dish: Dish
    
    var body: some View {
        VStack(spacing: 20) {
            Text(dish.title ?? "")
                .font(.largeTitle)
                .bold()
            
            Text("Price: \(dish.price ?? "")")
                .font(.title2)
            
            AsyncImage(url: URL(string: dish.image ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
            } placeholder: {
                ProgressView()
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Dish Details")
    }
}
