# 🔐 Encryption-Decryption Tool

This repository contains **two Bash-based tools** for performing secure encryption and decryption using various classical and modern cryptographic ciphers.  

---

## 📜 Abstract  
This project presents the design and implementation of two Linux-based tools:  
- **Manual Encryption-Decryption Tool**: Provides an interactive terminal interface for users to encrypt, decrypt, or retrieve information about supported ciphers.  
- **Automatic Encryption-Decryption Tool**: Automates processing of text files by applying the selected cipher and saving the output to a new file.  

Both tools demonstrate practical applications of cryptographic algorithms in cybersecurity.

---

## ✅ Features  
### Manual Tool:
- Interactive menu-driven interface.
- Supports encrypt, decrypt, and cipher info options.
- Handles multiple ciphers with validation.

### Automatic Tool:
- Batch file processing for encryption and decryption.
- Automated output file naming.
- Error handling for file operations.

---

## 🔑 Ciphers Implemented
- Caesar Cipher  
- ROT13  
- Base64 Encoding  
- Base32 Encoding  
- Atbash Cipher  
- Vigenère Cipher  
- Beaufort Cipher  
- ROT47  
- Substitution Cipher  
- Hexadecimal Encoding  

---

## ▶ Installation & Usage  
### Requirements:
- Linux environment (tested on **Kali Linux**)
- Bash shell

### Steps:
1. Clone this repository:
   ```bash
   git clone https://github.com/mgkhan47/Encryption-Decryption-Tool.git
   cd Encryption-Decryption-Tool
   ```
2. Make the scripts executable:
   ```bash
   chmod +x EDTman.sh
   chmod +x EDTauto.sh
   ```
3. Run the **Manual Tool**:
   ```bash
   ./EDTman.sh
   ```
4. Run the **Automatic Tool** with a text file:
   ```bash
   ./EDTauto.sh input.txt
   ```

---

## 📂 Project Contents
```
Encryption-Decryption-Tool/
│── EDTman.sh          # Manual interactive encryption-decryption script
│── EDTauto.sh            # Automatic file-based encryption-decryption script
│── Technical-Report.pdf  # Complete project report
│── README.md             # Documentation
│── LICENSE               # MIT License
```

---

## 📺 Demo Video
👉 [Watch the Demo Video](https://drive.google.com/file/d/1c90RL9sABocvM3NqKFKcbuaL2Dtb3e5f/view?usp=sharing)


---

## 📜 License
This project is licensed under the **MIT License** – see the [LICENSE](LICENSE) file for details.

