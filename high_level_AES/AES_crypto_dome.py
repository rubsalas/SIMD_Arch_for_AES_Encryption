from Crypto.Cipher import AES

def encrypt_aes_ecb(key, plaintext):
    assert len(key) == 16, "La clave debe ser de 128 bits (16 bytes)."

    # Crea el objeto AES en modo ECB
    cipher = AES.new(key, AES.MODE_ECB)

    # Encripta el texto plano
    ciphertext = cipher.encrypt(plaintext)
    
    return ciphertext

def decrypt_aes_ecb(key, ciphertext):
    assert len(key) == 16, "La clave debe ser de 16 bytes."
    
    # Crea el objeto AES en modo ECB
    cipher = AES.new(key, AES.MODE_ECB)
    
    # Desencripta
    plaintext = cipher.decrypt(ciphertext)
    
    return plaintext

key = b'16byteaeskey1234'
plaintext = b'En resolucion, el se enfrasco tanto en su lectura, que se le pasaban las noches leyendo de claro en claro, y los dias de turbio.'

assert len(plaintext) % 16 == 0, "El texto plano debe ser múltiplo de 16 bytes."

ciphertext = encrypt_aes_ecb(key, plaintext)
print(f"Texto cifrado: {ciphertext}")

decrypted_text = decrypt_aes_ecb(key, ciphertext)
print(f"Texto descifrado: {decrypted_text}")