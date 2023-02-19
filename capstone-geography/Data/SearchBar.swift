//  SearchBar.swift
//  capstone-geography

// Import the SwiftUI framework
import SwiftUI

// Define the SearchBar struct, which implements the View protocol
struct SearchBar: View {

    //Bind to text in searchbar
    @Binding var text: String

    @State private var isEditing = false

    var body: some View {
        HStack {
            //Actual searchbar
            TextField("Search", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
                //Magnifier and cancel button
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)

                        //Clear text button
                        if isEditing {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true //Enable searchbar if its tapped
                }

            if isEditing {
                //Cancel Button functionality
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                    //Dismiss the keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
}
