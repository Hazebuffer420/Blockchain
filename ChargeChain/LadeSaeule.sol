// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LadeSaeule {
    address public betreiber;
    uint256 public preisProKWhWei = 0.01 ether; // Preis pro kWh in Wei

    mapping(address => bool) public berechtigt;
    mapping(address => uint256) private guthaben; // Guthaben in Wei

    event LadevorgangGestartet(address nutzer, uint256 kWh, uint256 betragWei);
    event Einzahlung(address nutzer, uint256 betragWei);
    event Auszahlung(address nutzer, uint256 betragWei);

    // Ladevorgangs-Historie (öffentliches Array)
    struct Ladevorgang {
        address nutzer;
        uint256 kWh;
        uint256 betragWei;
        uint256 zeitpunkt;
    }
    Ladevorgang[] public ladeHistorie;

    constructor() {
        betreiber = msg.sender;
    }

    function einzahlen() public payable {
        require(msg.value > 0, "Bitte ETH senden!");
        guthaben[msg.sender] += msg.value;
        emit Einzahlung(msg.sender, msg.value);
    }

    function ladeStarten(uint256 kWh) public {
        require(berechtigt[msg.sender], "Nicht berechtigt!");
        require(kWh > 0, "kWh muss > 0 sein");
        uint256 kosten = preisProKWhWei * kWh;
        require(guthaben[msg.sender] >= kosten, "Nicht genug Guthaben!");
        guthaben[msg.sender] -= kosten;

        // Sende das Geld sofort an den Betreiber
        (bool success, ) = payable(betreiber).call{value: kosten}("");
        require(success, "Ueberweisung an Betreiber fehlgeschlagen!");

        emit LadevorgangGestartet(msg.sender, kWh, kosten);

        // Ladevorgang speichern
        ladeHistorie.push(Ladevorgang(msg.sender, kWh, kosten, block.timestamp));
    }

    function setBerechtigung(address nutzer, bool status) public {
        require(msg.sender == betreiber, "Nur Betreiber!");
        berechtigt[nutzer] = status;
    }

    // Betreiber kann übriges Guthaben abheben
    function auszahlen() public {
        require(msg.sender == betreiber, "Nur Betreiber!");
        payable(betreiber).transfer(address(this).balance);
    }

    // Nutzer kann eigenes Guthaben abheben
    function benutzerAuszahlen() public {
        uint256 betrag = guthaben[msg.sender];
        require(betrag > 0, "Kein Guthaben vorhanden!");
        guthaben[msg.sender] = 0;
        (bool success, ) = payable(msg.sender).call{value: betrag}("");
        require(success, "Auszahlung fehlgeschlagen!");
        emit Auszahlung(msg.sender, betrag);
    }

    function setPreisProKWh(uint256 preisInEth) public {
        require(msg.sender == betreiber, "Nur Betreiber!");
        preisProKWhWei = preisInEth * 1 ether; // Umrechnung ETH -> Wei
    }

    receive() external payable {
        guthaben[msg.sender] += msg.value;
        emit Einzahlung(msg.sender, msg.value);
    }

    // Guthaben in ETH und 4 Nachkommastellen zurückgeben
    function guthabenInEth(address nutzer) public view returns (uint256 ethGanz, uint256 ethDezimal) {
        uint256 wert = guthaben[nutzer];
        ethGanz = wert / 1 ether;
        ethDezimal = (wert % 1 ether) / 1e14; // 4 Nachkommastellen (0.0001 ETH)
    }

    // Anzahl der gespeicherten Ladevorgänge abfragen
    function ladeHistorieAnzahl() public view returns (uint256) {
        return ladeHistorie.length;
    }
}
