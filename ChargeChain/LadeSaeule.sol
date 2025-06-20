// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title LadeSaeule - Smart Contract für Zugang & Bezahlung an E-Ladesäulen
contract LadeSaeule {
    address public betreiber; // Betreiber der Ladesäule
    uint256 public preisProLadevorgang = 0.01 ether; // Preis für einen Ladevorgang

    // Mapping: Welche Adresse ist berechtigt?
    mapping(address => bool) public berechtigt;

    // Event für erfolgreiche Ladevorgänge
    event LadevorgangGestartet(address nutzer, uint256 betrag);
    event BerechtigungGeaendert(address nutzer, bool status);

    constructor() {
        betreiber = msg.sender; // Derjenige, der den Contract deployed, ist Betreiber
    }

    // Funktion, um Berechtigungen zu setzen (nur Betreiber)
    function setBerechtigung(address nutzer, bool status) public {
        require(msg.sender == betreiber, "Nur Betreiber!");
        berechtigt[nutzer] = status;
        emit BerechtigungGeaendert(nutzer, status);
    }

    // Funktion, um den Ladevorgang zu starten und zu bezahlen
    function ladeStarten() public payable {
        require(berechtigt[msg.sender], "Nicht berechtigt!");
        require(msg.value >= preisProLadevorgang, "Zu wenig ETH gesendet!");
        emit LadevorgangGestartet(msg.sender, msg.value);
        // Hier würde in der Praxis das Signal an die Hardware gehen
    }

    // Betreiber kann das Guthaben abheben
    function auszahlen() public {
        require(msg.sender == betreiber, "Nur Betreiber!");
        payable(betreiber).transfer(address(this).balance);
    }

    // Optional: Preis ändern (nur Betreiber)
    function setPreis(uint256 neuerPreis) public {
        require(msg.sender == betreiber, "Nur Betreiber!");
        preisProLadevorgang = neuerPreis;
    }

    // Fallback-Funktion, falls ETH direkt an den Contract gesendet wird
    receive() external payable {}
}