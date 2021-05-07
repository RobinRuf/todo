//
//  Item.swift
//  ToDo
//
//  Created by Robin Ruf on 29.12.20.
//

import Foundation

class Item: Codable { // Protocal "Codable" muss implementiert werden, da wir die Daten dieser Klasse die im Array gespeichert werden per NSCoder speichern wollen und wir dem ENCODER sagen müssen, dass die Instanzen (Objekte) dieser Klasse "Codable" sind.
    
    // Eigenschaften
    var title: String
    var done: Bool = false // normalerweise auf FALSE, da die Aufgabe bestimmt noch nicht erledigt ist
    var isImportant: Bool = false // standartmässig auf FALSE, da man es manuell auf WICHTIG schalten muss
    
    var time: String
    var date: String
    
    // init
    init(title: String) {
        self.title = title
        
        // Instanz (Object) vom Typ "DateFormatter()" um Zeit und Datum zu erstellen
        let formatter = DateFormatter()
        
        // Zeit
        formatter.dateFormat = "hh:mm"
        time = " um \(formatter.string(from: Date())) Uhr" // "Date" ist eine Class (Struct) welche im Typ String die Uhrzeit in unsere erstellte Variable "time" speichert
        
        // Datum
        formatter.dateFormat = "dd.MM.yy"
        formatter.locale = Locale(identifier: "de_DE") // setzt das Datumformat auf DEUTSCHLAND
        date = "Erstellt am \(formatter.string(from: Date()))" // gleich wie bei der Zeit, durch "Date()" speichert man das Datum im String-Format in die von uns erstellte Variable "date"
    }
    
    // Methoden
}
