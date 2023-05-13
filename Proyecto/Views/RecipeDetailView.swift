import SwiftUI
import URLImage

struct RecipeDetailView: View {
    
    let recipe: Recipe
    
    @State private var showDetails: [Bool] = Array(repeating: false, count: 7)
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                Color(hex: "#f9f9f9")
                    .edgesIgnoringSafeArea(.all) // Make the color fill the entire screen
                ScrollView {
                    ZStack(alignment: .center) {
                        if let imageURL = URL(string: recipe.image) {
                            URLImage(imageURL) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.width, height: geometry.size.height * 0.6) // Set a fixed height for the image
                                    .clipped()
                            }
                            ContentOverlay(recipe: recipe)
                                .offset(y: geometry.size.height * 0.4 - 140) // Adjust the offset based on the available space
                                .padding(.bottom, 200)
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all) // Ignore the top safe area
            }
        }
    }
}

struct ContentOverlay: View {let recipe: Recipe
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    var body: some View {
        VStack{
            HStack {
                Text(recipe.label)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(40)
                
                Button(action: {
                    if let url = URL(string: recipe.url) {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Image(systemName: "link.circle")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.green)
                        .padding()
                }
            }
            .background(Color(hex: "#E8E8E8"))
            
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Ingredients")
                        .font(.title2)
                        .bold()
                    
                    ForEach(recipe.ingredientLines, id: \.self) { line in
                        Text("• \(line)")
                    }
                }
                .padding()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Diet Labels")
                        .font(.title2)
                        .bold()
                    
                    ForEach(recipe.dietLabels, id: \.self) { line in
                        Section(header: Text("Ingredients")) {
                            Text("\(line)")
                        }
                        
                    }
                }
                .padding()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Diet Labels")
                        .font(.title2)
                        .bold()
                    
                    ForEach(recipe.dietLabels, id: \.self) { label in
                        Text("• \(label)")
                    }
                }
                .padding()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Health Labels")
                        .font(.title2)
                        .bold()
                    
                    ForEach(recipe.healthLabels, id: \.self) { label in
                        Text("• \(label)")
                    }
                }
                .padding()
                VStack(alignment: .leading, spacing: 10) {
                    Text("Cautions")
                        .font(.title2)
                        .bold()
                    
                    ForEach(recipe.cautions, id: \.self) { caution in
                        Text("• \(caution)")
                    }
                }
                .padding()
                VStack(alignment: .leading, spacing: 10) {
                    Text("Cuisine Type")
                        .font(.title2)
                        .bold()
                    
                    ForEach(recipe.cuisineType, id: \.self) { cuisine in
                        Text("• \(cuisine)")
                    }
                }
                .padding()
                VStack(alignment: .leading, spacing: 10) {
                    Text("Meal Type")
                        .font(.title2)
                        .bold()
                    
                    ForEach(recipe.mealType, id: \.self) { meal in
                        Text("• \(meal)")
                    }
                }
                .padding()
                VStack(alignment: .leading, spacing: 10) {
                    Text("Dish Type")
                        .font(.title2)
                        .bold()
                    
                    ForEach(recipe.dishType, id: \.self) { dish in
                        Text("• \(dish)")
                    }
                }
                .padding()
                .padding(.bottom, 40)
            }
            
            
            
            
        }
        .background(RoundedRectangle(cornerRadius: 25).fill(Color.white)) // Set the background with a RoundedRectangle
        .clipShape(RoundedRectangle(cornerRadius: 25)) // Clip the VStack to match the RoundedRectangle shape
        .padding()
        
    }
}

// Color extension to support hex string input
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

struct ExpandableSectionView: View {
    let title: String
    let icon: String
    let data: [String]
    @Binding var isExpanded: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button(action: {
                withAnimation(.easeInOut) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(.gray)
                        .padding(.trailing, 5)
                    Text(title)
                        .font(.headline)
                        .bold()
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
            }
            
            if isExpanded {
                ForEach(data, id: \.self) { value in
                    Text("• \(value)")
                }
            }
        }
    }
}
// Add this code at the bottom of your RecipeDetailView.swift file

struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleRecipe = Recipe(
            label: "Pickle, jam and chutney",
            image: "https://bakeitwithlove.com/wp-content/uploads/2022/10/types-of-pasta-sq.jpg",
            url: "https://www.example.com",
            ingredientLines: [
                "1 cup flour",
                "1/2 cup sugar",
                "1/4 cup cocoa powder",
                "1/2 tsp baking powder",
                "1/4 tsp salt"
            ],
            dietLabels: ["High-Protein", "Low-Carb"],
            healthLabels: ["Vegetarian", "Peanut-Free"],
            cautions: ["Sulfite-Free"],
            
            cuisineType: ["Italian"],
            mealType: ["Dinner"],
            dishType: ["Main course"]
        )
        
        RecipeDetailView(recipe: sampleRecipe)
    }
}

