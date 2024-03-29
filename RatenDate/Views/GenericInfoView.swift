import SwiftUI
import CoreLocation

struct GenericInfoView: View {
    @Binding var name: String
    @Binding var gender: String?
    @StateObject private var locationManager = LocationManager()
    @Binding var ethnicity: String?
    @Binding var dob: Date? // Binding for Date of Birth
    @Binding var height: String? // Add this binding for height
    @State private var userInputCity: String = ""
    @Binding var location: CLLocation
    @State private var isDatePickerShown = false
    @State private var displayDate = "Not set"
    @State private var tempDate: Date = Date()

    var onNext: () -> Void
    let startDate = Calendar.current.date(byAdding: .year, value: -100, to: Date()) ?? Date()
    let endDate = Calendar.current.date(byAdding: .year, value: -18, to: Date()) ?? Date()

    // Ethnicities list
    let ethnicities: [String?] = [nil] + [
        "Akan", "Albanian", "Amhara", "Arab", "Armenian", "Ashkenazi Jewish", "Assyrian", "Aymara",
        "Azeri", "Baloch", "Bambara", "Basque", "Batak", "Belarusian", "Bemba", "Bengali", "Berber",
        "Betawi", "Bosniak", "Breton", "British", "Bulgarian", "Burmese", "Catalan", "Celtic",
        "Cherokee", "Chewa", "Chokwe", "Circassian", "Cornish", "Corsican", "Cree", "Croatian",
        "Czech", "Dane", "Dinka", "Dutch", "English", "Estonian", "Faroese", "Fijian", "Filipino",
        "Finn", "Flemish", "Fon", "French", "Frisian", "Friulian", "Fulani", "Ga", "Galician", "Ganda",
        "Georgian", "German", "Greek", "Greenlander", "Guarani", "Gujarati", "Haida", "Haitian",
        "Hakka", "Han Chinese", "Hausa", "Hawaiian", "Hazaragi", "Hmong", "Hungarian", "Iban", "Icelander",
        "Igbo", "Ijaw", "Inuit", "Irish", "Italian", "Japanese", "Javanese", "Jewish", "Kabyle", "Kalenjin",
        "Kanak", "Kannada", "Kanuri", "Kashmiri", "Kazakh", "Kikuyu", "Kinh", "Komi", "Kongo",
        "Konkani", "Korean", "Kurd", "Kyrgyz", "Lao", "Latvian", "Laz", "Lebanese", "Lezgian",
        "Ligurian", "Limbu", "Lithuanian", "Luba", "Luxembourger", "Macedonian", "Madurese", "Magahi",
        "Maithili", "Makassarese", "Malagasy", "Malay", "Malayali", "Maltese", "Manchu", "Mandinka",
        "Mansi", "Maori", "Marathi", "Marshallese", "Mazandarani", "Mende", "Mexican", "Miao",
        "Minangkabau", "Mixtec", "Moldovan", "Mongol", "Montenegrin", "Mossi", "Naga", "Nahuas",
        "Navajo", "Ndebele", "Nepali", "Newar", "Nogai", "Norman", "Norwegian", "Occitan", "Ojibwe",
        "Oromo", "Ossetian", "Papuan", "Pashtun", "Persian", "Polish", "Portuguese", "Punjabi",
        "Quechua", "Rajasthani", "Rapanui", "Roma", "Romanian", "Russian", "Ruthenian", "Sami",
        "Samoan", "Sardinian", "Scot", "Sephardi Jewish", "Serb", "Sherpa", "Shona", "Sicilian",
        "Sindhi", "Sinhalese", "Slovak", "Slovene", "Somali", "Soninke", "Sorbian", "Sotho",
        "Spanish", "Sundanese", "Swazi", "Swede", "Swiss", "Syriac", "Tajik", "Tamil", "Tatar",
        "Telugu", "Tibetan", "Tigre", "Tigrinya", "Tongan", "Tswana", "Tuareg", "Tulu", "Turk",
        "Turkmen", "Tutsi", "Tyrolean", "Udmurt", "Uighur", "Ukrainian", "Urdu-speaking", "Uzbek",
        "Venda", "Vietnamese", "Volga German", "Welsh", "Wolof", "Xhosa", "Yakut", "Yi", "Yoruba",
        "Zapotec", "Zulu", "Other"
    ]

    let genders: [String?] = [nil, "Male", "Female"]



    // Heights range
    let heights: [String?] = [nil] + (48...96).map { "\($0 / 12)' \($0 % 12)\"" } // Heights from 4'0" to 8'0"
//    init(name: Binding<String>, gender: Binding<String?>, ethnicity: Binding<String?>, dob: Binding<Date?>, height: Binding<String?>, location: Binding<CLLocation>, onNext: @escaping () -> Void) {
//        self._name = name
//        self._gender = gender
//        self._ethnicity = ethnicity
//        self._dob = dob
//        self._height = height
//        self._location = location
//        self.onNext = onNext
//        let endDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())!
//        self._tempDate = State(initialValue: dob.wrappedValue ?? endDate)
//    }
    var body: some View {
        Form {
            Section(header: Text("Generic Information")) {
                TextField("Name", text: $name)

                // Ethnicity Picker
                Picker("Ethnicity", selection: $ethnicity) {
                    Text("Select Ethnicity").tag(String?.none)
                    ForEach(ethnicities.compactMap { $0 }, id: \.self) { ethnicity in
                        Text(ethnicity).tag(ethnicity as String?)
                    }
                }

                // Height Picker
                Picker("Height", selection: $height) {
                    Text("Select Height").tag(String?.none)
                    ForEach(heights.compactMap { $0 }, id: \.self) { height in
                        Text(height).tag(height as String?)
                    }
                }
                
                
                Button(action: {
                    isDatePickerShown.toggle()
                }) {
                    HStack {
                        Text("Date of Birth")
                        Spacer()
                        Text(displayDate)
                            .foregroundColor(.gray)
                    }
                }

                // DatePicker and Select button
                if isDatePickerShown {
                    DatePicker(
                        "Select Date of Birth",
                        selection: $tempDate,
                        in: startDate...endDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(WheelDatePickerStyle())

                    Button("Select") {
                        self.dob = self.tempDate
                        self.displayDate = self.tempDate.formatted(date: .long, time: .omitted)
                        self.isDatePickerShown = false
                    }
                }

                // Gender Picker
                Picker("Gender", selection: $gender) {
                    Text("Select Gender").tag(String?.none)
                    ForEach(genders.compactMap { $0 }, id: \.self) { gender in
                        Text(gender).tag(gender as String?)
                    }
                }
                
                HStack {
                    // Location TextField
                    TextField("City", text: $userInputCity)
                        .onReceive(locationManager.$placemark) { placemark in
                            if let city = placemark?.locality, let state = placemark?.administrativeArea {
                                userInputCity = "\(city), \(state)"
                            }
                        }
                        .onReceive(locationManager.$location) { newLocation in
                            if let newLocation = newLocation {
                                self.location = newLocation
                            }
                        }
                }
            }

            Button("Next") {
    
                onNext()
            }
        }
        .onAppear {
            locationManager.requestPermission()
        }
    }
}

struct GenericInfoView_Previews: PreviewProvider {
    @State static var dummyLocation = CLLocation(latitude: 40.7128, longitude: -74.0060)
    @State static var dummyName = "John Doe"
    @State static var dummyEthnicity: String?
    @State static var dummyHeight: String?
    @State static var dummyGender: String?
    @State static var dummyDOB: Date? = nil // Changed to be an optional Date

    static var previews: some View {
        GenericInfoView(
            name: $dummyName,
            gender: $dummyGender,
            ethnicity: $dummyEthnicity,
            dob: $dummyDOB,
            height: $dummyHeight,
            location: $dummyLocation,
            onNext: {}
        )
    }
}
