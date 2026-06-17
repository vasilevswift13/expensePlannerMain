//
//  ExpenseContentView.swift
//  ExpensePlanner
//
//  Created by Igor Lebedev on 05.05.2026.
//

import SwiftUI

struct ExpenseContentView: View {

    @Environment(\.modelContext) private var modelContext

    var body: some View {
        let viewModel = ExpensePlannerViewModel(context: modelContext)
        ExpensePlannerView(viewModel: viewModel)
    }
}
