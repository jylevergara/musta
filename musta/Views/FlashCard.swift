import SwiftUI

struct FlashCard: View {
    let phrase: String
    let translation: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(phrase)
                .font(.title)
                .fontWeight(.medium)
                .multilineTextAlignment(.leading)
            
            Text(translation)
                .font(.title2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(minHeight: 150)
        .padding(20)
        .background(Color(red: 0.98, green: 0.92, blue: 0.84)) // antiquewhite
        .cornerRadius(12)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    FlashCard(
        phrase: "Magandáng áraw.",
        translation: "Good day"
    )
    .padding()
}
