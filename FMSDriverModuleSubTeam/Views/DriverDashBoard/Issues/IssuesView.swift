import SwiftUI

struct IssuesView: View {
    
    @State private var issueVM = IssuesViewModel()
    
    var body: some View {
        
        NavigationStack {
            
            VStack(alignment: .leading, spacing: 8) {
                
                // Header
                
                Text("Reported Issues")
                    .font(.system(size: 32, weight: .bold))
                    .padding(.top, 10)
                
                Text("Issue Logs")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.secondary)
                
                // Search
                
                HStack(spacing: 12) {
                    
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                    
                    TextField(
                        "Search issues",
                        text: $issueVM.searchText
                    )
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 14)
                .background(in: RoundedRectangle(cornerRadius: 16))
                // Scroll Only Data
                
                ScrollView(showsIndicators: false) {
                    
                    LazyVStack(spacing: 18) {
                        
                        ForEach(issueVM.filteredIssues) { issue in
                            
                            IssueCardView(issue: issue)
                        }
                    }
                    .padding(.top, 4)
                    .padding(.bottom, 24)
                }
                .frame(maxHeight: .infinity)
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            
        } //navstack
    }
}

#Preview {
    IssuesView()
}
