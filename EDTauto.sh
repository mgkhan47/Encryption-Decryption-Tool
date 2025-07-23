#!/bin/bash

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
echo " [---]                   Version: 2.0                         [---] "
echo " [---]              Cyber Security Lab Project                [---] "
echo " [---]               Air University, Islamabad                [---] "
echo "===================================================================="

# Function to perform Caesar Cipher
caesar_cipher() {
    local input_file=$1
    local mode=$2
    local message=$(cat "$input_file")
    if [ "$mode" == "encrypt" ]; then
        echo "$message" | tr 'A-Za-z' 'D-ZA-Cd-za-c'
    else
        echo "$message" | tr 'D-ZA-Cd-za-c' 'A-Za-z'
    fi
}

# Function to perform ROT13
rot13() {
    local input_file=$1
    local message=$(cat "$input_file")
    echo "$message" | tr 'A-Za-z' 'N-ZA-Mn-za-m'
}

# Function to perform Base64 encoding/decoding
base64_tool() {
    local input_file=$1
    local mode=$2
    local message=$(cat "$input_file")
    if [ "$mode" == "encrypt" ]; then
        echo "$message" | base64
    else
        echo "$message" | base64 --decode
    fi
}

# Function to perform Substitution Cipher
substitution_cipher() {
    local input_file=$1
    local mode=$2
    local message=$(cat "$input_file")
    read -p "Enter a 26-character substitution key: " key
    if [[ ${#key} -ne 26 ]]; then
        echo "Error: Key must be exactly 26 characters."
        exit 1
    fi
    if [ "$mode" == "encrypt" ]; then
        echo "$message" | tr 'A-Za-z' "${key}${key,,}"
    else
        echo "$message" | tr "${key}${key,,}" 'A-Za-z'
    fi
}

# Function to perform Atbash Cipher
atbash_cipher() {
    local input_file=$1
    local message=$(cat "$input_file")
    echo "$message" | tr 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz' 'ZYXWVUTSRQPONMLKJIHGFEDCBAzyxwvutsrqponmlkjihgfedcba'
}

# Function for Hexadecimal Encoding/Decoding
hex_tool() {
    local input_file=$1
    local mode=$2
    local message=$(cat "$input_file")
    if [ "$mode" == "encrypt" ]; then
        echo -n "$message" | xxd -pu
    else
        echo -n "$message" | xxd -p -r
    fi
}

extend_key() {
    local message=$1
    local key=$2
    local extended_key=""
    local key_len=${#key}
    local key_index=0

    for ((i = 0; i < ${#message}; i++)); do
        if [[ ${message:i:1} =~ [A-Za-z] ]]; then
            extended_key+=${key:$((key_index % key_len)):1}
            ((key_index++))
        else
            extended_key+=${message:i:1}
        fi
    done

    echo "$extended_key"
}

vigenere_encrypt() {
    local message=$1
    local key=$2
    local extended_key=$(extend_key "$message" "$key")
    local encrypted_message=""

    for ((i = 0; i < ${#message}; i++)); do
        char=${message:i:1}
        key_char=${extended_key:i:1}

        if [[ $char =~ [A-Za-z] ]]; then
            base=$([[ $char =~ [A-Z] ]] && echo 65 || echo 97)
            shift=$(( $(printf "%d" "'${key_char^}") - 65 ))
            ascii_value=$(( $(printf "%d" "'${char}") - base + shift ))
            wrapped_value=$(( (ascii_value % 26 + 26) % 26 ))  # Ensure wrap-around
            encrypted_char=$(printf "\\$(printf '%03o' $((wrapped_value + base)))")
            encrypted_message+=$encrypted_char
        else
            encrypted_message+=$char
        fi
    done

    echo "$encrypted_message"
}

vigenere_decrypt() {
    local message=$1
    local key=$2
    local extended_key=$(extend_key "$message" "$key")
    local decrypted_message=""

    for ((i = 0; i < ${#message}; i++)); do
        char=${message:i:1}
        key_char=${extended_key:i:1}

        if [[ $char =~ [A-Za-z] ]]; then
            base=$([[ $char =~ [A-Z] ]] && echo 65 || echo 97)
            shift=$(( $(printf "%d" "'${key_char^}") - 65 ))
            ascii_value=$(( $(printf "%d" "'${char}") - base - shift ))
            wrapped_value=$(( (ascii_value % 26 + 26) % 26 ))  # Ensure wrap-around
            decrypted_char=$(printf "\\$(printf '%03o' $((wrapped_value + base)))")
            decrypted_message+=$decrypted_char
        else
            decrypted_message+=$char
        fi
    done

    echo "$decrypted_message"
}

vigenere_cipher() {
    local input_file=$1
    local mode=$2

    # Validate input file
    if [[ ! -f "$input_file" ]]; then
        echo "Error: File '$input_file' not found or not readable."
        return 1
    fi

    # Validate mode
    if [[ "$mode" != "encrypt" && "$mode" != "decrypt" ]]; then
        echo "Invalid mode. Use 'encrypt' or 'decrypt'."
        return 1
    fi

    local message=$(cat "$input_file")
    read -p "Enter a key for the Vigenère Cipher (letters only): " key

    # Normalize key to uppercase
    key=$(echo "$key" | tr '[:lower:]' '[:upper:]')

    if [ "$mode" == "encrypt" ]; then
        vigenere_encrypt "$message" "$key"
    else
        vigenere_decrypt "$message" "$key"
    fi
}


# Function for Base32 encoding/decoding
base32_tool() {
    local input_file=$1
    local mode=$2
    local message=$(cat "$input_file")
    if [ "$mode" == "encrypt" ]; then
        echo -n "$message" | base32
    else
        echo "$message" | base32 --decode
    fi
}

# Function for Beaufort Cipher
beaufort_encrypt() {
    local message=$1
    local key=$2
    local encrypted=""

    local key_length=${#key}
    local i=0
    for ((j = 0; j < ${#message}; j++)); do
        pt_char="${message:$j:1}"
        key_char="${key:$((i % key_length)):1}"

        if [[ "$pt_char" =~ [A-Za-z] ]]; then
            pt_ascii=$(printf "%d" "'$pt_char")
            key_ascii=$(printf "%d" "'$key_char")

            if [[ "$pt_char" =~ [A-Z] ]]; then
                cipher_ascii=$(( (key_ascii - pt_ascii + 26) % 26 + 65 ))
            else
                cipher_ascii=$(( (key_ascii - pt_ascii + 26) % 26 + 97 ))
            fi

            encrypted_char=$(printf "\\$(printf '%03o' "$cipher_ascii")")
            encrypted+="$encrypted_char"
            ((i++))
        else
            encrypted+="$pt_char"
        fi
    done

    echo "$encrypted"
}

beaufort_decrypt() {
    local message=$1
    local key=$2
    local decrypted=""

    local key_length=${#key}
    local i=0
    for ((j = 0; j < ${#message}; j++)); do
        ct_char="${message:$j:1}"
        key_char="${key:$((i % key_length)):1}"

        if [[ "$ct_char" =~ [A-Za-z] ]]; then
            ct_ascii=$(printf "%d" "'$ct_char")
            key_ascii=$(printf "%d" "'$key_char")

            if [[ "$ct_char" =~ [A-Z] ]]; then
                decrypted_ascii=$(( (key_ascii - ct_ascii + 26) % 26 + 65 ))
            else
                decrypted_ascii=$(( (key_ascii - ct_ascii + 26) % 26 + 97 ))
            fi

            decrypted_char=$(printf "\\$(printf '%03o' "$decrypted_ascii")")
            decrypted+="$decrypted_char"
            ((i++))
        else
            decrypted+="$ct_char"
        fi
    done

    echo "$decrypted"
}

beaufort_cipher() {
    local input_file=$1
    local mode=$2
    local message=$(cat "$input_file")
    read -p "Enter a key for the Beaufort Cipher: " key
    if [ "$mode" == "encrypt" ]; then
        beaufort_encrypt "$message" "$key"
    else
        beaufort_decrypt "$message" "$key"
    fi
}

# Function to perform ROT47
rot47() {
    local input_file=$1
    local message=$(cat "$input_file")
    result=""

    for ((i = 0; i < ${#message}; i++)); do
        char="${message:$i:1}"
        ascii=$(printf "%d" "'$char")

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

# Function to display cipher information
cipher_information() {
    case $cipher_choice in
    1)
        echo -e "\nCaesar Cipher: A substitution cipher where each letter in the plaintext is shifted a fixed number of places down the alphabet.\n* History: Named after Julius Caesar, it was one of the earliest encryption methods, used to secure military communication.\n* What it does: Replaces each letter with one a specific number of positions away in the alphabet, wrapping around if necessary. The number of shifts acts as the key.\n* Example: With a shift of 3, 'HELLO' becomes 'KHOOR'.\n* Vulnerabilities: The cipher is easily broken using brute force or frequency analysis due to its simplicity."
        ;;
    2)
        echo -e "\nROT13 Cipher: A specific case of the Caesar cipher where each letter is shifted by 13 places.\n* History: ROT13 originated as a simple text obfuscation method, often used in online forums to hide spoilers or jokes.\n* What it does: Encodes text by replacing each letter with the one 13 places away in the alphabet. Since the alphabet has 26 letters, applying ROT13 twice returns the original text.\n* Example: 'HELLO' becomes 'URYYB', and applying ROT13 again to 'URYYB' restores 'HELLO'.\n* Vulnerabilities: It provides no security and is easily reversible due to its deterministic nature."
        ;;
    3)
        echo -e "\nBase64 Encoding: A binary-to-text encoding scheme that represents binary data using 64 ASCII characters.\n* History: Developed as part of the MIME standard to encode binary data for text-based communication protocols like email.\n* What it does: Converts data into a string of characters using A-Z, a-z, 0-9, '+', and '/' with '=' as padding. It ensures safe transmission of binary data over text-based systems.\n* Example: Encoding 'Hello' in Base64 results in 'SGVsbG8='.\n* Vulnerabilities: It is not encryption; it provides no confidentiality or integrity, only format conversion for safe transport."
        ;;
    4)
        echo -e "\nSubstitution Cipher: A cipher that replaces each character in the plaintext with another character based on a fixed system.\n* History: Used since ancient times, with notable examples including the Caesar cipher and Polybius square.\n* What it does: Maps each letter of the plaintext to a corresponding letter in a cipher alphabet, which can be randomly generated or follow a specific pattern.\n* Example: If the cipher alphabet is 'QWERTYUIOPASDFGHJKLZXCVBNM', 'HELLO' becomes 'ITSSG'.\n* Vulnerabilities: Simple substitution ciphers are susceptible to frequency analysis due to predictable letter patterns in most languages."
        ;;
    5)
        echo -e "\nAtbash Cipher: A substitution cipher where each letter in the plaintext is replaced by its reverse counterpart in the alphabet.\n* History: Originated in ancient Hebrew texts, used to encode religious writings.\n* What it does: Maps 'A' to 'Z', 'B' to 'Y', and so on, creating a symmetric cipher with no key needed.\n* Example: Using the Atbash cipher, 'HELLO' becomes 'SVOOL'.\n* Vulnerabilities: It is easily decrypted due to its fixed and predictable pattern, offering no real security in modern cryptography."
        ;;
    6)
        echo -e "\nVigenère Cipher: A polyalphabetic substitution cipher that uses a keyword to determine the shift for each letter.\n* History: Invented in the 16th century, it was considered unbreakable for 300 years and nicknamed 'le chiffre indéchiffrable.'\n* What it does: Each letter in the plaintext is shifted based on the corresponding letter in the repeating keyword, creating complex patterns.\n* Example: With the keyword 'KEY', 'HELLO' is encrypted as 'RIJVS' ('H' shifted by 'K', 'E' by 'E', etc.).\n* Vulnerabilities: It is susceptible to frequency analysis and known-plaintext attacks if the keyword is short or reused."
        ;;
    7)
        echo -e "\nHexadecimal Encoding: A method of representing binary data in a readable format using base-16 numbering.\n* History: Widely adopted in computing for concise binary representation and data debugging.\n* What it does: Converts each byte (8 bits) into two hexadecimal characters, using digits 0-9 and letters A-F.\n* Example: The ASCII string 'Hello' is encoded as '48656C6C6F' in hexadecimal.\n* Vulnerabilities: Hexadecimal encoding is not encryption; it simply represents data in a human-readable format and provides no security."
        ;;
    8)
        echo -e "\nBase32 Encoding: A binary-to-text encoding scheme that represents binary data using a set of 32 ASCII characters.\n* History: Developed by RFC 4648 as a way to encode data for systems that cannot handle raw binary data or require text-based formats.\n* What it does: Converts binary data into a set of characters from the alphabet A-Z, 2-7, and uses '=' as padding to ensure the data is aligned.\n* Example: The string 'Hello' in Base32 encoding is 'JBSWY3DPEB3W64TMMQ'.\n* Vulnerabilities: Base32 provides no security, as it is merely a way to represent data, not to encrypt or protect it."
        ;;
    9)
        echo -e "\nBeaufort Cipher: A symmetric key cipher similar to the Vigenère cipher but with a reversed encryption process.\n* History: Named after Sir Francis Beaufort, who created the cipher in the 19th century for naval use.\n* What it does: Encrypts by subtracting the plaintext letter from the key letter, using a reversed alphabet. It uses a key repeated throughout the message.\n* Example: Using the keyword 'KEY' to encrypt 'HELLO' results in 'RIJVS' ('H' - 'K', 'E' - 'E', etc.).\n* Vulnerabilities: Like the Vigenère cipher, it is vulnerable to frequency analysis if the key is short or reused frequently."
        ;;
    10)
        echo -e "\nROT47 Cipher: A variation of the ROT13 cipher that shifts characters by 47 positions in the ASCII table.\n* History: ROT47 was developed as a way to obscure text in online forums and messages, similar to ROT13 but working with a broader range of characters.\n* What it does: Encodes text by shifting each ASCII character by 47 positions, affecting the printable ASCII range (33-126).\n* Example: 'Hello' becomes 'w6==@'.\n* Vulnerabilities: Like ROT13, ROT47 provides no real encryption and is easily reversible by anyone aware of the cipher."
        ;;
    11)
        echo "Exiting. Goodbye!"
        exit 0
        ;;

    *)
        echo "Invalid Input."
        ;;
    esac

}


# Check if file path is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <file_path>"
    exit 1
fi

input_file=$1

# Check if the file exists
if [ ! -f "$input_file" ]; then
    echo "Error: File not found!"
    exit 1
fi

# Ask user for action
while true; do
    echo ""
    echo "What would you like to do?"
    echo "1) Encrypt"
    echo "2) Decrypt"
    echo "3) Information"
    echo "4) Exit"
    echo "--------------------------------------------------------------------"
    read -p "Enter your choice (1-4): " action

    if [ "$action" == "1" ]; then
        mode="encrypt"
        break
    elif [ "$action" == "2" ]; then
        mode="decrypt"
        break
    elif [ "$action" == "3" ]; then
	while true; do
    echo ""
    echo "Select the cipher type:"
    echo "1) Caesar Cipher"
    echo "2) ROT13"
    echo "3) Base64"
    echo "4) Substitution Cipher"
    echo "5) Atbash Cipher"
    echo "6) Vigenère Cipher"
    echo "7) Hexadecimal Encoding"
    echo "8) Base32"
    echo "9) Beaufort Cipher"
    echo "10) ROT47"
    echo "11) Exit"
    echo "--------------------------------------------------------------------"
    read -p "Enter your choice (1-11): " cipher_choice

    if [[ "$cipher_choice" =~ ^[1-9]$|^10$|^11$ ]]; then
        break
    else
        echo "Invalid cipher choice! Please try again."
    fi
done
        cipher_information
    elif [ "$action" == "4" ]; then
        echo "Exiting. Goodbye!"
        exit 0
    else
        echo "Invalid choice! Please try again."
    fi
done

# Ask user for cipher type
while true; do
    echo ""
    echo "Select the cipher type:"
    echo "1) Caesar Cipher"
    echo "2) ROT13"
    echo "3) Base64"
    echo "4) Substitution Cipher"
    echo "5) Atbash Cipher"
    echo "6) Vigenère Cipher"
    echo "7) Hexadecimal Encoding"
    echo "8) Base32"
    echo "9) Beaufort Cipher"
    echo "10) ROT47"
    echo "11) Exit"
    echo "--------------------------------------------------------------------"
    read -p "Enter your choice (1-11): " cipher_choice

    if [[ "$cipher_choice" =~ ^[1-9]$|^10$|^11$ ]]; then
        break
    else
        echo "Invalid cipher choice! Please try again."
    fi
done

# Process based on cipher choice
output_file="output.txt"
case $cipher_choice in
    1)
        caesar_cipher "$input_file" "$mode" > "$output_file"
        ;;
    2)
        rot13 "$input_file" > "$output_file"
        ;;
    3)
        base64_tool "$input_file" "$mode" > "$output_file"
        ;;
    4)
        substitution_cipher "$input_file" "$mode" > "$output_file"
        ;;
    5)
        atbash_cipher "$input_file" > "$output_file"
        ;;
    6)
        vigenere_cipher "$input_file" "$mode" > "$output_file"
        ;;
    7)
        hex_tool "$input_file" "$mode" > "$output_file"
        ;;
    8)
        base32_tool "$input_file" "$mode" > "$output_file"
        ;;
    9)
        beaufort_cipher "$input_file" "$mode" > "$output_file"
        ;;
    10)
        rot47 "$input_file" > "$output_file"
        ;;
    11)
	echo "Exiting. Goodbye!"
	exit 0
        ;;
    *)
        echo "Invalid cipher choice! Exiting."
        exit 1
        ;;
esac

# Notify user of success
echo "Operation completed! Output saved to $output_file"
