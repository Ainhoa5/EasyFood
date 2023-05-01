import SwiftUI

struct FilterView: View {
    // toggle
    @State private var showMealTypes: Bool = false
    @State private var showDishTypes: Bool = false
    @State private var showDietTypes: Bool = false
    @State private var showHealthTypes: Bool = false
    
    @EnvironmentObject var appState: AppState
    @StateObject private var firebaseManager = FirebaseManager()
    
    var body: some View {
        NavigationView {
            List {
                // Meal Types section
                Section() {
                    HStack{
                        Image("meal")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text("Meal Types")
                            .font(.title)
                    }
                    .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    .padding(.leading, 100)
                    .onTapGesture {
                        showMealTypes.toggle()
                    }
                    
                    
                    if showMealTypes {
                        ForEach(appState.mealTypes) { mealType in
                            Text(mealType.name)
                        }
                    }
                }
                .padding(.leading)
                .padding(.trailing)
                
                // Dish Types section
                Section() {
                    HStack{
                        Image("dish")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text("Dish Types")
                            .font(.title)
                    }
                    .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    .padding(.leading, 100)
                    .onTapGesture {
                        showDishTypes.toggle()
                    }
                    
                    if showDishTypes {
                        ForEach(appState.dishTypes) { dishType in
                            Text(dishType.name)
                        }
                    }
                }
                .padding(.leading)
                .padding(.trailing)
                
                // Diet Types section
                Section() {
                    HStack{
                        Image("diet")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text("Diet Types")
                            .font(.title)
                    }
                    .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    .padding(.leading, 100)
                    .onTapGesture {
                        showDietTypes.toggle()
                    }
                    .background(.white)
                    
                    if showDietTypes {
                        ForEach(appState.dietTypes) { dietType in
                            Text(dietType.name)
                        }
                    }
                }
                .padding(.leading)
                .padding(.trailing)
                
                // Health Types section
                Section() {
                    HStack{
                        Image("health")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text("Health Types")
                            .font(.title)
                    }
                    .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    .padding(.leading, 100)
                    .onTapGesture {
                        showHealthTypes.toggle()
                    }
                    .background(.white)
                    
                    if showHealthTypes {
                        ForEach(appState.health) { healthType in
                            Text(healthType.name)
                        }
                    }
                }
                .padding(.leading)
                .padding(.trailing)
            }
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView().environmentObject(AppState())
    }
}
