//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Igor Florentino on 03/08/24.
//

//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Igor Florentino on 03/08/24.
//

import SwiftUI

struct ContentView: View {
	let resorts: [Resort] = Bundle.main.decode("resorts.json")
	@State private var searchText = ""
	@State private var favorites = Favorites()
	@State private var sortType: SortType = .defaultOrder
	
	enum SortType: String, CaseIterable, Identifiable {
		case defaultOrder = "Default"
		case alphabetical = "Alphabetical"
		case country = "Country"
		
		var id: SortType { self }
	}
	
	var filteredResorts: [Resort] {
		let sortedResorts: [Resort]
		switch sortType {
		case .defaultOrder:
			sortedResorts = resorts
		case .alphabetical:
			sortedResorts = resorts.sorted { $0.name < $1.name }
		case .country:
			sortedResorts = resorts.sorted { $0.country < $1.country }
		}
		
		if searchText.isEmpty {
			return sortedResorts
		} else {
			return sortedResorts.filter { $0.name.localizedStandardContains(searchText) }
		}
	}
	
	var body: some View {
		NavigationSplitView {
			VStack {
				Picker("Sort by", selection: $sortType) {
					ForEach(SortType.allCases) { sortType in
						Text(sortType.rawValue).tag(sortType)
					}
				}
				.pickerStyle(SegmentedPickerStyle())
				.padding()
				
				List(filteredResorts) { resort in
					NavigationLink(value: resort) {
						HStack {
							Image(resort.country)
								.resizable()
								.scaledToFill()
								.frame(width: 40, height: 25)
								.clipShape(
									.rect(cornerRadius: 5)
								)
								.overlay(
									RoundedRectangle(cornerRadius: 5)
										.stroke(.black, lineWidth: 1)
								)
							
							VStack(alignment: .leading) {
								Text(resort.name)
									.font(.headline)
								Text("\(resort.runs) runs")
									.foregroundStyle(.secondary)
							}
							if favorites.contains(resort) {
								Spacer()
								Image(systemName: "heart.fill")
									.accessibilityLabel("This is a favorite resort")
									.foregroundStyle(.red)
							}
						}
					}
				}
				.navigationTitle("Resorts")
				.navigationDestination(for: Resort.self) { resort in
					ResortView(resort: resort)
				}
				.searchable(text: $searchText, prompt: "Search for a resort")
			}
		} detail: {
			WelcomeView()
		}
		.environment(favorites)
	}
}

#Preview {
	ContentView()
}

#Preview {
    ContentView()
}
