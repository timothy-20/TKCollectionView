//
//  TKCollectionViewApp.swift
//  TKCollectionView
//
//  Created by 임정운 on 2022/11/07.
//
//

import SwiftUI

@main
struct TKCollectionViewApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
