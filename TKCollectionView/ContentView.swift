//
//  ContentView.swift
//  TKCollectionView
//
//  Created by 임정운 on 2022/11/07.
//
//

import SwiftUI
import CoreData

private extension ContentView {
    var _appTitle1: some View {
        VStack {
            Text("App Name - first")
                .font(.title)
                .fontWeight(.medium)
                .foregroundColor(.red)
                .padding()
            
        }.frame(minHeight: 60, alignment: .center)
    }
}

struct AppTitle: View {
    var body: some View {
        VStack {
            Text("App Name - second")
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.blue)
                .padding()
            
        }.frame(minHeight: 60, alignment: .center)
    }
}

struct TKTextField: View {
    @Binding private var emailAddress: String
    
    init(email emailAddress: Binding<String>) {
        self._emailAddress = emailAddress
    }
    
    var body: some View {
        HStack {
            Image(systemName: "envelope").frame(width: 20.0, height: 20.0)
            TextField("e-mail address", text: $emailAddress)
                .frame(width: .greatestFiniteMagnitude, height: 60.0, alignment: .center)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).strokeBorder())
        }
        .background(.blue)
    }
}

enum TKContentTextFieldType {
    case TKNormalTextField
    case TKSecureTextField
}

struct TKContentTextField: View {
    @State public var type: TKContentTextFieldType
    @State private var email: String = ""
    @State private var passcode: String = ""
    
    public var iconName: String = ""
    public var placeholder: String = ""
    
    init(iconName: String, placeholder: String) {
        self.type = .TKNormalTextField
        self.iconName = iconName
        self.placeholder = placeholder
    }
    
    var body: some View {
        HStack(spacing: 0.0) {
            Image(systemName: self.iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30.0, height: 30.0)
                .foregroundColor(Color(uiColor: .lightGray))
                .padding([.top, .bottom], 0)
                .padding([.leading, .trailing], 10.0)
            
            switch self.type {
            case.TKNormalTextField:
                TextField(text: $email) {
                    Text(self.placeholder)
                        .foregroundColor(Color(uiColor: .lightGray))
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                }
                
            case .TKSecureTextField:
                SecureField(text: $passcode) {
                    Text(self.placeholder)
                        .foregroundColor(Color(uiColor: .lightGray))
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                }
            }
            
        }
        .frame(maxHeight: 50.0, alignment: .center)
        .overlay(
            RoundedRectangle(cornerRadius: 7.0)
                .stroke(.gray, lineWidth: 1.2)
        )
        .background(Color(uiColor: .secondarySystemBackground))
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext)
    private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)], animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        VStack(spacing: 10.0) {
            TKContentTextField(iconName: "envelope.circle", placeholder: "E-mail address")
            TKContentTextField(iconName: "lock.circle", placeholder: "Passcode")
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding([.leading, .trailing], 10.0)
    }

    
    
    
    
    
    
    
    //        NavigationView {
    //            List {
    //                ForEach(items) { item in
    //                    NavigationLink {
    //                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
    //                    } label: {
    //                        Text(item.timestamp!, formatter: itemFormatter)
    //                    }
    //                }
    //                .onDelete(perform: deleteItems)
    //            }
    //            .toolbar {
    //                ToolbarItem(placement: .navigationBarTrailing) {
    //                    EditButton()
    //                }
    //                ToolbarItem {
    //                    Button(action: addItem) {
    //                        Label("Add Item", systemImage: "plus")
    //                    }
    //                }
    //            }
    //        }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
