bash
#!/data/data/com.termux/files/usr/bin/bash

# Überprüfe, ob curl installiert ist
if ! command -v curl &> /dev/null; then
    echo "curl ist nicht installiert. Installiere es mit 'pkg install curl'."
    exit 1
fi

# API-Endpunkt für HashVault-Statistiken
api_url="https://monero.hashvault.pro/api/stats"

# Frage nach der Wallet-Adresse
read -p "Geben Sie Ihre Monero-Wallet-Adresse ein: " wallet_address

# Überprüfe, ob eine Adresse eingegeben wurde
if [ -z "$wallet_address" ]; then
    echo "Keine Wallet-Adresse eingegeben. Abbruch."
    exit 1
fi

# Hole die Statistiken von der API
stats=$(curl -s "$api_url/$wallet_address")

# Überprüfe, ob die Anfrage erfolgreich war
if [ $? -ne 0 ]; then
    echo "Fehler beim Abrufen der Statistiken von HashVault."
    exit 1
fi

# Parse die JSON-Antwort
total_hashes=$(echo "$stats" | grep -o '"totalHashes":[0-9]*' | grep -o '[0-9]*')
cracked_hashes=$(echo "$stats" | grep -o '"crackedHashes":[0-9]*' | grep -o '[0-9]*')
uncracked_hashes=$(echo "$stats" | grep -o '"uncrackedHashes":[0-9]*' | grep -o '[0-9]*')

# Gib die Statistiken aus
echo "Statistiken für Wallet-Adresse: $wallet_address"
echo "Gesamte Hashes: $total_hashes"
echo "Geknackte Hashes: $cracked_hashes"
echo "Ungeknackte Hashes: $uncracked_hashes"
