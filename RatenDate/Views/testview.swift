import SwiftUI

struct TestView: View {
    @State private var selectedDate: Date? = nil
    @State private var isPickerPresented = false
    let eighteenYearsAgo: Date
    let oneHundredYearsAgo: Date

    init() {
        let calendar = Calendar.current
        eighteenYearsAgo = calendar.date(byAdding: .year, value: -18, to: Date()) ?? Date()
        oneHundredYearsAgo = calendar.date(byAdding: .year, value: -100, to: Date()) ?? Date()
    }

    var body: some View {
        VStack {
            Text("Select a Date")
                .font(.headline)

            Button(action: {
                self.isPickerPresented.toggle()
            }) {
                HStack {
                    if let selectedDate = selectedDate {
                        Text("Selected: \(selectedDate, formatter: dateFormatter)")
                    } else {
                        Text("No Date Selected")
                    }
                    Spacer()
                    Image(systemName: "calendar")
                }
            }
            .padding()

            if isPickerPresented {
                DatePicker(
                    "Select Date",
                    selection: Binding(
                        get: { self.selectedDate ?? eighteenYearsAgo },
                        set: { self.selectedDate = $0 }
                    ),
                    in: oneHundredYearsAgo...eighteenYearsAgo,
                    displayedComponents: .date
                )
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
            }
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    return formatter
}()

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
