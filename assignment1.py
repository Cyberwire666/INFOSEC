import itertools
import string

# Hardcoded username and password
USERNAME = "admin"
PASSWORD = "11111"  # The password consists of exactly 5 alphabetical characters

# Dictionary file (example words for dictionary attack)
DICTIONARY_FILE = "dictionary.txt"


def dictionary_attack(username, dictionary_file):
    """Attempts to log in using passwords from a dictionary file."""
    if username != USERNAME:
        print("Invalid username!")
        return False

    try:
        with open(dictionary_file, "r") as file:
            for password in file:
                password = password.strip()
                if password == PASSWORD:
                    print(f"[+] Dictionary attack successful! Password found: {password}")
                    return True
    except FileNotFoundError:
        print("[!] Dictionary file not found. Skipping dictionary attack.")

    print("[-] Dictionary attack failed.")
    return False


def brute_force_attack(username):
    """Attempts to log in using brute-force attack by generating all possible 5-letter passwords."""
    if username != USERNAME:
        print("Invalid username!")
        return False

    print("[*] Starting brute-force attack...")

    # Generate all possible 5-letter alphabetical passwords
    chars = string.ascii_letters  # A-Z, a-z
    for password in itertools.product(chars, repeat=5):
        password = "".join(password)
        if password == PASSWORD:
            print(f"[+] Brute-force attack successful! Password found: {password}")
            return True

    print("[-] Brute-force attack failed.")
    return False


def main():
    """Main function to execute the attack."""
    username = input("Enter username: ")

    print("\n[*] Attempting dictionary attack...")
    if not dictionary_attack(username, DICTIONARY_FILE):
        print("\n[*] Dictionary attack failed. Attempting brute-force attack...")
        brute_force_attack(username)


if __name__ == "__main__":
    main()
