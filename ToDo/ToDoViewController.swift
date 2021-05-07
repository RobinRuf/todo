//
//  ViewController.swift
//  ToDo
//
//  Created by Robin Ruf on 29.12.20.
//

import UIKit

class ToDoViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var toDoTableView: UITableView!
    
    var itemArray = [Item]()
    
    var switchControl = UISwitch()
    
    // Erstellen des FileManagers und abspeichern in einer Konstante (erstellt den NSCoder)
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toDoTableView.delegate = self
        toDoTableView.dataSource = self
        
        loadItems()
    }
    
    // MARK: - ViewDidAppear
    
    // viewDidLoad wird nur beim ersten Mal wo die App-Seite erscheint aufgerufen
    // viewDidAppear wird JEDESMAL, wenn die App-Seite (toDoViewController) erscheint aufgerufen
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated) // muss man einfach machen, damit das was vorgegeben ist ausgeführt wird und DANACH unser eigener Code in der Methode - gleich wie bei der viewDidLoad
        
        toDoTableView.reloadData() // aktuallisiert jedesmal die Tabelle, wenn die App-Seite toDoViewController geöffnet wird
    }

    // MARK: - Add Item Button
    @IBAction func addToDoItem_tapped(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "ToDo hinzufügen", message: "", preferredStyle: .alert)
        
        // Alertbox-Text iOS 13 farblich anpassen für Darkmode
        if #available(iOS 13, *) {
            alert.view.tintColor = UIColor.label // alert.view ist die graue Alertbox an sich
        } else {
            alert.view.tintColor = UIColor.black
        }
        
        var textField = UITextField()
        
        let action = UIAlertAction(title: "ToDo erstellen", style: .default) { (action) in
            let itemObject = Item(title: textField.text!)
            
            // Prüfen, ob es WICHTIG ist oder nicht - also ob der Switch auf true oder false steht
            itemObject.isImportant = self.switchControl.isOn
            
            // Objekt der Tabelle hinzufügen
            self.itemArray.append(itemObject)
            
            // Tabelle aktuallisieren
            self.toDoTableView.reloadData()
            
            // Daten im FileManager abspeichern (NSCoder)
            self.saveItems()
        }
        
        let cancel = UIAlertAction(title: "Abbrechen", style: .default) { (cancel) in }
        
        // Textfeld hinzufügen
        alert.addTextField { (userText) in
            textField = userText
            userText.placeholder = "ToDo eintragen..."
        }
        
        // Switch hinzufügen
        alert.view.addSubview(createSwitch {})
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Create Switch for important ToDo's
    func createSwitch(completion: () -> Void) -> UISwitch {
        
        // UISwitch(frame: CGRect()) - CGRect ist auch nur eine Klasse, davon suchen wir uns den Init mit x,y,width und height für INT aus und wählen dann 10px Abstand von links, 20px von oben und wenn man width und height 0 macht, verwendet er die Standartgrösse für ein Switch
        switchControl = UISwitch(frame: CGRect(x: 10, y: 20, width: 0, height: 0))
        
        switchControl.isOn = false // damit wissen wir, dass er auf OFF ist
        switchControl.setOn(false, animated: false) // Damit sagen wir, dass wenn der Switch erstellt wird, er erstmal auf OFF sein soll, animiert muss das auch nicht sein - isOn ist nur der Status für uns als Programmierer zu wissen, setOn bestimmt, welchen Status er beim erstellen hat.
        
        switchControl.onTintColor = switchControlTintColor // Hintergrundfarbe des Switchs, wenn es ON ist
        switchControl.backgroundColor = UIColor.systemBackground // Hintergrundfarbe des Switchs, wenn es OFF ist
        switchControl.thumbTintColor = UIColor.black // Schalterfarbe des Switchs
        
        switchControl.layer.cornerRadius = 16 // zusätzliche Rundung des Randes
        switchControl.layer.borderWidth = 0.8 // Die Dicke des Randes
        switchControl.layer.borderColor = UIColor.darkGray.cgColor // Die Farbe des Randes
        
        switchControl.layer.masksToBounds = true // Sagt dem Switch, es soll in seinen Grenzlinien bleiben und ja nicht überschreiten, weils sonst einfach unsauber aussieht
        
        // Wir müssen ein addTarget machen, da wir eine Aktion/Aufgabe ausgelöst haben möchten, sobald der Switch betätigt wird  -  .valueChanged benutzt man immer bei Switchs, da ein Switch immer zwischen 2 Value (Werten) hin und her springt (true (1), false (0))
        switchControl.addTarget(self, action: #selector(switchValueDidChange(sender:)), for: .valueChanged)
        completion()
        return switchControl
    }
    
    @objc func switchValueDidChange(sender: UISwitch) {
        
    }
    
    // MARK: - Long Press / Change ToDo
    
    // Methode die definiert, was passieren soll, wenn der Nutzer die Tabellenzeile lange gedrückt hält
    @objc func longPress(sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizer.State.ended {
            // Speichern der Location, wo der User gedrückt hat (x und y Wert)
            let locationPoint = sender.location(in: self.toDoTableView)
            // Prüfen, auf welcher Tabellenzeile der Nutzer gedrückt hat
            if let pressIndexPath = self.toDoTableView.indexPathForRow(at: locationPoint) {
                
                // Textfield ausserhalb des Closures erstellen, da wir das auch ausserhalb verwenden müssen
                var userText = UITextField()
                
                let alert = UIAlertController(title: "Änderung", message: "", preferredStyle: .alert)
                
                // Alertbox-Text iOS 13 farblich anpassen für Darkmode
                if #available(iOS 13, *) {
                    alert.view.tintColor = UIColor.label // alert.view ist die graue Alertbox an sich
                } else {
                    alert.view.tintColor = UIColor.black
                }
                
                // TextField erstellen und hinzufügen
                
                alert.addTextField { (changedUserText) in
                    userText = changedUserText
                    changedUserText.placeholder = "Änderung eingeben..."
                }
                
                // Switch erstellen und hinzufügen
                alert.view.addSubview(createSwitch {
                    if self.itemArray[pressIndexPath.row].isImportant == true {
                        self.switchControl.setOn(true, animated: true)
                    } else {
                        self.switchControl.setOn(false, animated: true)
                    }
                })
                
                // Buttons erstellen und hinzufügen
                let changeAction = UIAlertAction(title: "Ändern", style: .default) { (changeAction) in
                    
                    // Text ändern
                    if !(userText.text!.isEmpty) {
                        self.itemArray[pressIndexPath.row].title = userText.text!
                    }
                    
                    // Den Status von WICHTIG oder nicht nochmals neu festlegen anhand der bei der Änderung eingegebenen Stellung des Switchs (on/off)
                    self.itemArray[pressIndexPath.row].isImportant = self.switchControl.isOn
                    
                    // Die Tabelle aktuallisieren, damit die Änderung übernommen wird
                    self.toDoTableView.reloadData()
                    
                    // Daten im FileManager abspeichern (NSCoder)
                    self.saveItems()
                }
                
                let cancelAction = UIAlertAction(title: "Abbrechen", style: .default) { (cancelAction) in }
                
                alert.addAction(changeAction)
                alert.addAction(cancelAction)
                
                // Alert schlussendlich präsentieren
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
    }
    
    // MARK: - NSCoder - save Items
    func saveItems() {
        
        // Encoder in Konstante erstellen
        let encoder = PropertyListEncoder()
        
        // Um Fehler beim encoden abzufangen benutzt man ein Do-Catch (Mach-Fang auf) Statement
        do {
            let data = try encoder.encode(itemArray) // hier wird versucht, die Daten im Array zu encoden
            try data.write(to: dataFilePath!) // Die encodeten Daten werden versucht im FileManager zu speichern
        } catch  { // Falls das nicht geht, fang etwas auf
            print(error.localizedDescription) // und zwar den Error und print mir das in ein LogFile
        }
    }
    
    // MARK: - NSCoder - load Items
    func loadItems() {
        
        // Optional Binding, weil Apple gesagt hat, dass evtl die gespeicherten Daten gelöscht werden können etc.
        if let data = try? Data(contentsOf: dataFilePath!) { // In Konstante "data" werden die Daten gespeichert die auf dem Handy gespeichert sind - mit "try?" sagt man, "versuch mal..."
        
            // Decoder in Konstante erstellen
            let decoder = PropertyListDecoder()
            
            // wieder ein Do-Catch Statement, da ein Fehler beim Auslesen passieren kann und dann soll der Fehler in die Log-Datei aufgefangen werden
            do {
                // Hier wird versucht, die Daten auszulesen und als Array wieder in das itemArray zurückzugeben
                itemArray = try decoder.decode([Item].self, from: data) // versuch aus der zuvor erstellten Konstante "data" (if let...) ein Array ([Item].self) vom Typ "Item" zu erstellen
            } catch  {
                print(error.localizedDescription)
            }
            
        }
        
    }
    
}

// MARK: - Extensions
extension ToDoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Bestimmen, was geändert werden soll, sobald man auf eine Zeile drückt
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // Tabelle aktuallisieren
        toDoTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // Prüfen, ob der Nutzer Sachen löschen möchte
        if editingStyle == .delete {
            // aus dem Array löschen
            itemArray.remove(at: indexPath.row)
            
            // und aus der Tabelle löschen
            toDoTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // ändert die Höhe der Tabellenzeilen
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0 // Jede Tabellenzeile ist nun 100px hoch
    }
    
}

extension ToDoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        
        // Tabellenzeile angeben, was da stehen soll
        let item = itemArray[indexPath.row] // hier müssen wir die Daten zwischenspeichern, die im Array stehen
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.date + item.time
        
        // Tabellenzeilenfarbe ändern
        
        if #available(iOS 13, *) { // Prüfen, ob das Gerät eine iOS Version oder neuer (*) hat
            cell.tintColor = UIColor.label // auto Anpassung Dark/Lightmode
        } else {
            cell.tintColor = UIColor.black // Da alle unter iOS 13 sowieso nur den Lightmode haben
        }
        
        
        // Prüfen ob wichtig oder nicht
        if item.isImportant == true {
            cell.backgroundColor = cellBackgroundColor
        } else {
            cell.backgroundColor = UIColor.systemBackground
        }
        
        // prüfen ob Haken gesetzt oder nicht
        if item.done == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        // Tabellenzeile drückbar machen
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(sender:))) // Recognizer = Erkenner , diese Methode erkennt, wenn der Nutzer lange auf etwas klickt
        cell.addGestureRecognizer(longPressRecognizer) // Hier müssen wir den Recognizer(Erkenner) jeder Zeile hinzufügen
        
        return cell
    }
    
    
}
