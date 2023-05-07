import SwiftUI
import URLImage

struct RecipeDetailView: View {
    
    let recipe: Recipe
    
    @State private var showDetails: [Bool] = Array(repeating: false, count: 7)
    
    var body: some View {
            ScrollView {
                VStack {
                    HStack(alignment: .top) {
                        if let imageURL = URL(string: recipe.image) {
                            URLImage(imageURL) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.width)
                                    .clipped()
                            }
                            .edgesIgnoringSafeArea(.all) // Ignore safe area edges for the image
                        }
                    }
                    ContentOverlay(recipe: recipe)
                        .padding(.bottom, 100)
                }
            }
        }
}

struct ContentOverlay: View { let recipe: Recipe
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var firebaseManager: FirebaseManager
    
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
                
                VStack{
                    Button(action: { // LINK
                        if let url = URL(string: recipe.url) {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Image(systemName: "link.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    Button(action: { // SAVE BUTTON
                        if appState.isRecipeSaved(recipe) {
                            if let existingRecipe = appState.savedRecipes.first(where: { $0.label == recipe.label }) {
                                appState.savedRecipes.remove(existingRecipe)
                                firebaseManager.removeRecipe(existingRecipe)
                            }
                        } else {
                            appState.savedRecipes.insert(recipe)
                            firebaseManager.saveRecipe(recipe)
                        }
                    }) {
                        Image(systemName: appState.isRecipeSaved(recipe) ? "bookmark.fill" : "bookmark")
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                            .padding()
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                
            }
            .background(Color(hex: "#A99A9A"))
            
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Ingredients")
                        .font(.title2)
                        .bold()
                    
                    ForEach(recipe.ingredientLines, id: \.self) { line in
                        Text("• \(line)")
                            .lineLimit(nil) // Remove the line limit
                            .fixedSize(horizontal: false, vertical: true) // Allow the text to wrap vertically
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.70)
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
        .background(RoundedRectangle(cornerRadius: 25).fill(Color(hex: "#F4F4F4"))) // Set the background with a RoundedRectangle
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

