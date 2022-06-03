//
//  AppView.swift
//  Test
//
//  Created by Ivan Ruiz Monjo on 3/6/22.
//

import ComposableArchitecture
import SwiftUI

enum AppError: Error {
	case unkown
}

struct User: Equatable {
	let username: String
}

struct AppState: Equatable {
	var updateUser: UpdateUserState?
  var isUpdateUserViewPresented: Bool { updateUser != nil }
	var user: User?
}
enum AppAction: Equatable {
	case setUpdateUserSheet(isPresented: Bool)
	case updateUser(UpdateUserAction)
}

struct AppEnvironment {}

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, env in
	switch action {
	case .setUpdateUserSheet(let isPresented):
    if isPresented {
      state.updateUser = .init(user: state.user)
    } else {
      state.updateUser = nil
    }
		return .none
	case .updateUser(.userUpdated(.success(let user))):
		state.user = user
    return Effect(value: .setUpdateUserSheet(isPresented: false))
	default:
		return .none
	}
}

struct AppView: View {
	let store: Store<AppState, AppAction>

    var body: some View {
		WithViewStore(store) { viewStore in
      VStack {
        if let user = viewStore.user {
          HStack {
            Text("User:")
            Text(String(describing: user))
          }
        }
        Text("Tap me to show a modal that you can set the user username and open it again and update it 😅")
        .onTapGesture {
          viewStore.send(.setUpdateUserSheet(isPresented: true))
        }
      }
			.sheet(
				isPresented: viewStore.binding(
					get: \.isUpdateUserViewPresented,
					send: AppAction.setUpdateUserSheet(isPresented:)
				)
			) {
				IfLetStore(store.scope(state: \.updateUser, action: AppAction.updateUser)) { store in
					UpdateUserView(store: store)
				}

			}
		}
    }
}


