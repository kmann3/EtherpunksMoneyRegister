import SwiftUI
import QuickLook

struct EditTransactionDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) var modelContext

    @Binding var path: NavigationPath
    
    @State private var transactionName: String
    @State private var transactionAmount: String
    @State private var transactionType: TransactionType
    @State private var transactionPendingDate: Date?
    @State private var transactionClearedDate: Date?
    @State private var selectedTags: [Tag]
    @State private var transactionNotes: String
    @State private var transactionFiles: [AccountTransactionFile]
    @State private var transactionCreatedOnDate: Date
    
    @State private var availableTags: [Tag]
    
    @State private var newTagName: String = ""
    @State private var url: URL?
    @State private var isShowingDeleteActions = false
    @State private var fileToDelete: Account? = nil
    
    private let createdOnDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
    
    var transaction: AccountTransaction
    
    var isNewTransaction: Bool = false
    
    init(transaction: AccountTransaction, availableTags: [Tag], path: Binding<NavigationPath>) {
        self.transaction = transaction
        self._path = path
        _transactionName = State(initialValue: transaction.name)
        _transactionAmount = State(initialValue: "\(transaction.amount)")
        _transactionType = State(initialValue: transaction.transactionType)
        _transactionPendingDate = State(initialValue: transaction.pending)
        _transactionClearedDate = State(initialValue: transaction.cleared)
        _selectedTags = State(initialValue: transaction.tags ?? [])
        _availableTags = State(initialValue: availableTags)
        _transactionNotes = State(initialValue: transaction.notes)
        _transactionFiles = State(initialValue: transaction.files ?? [])
        _transactionCreatedOnDate = State(initialValue: transaction.createdOn)
        
        if(transaction.name == "") {
            isNewTransaction = true
        }
    }
    
    var body: some View {
            Form {
                Section(header: Text("Transaction Details")) {
                    TextField("Name", text: $transactionName)
                    TextField("Amount", text: $transactionAmount)
                        #if os(iOS)
                        .keyboardType(.decimalPad)
                        #endif
                    // Transaction type
                        NullableDatePicker(name: "Pending", selectedDate: $transactionPendingDate)
                    NullableDatePicker(name: "Cleared", selectedDate: $transactionClearedDate)
                }
                
                Section(header: Text("Tags")) {
                    List(availableTags, id: \.self) { tag in
                        MultipleSelectionRow(tag: tag, isSelected: selectedTags.contains(tag)) {
                            if selectedTags.contains(tag) {
                                selectedTags.removeAll { $0 == tag }
                            } else {
                                selectedTags.append(tag)
                            }
                        }
                    }
                    HStack {
                        TextField("New Tag", text: $newTagName)
                        Button(action: addNewTag) {
                            Text("Add")
                        }
                        .disabled(newTagName.isEmpty)
                    }
                }
                
                Section(header: Text("Misc")) {
                    // Is tax related
                    
                    // Confirmation number
                    
                    // Notes
                    TextField("Notes", text: $transactionNotes, axis: .vertical)
                        .lineLimit(2...4)
                    // bank transaction text
                }
                
                Section(header: Text("Files")) {
                    // Files Count
                    
                    HStack {
                        Button(action: addNewDocument) {
                            Text("Add Document")
                        }
                        
                        Spacer()
                        
                        Button(action: addNewPhoto) {
                            Text("Add Photo")
                        }
                        
                    }
                    
                    List {
                        if(transactionFiles.count > 0) {
                            ForEach(transactionFiles) { file in
                                VStack(alignment: .leading) {
                                    if(file.name != file.filename) {
                                        HStack {
                                            Text("Name: \(file.name)")
                                        }
                                    }
                                    HStack {
                                        Text("Filename: \(file.filename)")
                                        Button("Filename: \(file.filename)") {
                                            url = file.url
                                        }.quickLookPreview($url)
                                    }
                                    HStack{
                                        Text("Created On: ")
                                        Text(file.createdOn, format: .dateTime.month().day())
                                        Text("@")
                                        Text(file.createdOn, format: .dateTime.hour().minute().second())
                                    }
                                    HStack {
                                        Text("Tax Document: \(file.isTaxRelated)")
                                    }
                                    HStack {
                                        Text("Notes: \(file.notes)")
                                    }
                                }
                                .swipeActions(allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        if let index = transactionFiles.firstIndex(of: file) {
                                            transactionFiles.remove(at: index)
                                        }
                                    } label: {
                                        Label("Delete", systemImage: "trash.fill")
                                    }
                                }
                            }
                        }
                    }
                }
                
                
                // Account
                
                // Recurring Transaction
                
                // Created On Read only
                HStack {
                    Text("Created on:")
                    Text(transactionCreatedOnDate, format: .dateTime.month().day().year())
                    Text("@")
                    Text(transactionCreatedOnDate, format: .dateTime.hour().minute().second())
                }
                .listRowBackground(Color(.sRGB, red: 210/255, green: 210/255, blue: 210/255, opacity: 0.5))
            }
            #if os(iOS)
            .navigationBarTitle(isNewTransaction ? "New Transaction" : "Edit Transaction")
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button ("Save") {
                        withAnimation {
                            saveTransaction()
                        }
                    }
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button ("Cancel", role: .cancel) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
            }
        }
    
    
    func addNewTag() {
        let newTag = Tag(name: newTagName)
        availableTags.append(newTag)
        selectedTags.append(newTag)
        modelContext.insert(newTag)
        newTagName = ""
    }
    
    func addNewDocument() {
        
    }
    
    func addNewPhoto() {
        
    }
    
    func saveTransaction() {
        guard let amount = Decimal(string: transactionAmount) else { return }
        
        // CHECK TO SEE IF THE AMOUNT HERE HAS CHANGED FROM THE TRANSACTION AMOUNT
        // IF IT HAS THEN WE NEED TO RE-CALCULATE THE BALANCE!
        
        if(amount != transaction.amount) {
            print("NEED TO CHANGE BALANCE")
            // Setting to zero to make sure it's stupidly obvious things need to change
            transaction.balance = 0
        }
        
        if(transactionType != transaction.transactionType) {
            // WE NEED TO REBALANCE
            // Need to make a function where we can call up and reference a transaction of previous value and new value and have it go through the rest of the transactions
        }
        
        transaction.name = transactionName
        transaction.amount = amount
        transaction.pending = transactionPendingDate
        transaction.cleared = transactionClearedDate
        transaction.tags = selectedTags
        transaction.notes = transactionNotes
        
        // how do I know if the files are new? Or need to be removed?
        
        transaction.files = transactionFiles
        
        do {
            if(isNewTransaction) {
                modelContext.insert(transaction)
            }
            try modelContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error saving transaction: \(error)")
        }
    }
}

struct MultipleSelectionRow: View {
    var tag: Tag
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        HStack {
            Text(tag.name)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(.blue)
            }
        }
        .background(isSelected ? Color(.sRGB, red: 25/255, green: 125/255, blue: 220/255, opacity: 0.5) : Color.clear)
        .contentShape(Rectangle())
        .onTapGesture(perform: action)
    }
}

#Preview {
    
    do {
        
        let previewer = try Previewer()
        return EditTransactionDetailView(transaction: previewer.cvsTransaction, availableTags: [previewer.billsTag, previewer.medicalTag, previewer.pharmacyTag], path: .constant(NavigationPath()))
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed: \(error.localizedDescription)")
    }
}
