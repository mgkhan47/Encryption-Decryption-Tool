#!/bin/bash
# Beaufort Cipher Encryption Function (Case-sensitive)
function beaufort_encrypt() {
    local plaintext="$1"
    local key="$2"
    local encrypted=""
    
    local key_length=${#key}
    local i=0
    for ((j = 0; j < ${#plaintext}; j++)); do
        pt_char="${plaintext:$j:1}"
        key_char="${key:$((i % key_length)):1}"
        
        # Only encrypt alphabetic characters, skip others
        if [[ "$pt_char" =~ [A-Za-z] ]]; then
            pt_ascii=$(printf "%d" "'$pt_char")
            key_ascii=$(printf "%d" "'$key_char")
            
            if [[ "$pt_char" =~ [A-Z] ]]; then
                # Uppercase encryption (cipher stays uppercase)
                cipher_ascii=$(( (key_ascii - pt_ascii + 26) % 26 + 65 ))
            else
                # Lowercase encryption (cipher stays lowercase)
                cipher_ascii=$(( (key_ascii - pt_ascii + 26) % 26 + 97 ))
            fi
            
            encrypted_char=$(printf "\\$(printf '%03o' "$cipher_ascii")")
            encrypted+="$encrypted_char"
            ((i++))
        else
            encrypted+="$pt_char"  # Non-alphabet characters remain unchanged
        fi
    done

    echo "$encrypted"
}

# Beaufort Cipher Decryption Function (Case-sensitive)
function beaufort_decrypt() {
    local ciphertext="$1"
    local key="$2"
    local decrypted=""
    
    local key_length=${#key}
    local i=0
    for ((j = 0; j < ${#ciphertext}; j++)); do
        ct_char="${ciphertext:$j:1}"
        key_char="${key:$((i % key_length)):1}"
        
        # Only decrypt alphabetic characters, skip others
        if [[ "$ct_char" =~ [A-Za-z] ]]; then
            ct_ascii=$(printf "%d" "'$ct_char")
            key_ascii=$(printf "%d" "'$key_char")
            
            if [[ "$ct_char" =~ [A-Z] ]]; then
                # Uppercase decryption (cipher stays uppercase)
                decrypted_ascii=$(( (key_ascii - ct_ascii + 26) % 26 + 65 ))
            else
                # Lowercase decryption (cipher stays lowercase)
                decrypted_ascii=$(( (key_ascii - ct_ascii + 26) % 26 + 97 ))
            fi
            
            decrypted_char=$(printf "\\$(printf '%03o' "$decrypted_ascii")")
            decrypted+="$decrypted_char"
            ((i++))
        else
            decrypted+="$ct_char"  # Non-alphabet characters remain unchanged
        fi
    done

    echo "$decrypted"
}
function rot47() {
    local message="$1"
    result=""
    
    for ((i = 0; i < ${#message}; i++)); do
        char="${message:$i:1}"
        ascii=$(printf "%d" "'$char")
        
        # Check if the character is within the printable ASCII range (33 to 126)
        if ((ascii >= 33 && ascii <= 126)); then
            new_ascii=$((ascii + 47))
            if ((new_ascii > 126)); then
                new_ascii=$((new_ascii - 94))
            fi
            new_char=$(printf "\\$(printf '%03o' "$new_ascii")")
            result+="$new_char"
        else
            result+="$char"
        fi
    done

    echo "$result"
}
function extend_key {
    local message=$1
    local key=$2
    local extended_key=""
    local key_len=${#key}
    local message_len=${#message}

    for ((i=0; i<message_len; i++)); do
        if [[ ${message:i:1} =~ [A-Za-z] ]]; then
            extended_key+=${key:i%key_len:1}
        else
            extended_key+=${message:i:1}  # Keep non-alphabetic characters
        fi
    done

    echo "$extended_key"
}

# Vigenère Cipher Encryption
function vigenere_encrypt {
    local message=$1
    local key=$2
    local extended_key=$(extend_key "$message" "$key")
    local encrypted_message=""

    for ((i=0; i<${#message}; i++)); do
        char=${message:i:1}
        key_char=${extended_key:i:1}

        if [[ $char =~ [A-Za-z] ]]; then
            base=$([[ $char =~ [A-Z] ]] && echo 65 || echo 97)
            shift=$(( $(printf "%d" "'${key_char}") - $(printf "%d" "'A") ))
            encrypted_message+=$(printf \\$(printf '%03o' $(( ( $(printf "%d" "'${char}") - base + shift ) % 26 + base ))))
        else
            encrypted_message+=$char
        fi
    done

    echo "$encrypted_message"
}

# Vigenère Cipher Decryption
function vigenere_decrypt {
    local message=$1
    local key=$2
    local extended_key=$(extend_key "$message" "$key")
    local decrypted_message=""

    for ((i=0; i<${#message}; i++)); do
        char=${message:i:1}
        key_char=${extended_key:i:1}

        if [[ $char =~ [A-Za-z] ]]; then
            base=$([[ $char =~ [A-Z] ]] && echo 65 || echo 97)
            shift=$(( $(printf "%d" "'${key_char}") - $(printf "%d" "'A") ))
            decrypted_message+=$(printf \\$(printf '%03o' $(( ( $(printf "%d" "'${char}") - base - shift + 26 ) % 26 + base ))))
        else
            decrypted_message+=$char
        fi
    done

    echo "$decrypted_message"
}
# Clear the screen and display a welcome banner
clear
echo " "
echo "===================================================================="
echo " [---]         Welcome to Encryption-Decryption Tool          [---] "
echo "===================================================================="
echo ""
echo
figlet "EDTOOL" | lolcat
echo " "
echo "===================================================================="
echo " [---]            The Encryption-Decryption Tool              [---] "
echo " [---]           Created by: Muhammad Gulraiz Khan            [---] "
echo " [---]                   Version: 1.0                         [---] "
echo " [---]              Cyber Security Lab Project                [---] "
echo " [---]               Air University, Islamabad                [---] "
echo "===================================================================="

# Display Cipher Selection Menu
function display_cipher_menu() {
    echo ""
    echo "Choose an Cipher Type:"
    echo "1. Caesar Cipher"
    echo "2. ROT13"
    echo "3. Base64"
    echo "4. Substitution Cipher"
    echo "5. Atbash Cipher"
    echo "6. Vigenère Cipher"
    echo "7. Hexadecimal Encoding"
    echo "8. Base32"
    echo "9. Beaufort Cipher"
    echo "10. ROT47"
    echo "11. Exit"
    echo "--------------------------------------------------------------------"
    echo -n "Enter Your Choice (1-11): "
}

# Prompt the User for Action After Choosing a Cipher
function ask_action() {
    echo ""
    echo "You selected $1. What would you like to do?"
    echo "1. Encryption"
    echo "2. Decryption"
    echo "3. Information"
    echo "--------------------------------------------------------------------"
    echo -n "Enter Your Choice (1-3): "
}

# Main Cipher Logic Based on User Action
function handle_action() {
    local cipher="$1"
    local action="$2"

    case $action in
    1)
	echo ""
        echo "Performing Encryption for $cipher..."
        encryption_logic "$cipher"
        ;;
    2)
	echo ""
        echo "Performing Decryption for $cipher..."
        decryption_logic "$cipher"
        ;;
    3)
	echo ""
        echo "Displaying Information for $cipher..."
        display_info_logic "$cipher"
        ;;
    *)
        echo "Invalid choice. Returning to main menu."
        ;;
    esac
}

# Function to Handle Encryption Logic
function encryption_logic() {
    case $1 in
    "Caesar Cipher")
	shift=3  # Predefined shift key
        echo "Caesar Cipher"
        echo -n "Enter the message to encrypt: "
        read message
        encrypted=$(echo "$message" | tr 'A-Za-z' 'D-ZA-Cd-za-c')  # Shift by 3
        echo "Encrypted message: $encrypted"
        ;;
    "ROT13")
	echo "ROT13"
        echo -n "Enter the message to encrypt: "
        read message
        encrypted=$(echo "$message" | tr 'A-Za-z' 'N-ZA-Mn-za-m')
        echo "Encrypted message: $encrypted"
        ;;
    "Base64")
	echo "Base64"
        echo -n "Enter the message to encrypt: "
        read message
        encrypted=$(echo "$message" | base64)
        echo "Encrypted message: $encrypted"
        ;;
    "Substitution Cipher")
	echo "Substitution Cipher"
        echo -n "Enter a 26-character key: "
        read key
        if [[ ${#key} -ne 26 ]]; then
            echo "Error: Key must be exactly 26 characters."
            break
        fi
        echo -n "Enter the message to encrypt: "
        read message
        encrypted=$(echo "$message" | tr 'A-Za-z' "${key}${key,,}")  # Uppercase and lowercase mapping
        echo "Encrypted message: $encrypted"
        ;;
    "Atbash Cipher")
	echo "Atbash Cipher"
        echo -n "Enter the message to encrypt: "
        read message
        encrypted=$(echo "$message" | tr 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz' 'ZYXWVUTSRQPONMLKJIHGFEDCBAzyxwvutsrqponmlkjihgfedcba')
        echo "Encrypted message: $encrypted"
        ;;
    "Vigenère Cipher")
	echo "Vigenère Cipher"
        echo -n "Enter the key (text): "
        read key
        key=$(echo "$key" | tr '[:lower:]' '[:upper:]')  # Convert key to uppercase
        echo -n "Enter the message to encrypt: "
        read message
        encrypted=$(vigenere_encrypt "$message" "$key")
        echo "Encrypted message: $encrypted"
        ;;
    "Hexadecimal Encoding")
	echo "Hexadecimal Encoding"
        echo -n "Enter the message to encrypt: "
        read message
        encrypted=$(echo -n "$message" | xxd -pu)
        echo "Encrypted message: $encrypted"
        ;;
    "Base32")
	echo "Base32"
        echo -n "Enter the message to encode (alphanumeric only): "
        read message
        encrypted=$(echo -n "$message" | base32)
        echo "Encrypted message: $encrypted"
        ;;
    "Beaufort Cipher")
	echo "Beaufort Cipher"
        echo -n "Enter the message to encrypt: "
        read message
        echo -n "Enter the key: "
        read key
        encrypted=$(beaufort_encrypt "$message" "$key")
        echo "Encrypted message: $encrypted"
        ;;
    "ROT47")
	echo "ROT47"
        echo -n "Enter the message to encrypt: "
        read message
        encrypted=$(rot47 "$message")
        echo "Encrypted message (ROT47): $encrypted"
        ;;
    *)
        echo "Invalid Input"
        ;;
    esac
}

# Function to Handle Decryption Logic
function decryption_logic() {
    case $1 in
    "Caesar Cipher")
	shift=3  # Predefined shift key
        echo "Caesar Cipher"
        echo -n "Enter the message to decrypt: "
        read message
        decrypted=$(echo "$message" | tr 'D-ZA-Cd-za-c' 'A-Za-z')  # Reverse shift by 3
        echo "Decrypted message: $decrypted"
        ;;
    "ROT13")
	echo "ROT13"
        echo -n "Enter the message to decrypt: "
        read message
        decrypted=$(echo "$message" | tr 'A-Za-z' 'N-ZA-Mn-za-m')
        echo "Decrypted message: $decrypted"
        ;;
    "Base64")
	echo "Base64"
        echo -n "Enter the message to decrypt: "
        read message
        decrypted=$(echo "$message" | base64 --decode)
        echo "Decrypted message: $decrypted"
        ;;
    "Substitution Cipher")
	echo "Substitution Cipher"
        echo -n "Enter a 26-character key: "
        read key
        if [[ ${#key} -ne 26 ]]; then
            echo "Error: Key must be exactly 26 characters."
            break
        fi
        echo -n "Enter the message to decrypt: "
        read message
        decrypted=$(echo "$message" | tr "${key}${key,,}" 'A-Za-z')  # Reverse mapping for decryption
        echo "Decrypted message: $decrypted"
        ;;
    "Atbash Cipher")
	echo "Atbash Cipher"
        echo -n "Enter the message to decrypt: "
        read message
        decrypted=$(echo "$message" | tr 'ZYXWVUTSRQPONMLKJIHGFEDCBAzyxwvutsrqponmlkjihgfedcba' 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz')
        echo "Decrypted message: $decrypted"
        ;;
    "Vigenère Cipher")
	echo "Vigenère Cipher"
        echo -n "Enter the key (text): "
        read key
        key=$(echo "$key" | tr '[:lower:]' '[:upper:]')  # Convert key to uppercase
        echo -n "Enter the message to decrypt: "
        read message
        decrypted=$(vigenere_decrypt "$message" "$key")
        echo "Decrypted message: $decrypted"
        ;;
    "Hexadecimal Encoding")
	echo "Hexadecimal Encoding"
        echo -n "Enter the hex-encoded message to decrypt: "
        read message
        decrypted=$(echo -n "$message" | xxd -p -r)
        echo "Decrypted message: $decrypted"
        ;;
    "Base32")
	echo "Base32"
        echo -n "Enter the Base32 encoded message to decode: "
        read message
        decrypted=$(echo "$message" | base32 --decode)
        echo "Decrypted message: $decrypted"
        ;;
    "Beaufort Cipher")
	echo "Beaufort Cipher"
        echo -n "Enter the message to decrypt: "
        read message
        echo -n "Enter the key: "
        read key
        decrypted=$(beaufort_decrypt "$message" "$key")
        echo "Decrypted message: $decrypted"
        ;;
    "ROT47")
	echo "ROT47"
        echo -n "Enter the message to decrypt: "
        read message
        decrypted=$(rot47 "$message")
        echo "Decrypted message: $decrypted"
        ;;
    *)
        echo "Invalid Input."
        ;;
    esac
}

# Function to Display Cipher Information
function display_info_logic() {
    case $1 in
    "Caesar Cipher")
        echo -e "\nCaesar Cipher: A substitution cipher where each letter in the plaintext is shifted a fixed number of places down the alphabet.\n* History: Named after Julius Caesar, it was one of the earliest encryption methods, used to secure military communication.\n* What it does: Replaces each letter with one a specific number of positions away in the alphabet, wrapping around if necessary. The number of shifts acts as the key.\n* Example: With a shift of 3, 'HELLO' becomes 'KHOOR'.\n* Vulnerabilities: The cipher is easily broken using brute force or frequency analysis due to its simplicity."
        ;;
    "ROT13")
        echo -e "\nROT13 Cipher: A specific case of the Caesar cipher where each letter is shifted by 13 places.\n* History: ROT13 originated as a simple text obfuscation method, often used in online forums to hide spoilers or jokes.\n* What it does: Encodes text by replacing each letter with the one 13 places away in the alphabet. Since the alphabet has 26 letters, applying ROT13 twice returns the original text.\n* Example: 'HELLO' becomes 'URYYB', and applying ROT13 again to 'URYYB' restores 'HELLO'.\n* Vulnerabilities: It provides no security and is easily reversible due to its deterministic nature."
        ;;
    "Base64")
        echo -e "\nBase64 Encoding: A binary-to-text encoding scheme that represents binary data using 64 ASCII characters.\n* History: Developed as part of the MIME standard to encode binary data for text-based communication protocols like email.\n* What it does: Converts data into a string of characters using A-Z, a-z, 0-9, '+', and '/' with '=' as padding. It ensures safe transmission of binary data over text-based systems.\n* Example: Encoding 'Hello' in Base64 results in 'SGVsbG8='.\n* Vulnerabilities: It is not encryption; it provides no confidentiality or integrity, only format conversion for safe transport."
        ;;
    "Substitution Cipher")
        echo -e "\nSubstitution Cipher: A cipher that replaces each character in the plaintext with another character based on a fixed system.\n* History: Used since ancient times, with notable examples including the Caesar cipher and Polybius square.\n* What it does: Maps each letter of the plaintext to a corresponding letter in a cipher alphabet, which can be randomly generated or follow a specific pattern.\n* Example: If the cipher alphabet is 'QWERTYUIOPASDFGHJKLZXCVBNM', 'HELLO' becomes 'ITSSG'.\n* Vulnerabilities: Simple substitution ciphers are susceptible to frequency analysis due to predictable letter patterns in most languages."
        ;;
    "Atbash Cipher")
        echo -e "\nAtbash Cipher: A substitution cipher where each letter in the plaintext is replaced by its reverse counterpart in the alphabet.\n* History: Originated in ancient Hebrew texts, used to encode religious writings.\n* What it does: Maps 'A' to 'Z', 'B' to 'Y', and so on, creating a symmetric cipher with no key needed.\n* Example: Using the Atbash cipher, 'HELLO' becomes 'SVOOL'.\n* Vulnerabilities: It is easily decrypted due to its fixed and predictable pattern, offering no real security in modern cryptography."
        ;;
    "Vigenère Cipher")
        echo -e "\nVigenère Cipher: A polyalphabetic substitution cipher that uses a keyword to determine the shift for each letter.\n* History: Invented in the 16th century, it was considered unbreakable for 300 years and nicknamed 'le chiffre indéchiffrable.'\n* What it does: Each letter in the plaintext is shifted based on the corresponding letter in the repeating keyword, creating complex patterns.\n* Example: With the keyword 'KEY', 'HELLO' is encrypted as 'RIJVS' ('H' shifted by 'K', 'E' by 'E', etc.).\n* Vulnerabilities: It is susceptible to frequency analysis and known-plaintext attacks if the keyword is short or reused."
        ;;
    "Hexadecimal Encoding")
        echo -e "\nHexadecimal Encoding: A method of representing binary data in a readable format using base-16 numbering.\n* History: Widely adopted in computing for concise binary representation and data debugging.\n* What it does: Converts each byte (8 bits) into two hexadecimal characters, using digits 0-9 and letters A-F.\n* Example: The ASCII string 'Hello' is encoded as '48656C6C6F' in hexadecimal.\n* Vulnerabilities: Hexadecimal encoding is not encryption; it simply represents data in a human-readable format and provides no security."
        ;;
    "Base32")
        echo -e "\nBase32 Encoding: A binary-to-text encoding scheme that represents binary data using a set of 32 ASCII characters.\n* History: Developed by RFC 4648 as a way to encode data for systems that cannot handle raw binary data or require text-based formats.\n* What it does: Converts binary data into a set of characters from the alphabet A-Z, 2-7, and uses '=' as padding to ensure the data is aligned.\n* Example: The string 'Hello' in Base32 encoding is 'JBSWY3DPEB3W64TMMQ'.\n* Vulnerabilities: Base32 provides no security, as it is merely a way to represent data, not to encrypt or protect it."
        ;;
    "Beaufort Cipher")
        echo -e "\nBeaufort Cipher: A symmetric key cipher similar to the Vigenère cipher but with a reversed encryption process.\n* History: Named after Sir Francis Beaufort, who created the cipher in the 19th century for naval use.\n* What it does: Encrypts by subtracting the plaintext letter from the key letter, using a reversed alphabet. It uses a key repeated throughout the message.\n* Example: Using the keyword 'KEY' to encrypt 'HELLO' results in 'RIJVS' ('H' - 'K', 'E' - 'E', etc.).\n* Vulnerabilities: Like the Vigenère cipher, it is vulnerable to frequency analysis if the key is short or reused frequently."
        ;;
    "ROT47")
        echo -e "\nROT47 Cipher: A variation of the ROT13 cipher that shifts characters by 47 positions in the ASCII table.\n* History: ROT47 was developed as a way to obscure text in online forums and messages, similar to ROT13 but working with a broader range of characters.\n* What it does: Encodes text by shifting each ASCII character by 47 positions, affecting the printable ASCII range (33-126).\n* Example: 'Hello' becomes 'w6==@'.\n* Vulnerabilities: Like ROT13, ROT47 provides no real encryption and is easily reversible by anyone aware of the cipher."
        ;;
    *)
        echo "Invalid Input."
        ;;
    esac
}

# Main Loop
while true; do
    display_cipher_menu
    read cipher_choice

    case $cipher_choice in
    1) cipher="Caesar Cipher" ;;
    2) cipher="ROT13" ;;
    3) cipher="Base64" ;;
    4) cipher="Substitution Cipher" ;;
    5) cipher="Atbash Cipher" ;;
    6) cipher="Vigenère Cipher" ;;
    7) cipher="Hexadecimal Encoding" ;;
    8) cipher="Base32" ;;
    9) cipher="Beaufort Cipher" ;;
    10) cipher="ROT47" ;;
    11) echo "Exiting. Goodbye!"
        exit 0
        ;;
    *)
        echo "Invalid choice. Please try again."
        continue
        ;;
    esac

    ask_action "$cipher"
    read action_choice
    handle_action "$cipher" "$action_choice"
done
