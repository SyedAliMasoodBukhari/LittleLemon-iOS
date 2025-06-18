import SwiftUI

@main
struct LittleLemonApp_CapstoneApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            OnBoardingView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
