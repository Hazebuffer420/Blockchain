Group 8
LadeSaeule Smart Contract
Ein Ethereum-Smart-Contract für eine einfache Ladesäulen-Simulation mit Berechtigungsmanagement, Guthabenverwaltung und Ladevorgang-Historie.

Voraussetzungen
Remix IDE im Browser öffnen

Remix VM aktivieren

Deployment-Anleitung
Öffne Remix IDE und füge den Contract in eine neue .sol-Datei ein.

Wähle im linken Menü unter Solidity Compiler:

Compiler-Version: ^0.8.0 oder kompatibel

Klicke auf Compile

Gehe zu Deploy & Run Transactions:

Environment: z. B. Remix VM (London) oder Injected Provider (MetaMask)

Contract: LadeSaeule

Klicke auf Deploy

Funktionen
Nur Betreiber (Deploy-Adresse)
setBerechtigung(address nutzer, bool status)
→ Nutzer für das Laden autorisieren oder sperren

setPreisProKWh(uint256 preisInEth)
→ Preis pro kWh festlegen (z. B. 0.02 für 0.02 ETH/kWh)

auszahlen()
→ gesamtes Contract-Guthaben an Betreiber auszahlen

Nutzer
einzahlen()
→ ETH einzahlen (z. B. 1 ETH) per Value-Feld bei Funktionsausführung

ladeStarten(uint256 kWh)
→ Ladevorgang starten (nur wenn berechtigt & genug Guthaben)

benutzerAuszahlen()
→ eigenes Restguthaben abheben

guthabenInEth(address)
→ Guthaben in ETH (ganz & 4 Nachkommastellen) anzeigen

ladeHistorie(uint index)
→ Details zu einem Ladevorgang anzeigen

ladeHistorieAnzahl()
→ Anzahl gespeicherter Ladevorgänge

Hinweise
Preise und Guthaben werden intern in ETH verwaltet.

Berechtigungen müssen vor dem Laden durch den Betreiber gesetzt werden.

Demo Video anschauen oder Hazebuffer420 schreiben 
