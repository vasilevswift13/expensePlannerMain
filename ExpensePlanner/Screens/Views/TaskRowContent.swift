
import SwiftUI



struct TaskRowContent: View {
    let task: TodoTask
    
    
    private let categoryEmoji: [String: String] = [
        "Еда": "🍔",
        "Транспорт": "🚗",
        "Развлечения": "🎬",
        "Здоровье": "🧘‍♂️",
        "Дом": "🏠",
        "Работа": "💼"
    ]
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(task.title)
                .font(.headline)
                .strikethrough(task.isCompleted, color: .gray)
                .foregroundColor(task.isCompleted ? .gray : .primary)
            
            HStack(spacing: 8) {
                if task.category != "other" {
                    HStack(spacing: 4) {
                        Text(categoryEmoji[task.category] ?? "📌")
                        Text(task.category)
                            .font(.caption)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(4)
                }
                if !task.taskDescription.isEmpty {
                    Text(task.taskDescription)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            Text(task.cost.moneyText)
                .font(.subheadline)
                .foregroundColor(task.isCompleted ? .gray : .primary)
        }
        
        .padding(.vertical, 4)
        .padding(.horizontal, 12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
//        .cardStyle()
    }
    
}

