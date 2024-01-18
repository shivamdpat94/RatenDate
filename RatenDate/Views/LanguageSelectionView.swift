//
//  LanguageSelectionView.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/15/24.
//

import SwiftUI

struct LanguageSelectionView: View {
    
    
    
    @Binding var languages: [String]
    var onNext: () -> Void

    let languagesOptions = [
        "Afrikaans", "Albanian", "Amharic", "Arabic", "Armenian", "Azerbaijani",
        "Basque", "Belarusian", "Bengali", "Bosnian", "Bulgarian", "Burmese",
        "Catalan", "Cebuano", "Chichewa", "Chinese (Simplified)", "Chinese (Traditional)",
        "Corsican", "Croatian", "Czech", "Danish", "Dutch", "English", "Esperanto",
        "Estonian", "Farsi", "Filipino", "Finnish", "French", "Frisian", "Galician",
        "Georgian", "German", "Greek", "Gujarati", "Haitian Creole", "Hausa", "Hawaiian",
        "Hebrew", "Hindi", "Hmong", "Hungarian", "Icelandic", "Igbo", "Indonesian",
        "Irish", "Italian", "Japanese", "Javanese", "Kannada", "Kazakh", "Khmer",
        "Kinyarwanda", "Korean", "Kurdish", "Kyrgyz", "Lao", "Latin", "Latvian",
        "Lithuanian", "Luxembourgish", "Macedonian", "Malagasy", "Malay", "Malayalam",
        "Maltese", "Maori", "Marathi", "Mongolian", "Nepali", "Norwegian", "Odia (Oriya)",
        "Pashto", "Persian", "Polish", "Portuguese", "Punjabi", "Romanian", "Russian",
        "Samoan", "Scots Gaelic", "Serbian", "Sesotho", "Shona", "Sindhi", "Sinhala",
        "Slovak", "Slovenian", "Somali", "Spanish", "Sundanese", "Swahili", "Swedish",
        "Tajik", "Tamil", "Tatar", "Telugu", "Thai", "Turkish", "Turkmen", "Ukrainian",
        "Urdu", "Uyghur", "Uzbek", "Vietnamese", "Welsh", "Xhosa", "Yiddish", "Yoruba", "Zulu"
    ]
    
    
    
    
    
    var body: some View {
        List {
            Section(header: Text("What Languages Do You Speak?")) {
                ForEach(languagesOptions, id: \.self) { language in
                    MultipleSelectionRow(title: language, isSelected: languages.contains(language)) {
                        if languages.contains(language) {
                            languages.removeAll { $0 == language }
                        } else {
                            languages.append(language)
                        }
                    }
                }
            }
        }
        Button("Next") {
            onNext()
        }
    }
}
// Define a row for multiple selection
struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
            }
        }
        .onTapGesture {
            action()
        }
    }
}
struct LanguageSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        LanguageSelectionView(
            languages: .constant(["English", "Spanish"]),
            onNext: { /* Define what happens when 'Next' is tapped, if needed for the preview */ }
        )
    }
}
