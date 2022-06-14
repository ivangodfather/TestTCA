//
//  AppView.swift
//  Test
//
//  Created by Ivan Ruiz Monjo on 3/6/22.
//

import ComposableArchitecture
import SwiftUI

struct Item: Equatable, Identifiable {
	let title: String
	var id: String { title }
}

struct AppState: Equatable {
	var itemStates: IdentifiedArrayOf<ItemState> = [
		.init(item: .init(title: "First")),
		.init(item: .init(title: "Second")),
		.init(item: .init(title: "Third")),
	]
}
enum AppAction: Equatable {
	case itemAction(id: Item.ID, action: ItemAction)
}

struct AppEnvironment {}

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, env in
		.none
}

struct AppView: View {
	let store: Store<AppState, AppAction>

	var body: some View {
		WithViewStore(store) { viewStore in
			NavigationView {
				VStack {
					ForEachStore(
						self.store.scope(state: \.itemStates, action: AppAction.itemAction(id:action:))
					) { childStore in
						WithViewStore(childStore) { childViewStore in
							NavigationLink(
								destination: ItemDetailView(store: childStore)
							) {
								Text(childViewStore.item.title)
							}
						}
					}
				}
			}
		}
	}
}

struct ItemState: Equatable, Identifiable {
	var item: Item
	var id: String { item.title }
}

enum ItemAction: Equatable {
}

struct ItemDetailView: View {
	let store: Store<ItemState, ItemAction>

	var body: some View {
		WithViewStore(store) { viewStore in
			VStack {
				Text(viewStore.item.title)
			}
		}
	}
}
