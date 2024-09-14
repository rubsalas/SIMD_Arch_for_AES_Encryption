#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define Nb 4            // Número de columnas en la matriz de estado
#define Nk 4            // Número de palabras en la clave
#define Nr 10           // Número de rondas en AES-128

// S-box usada en AES
static const uint8_t sbox[256] = {
    // Aquí va la tabla de sustitución S-box completa...
};

// Tabla de rondas Rcon
static const uint8_t Rcon[11] = {
    0x00, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1B, 0x36
};

void SubBytes(uint8_t state[4][4]) {
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            state[i][j] = sbox[state[i][j]];
        }
    }
}

void ShiftRows(uint8_t state[4][4]) {
    uint8_t temp;

    // Segunda fila
    temp = state[1][0];
    state[1][0] = state[1][1];
    state[1][1] = state[1][2];
    state[1][2] = state[1][3];
    state[1][3] = temp;

    // Tercera fila
    temp = state[2][0];
    state[2][0] = state[2][2];
    state[2][2] = temp;
    temp = state[2][1];
    state[2][1] = state[2][3];
    state[2][3] = temp;

    // Cuarta fila
    temp = state[3][0];
    state[3][0] = state[3][3];
    state[3][3] = state[3][2];
    state[3][2] = state[3][1];
    state[3][1] = temp;
}

void MixColumns(uint8_t state[4][4]) {
    uint8_t temp[4];
    for (int i = 0; i < 4; i++) {
        temp[0] = state[0][i];
        temp[1] = state[1][i];
        temp[2] = state[2][i];
        temp[3] = state[3][i];
        state[0][i] = temp[0] ^ temp[1] ^ temp[2] ^ temp[3]; // Ejemplo simple (falta el correcto mix)
        state[1][i] = temp[0] ^ temp[1] ^ temp[2] ^ temp[3];
        state[2][i] = temp[0] ^ temp[1] ^ temp[2] ^ temp[3];
        state[3][i] = temp[0] ^ temp[1] ^ temp[2] ^ temp[3];
    }
}

void AddRoundKey(uint8_t state[4][4], uint8_t roundKey[16]) {
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            state[i][j] ^= roundKey[i + j * 4];
        }
    }
}

void KeyExpansion(const uint8_t* key, uint8_t expandedKey[176]) {
    uint8_t temp[4];
    int i = 0;
    
    while (i < Nk * 4) {
        expandedKey[i] = key[i];
        i++;
    }
    
    i = Nk;
    
    while (i < Nb * (Nr + 1)) {
        for (int j = 0; j < 4; j++) {
            temp[j] = expandedKey[(i - 1) * 4 + j];
        }

        if (i % Nk == 0) {
            // RotWord
            uint8_t t = temp[0];
            temp[0] = temp[1];
            temp[1] = temp[2];
            temp[2] = temp[3];
            temp[3] = t;

            // SubWord
            for (int j = 0; j < 4; j++) {
                temp[j] = sbox[temp[j]];
            }

            temp[0] ^= Rcon[i / Nk];
        }

        for (int j = 0; j < 4; j++) {
            expandedKey[i * 4 + j] = expandedKey[(i - Nk) * 4 + j] ^ temp[j];
        }

        i++;
    }
}

void AES_encrypt(const uint8_t* input, const uint8_t* key, uint8_t* output) {
    uint8_t state[4][4];
    uint8_t expandedKey[176];

    // Copiar input al estado
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            state[j][i] = input[i * 4 + j];
        }
    }

    // Expandir clave
    KeyExpansion(key, expandedKey);

    // Agregar clave de ronda inicial
    AddRoundKey(state, expandedKey);

    // 9 rondas principales
    for (int round = 1; round < Nr; round++) {
        SubBytes(state);
        ShiftRows(state);
        MixColumns(state);
        AddRoundKey(state, expandedKey + round * 16);
    }

    // Ronda final (sin MixColumns)
    SubBytes(state);
    ShiftRows(state);
    AddRoundKey(state, expandedKey + Nr * 16);

    // Copiar estado al output
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            output[i * 4 + j] = state[j][i];
        }
    }
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        printf("Uso: %s <clave de 16 caracteres> <texto plano de 16 caracteres>\n", argv[0]);
        return 1;
    }

    // Clave y texto plano proporcionados por el usuario
    uint8_t key[16];
    uint8_t plaintext[16];
    strncpy((char*)key, argv[1], 16);
    strncpy((char*)plaintext, argv[2], 16);

    // Buffer para el texto cifrado
    uint8_t ciphertext[16];

    // Cifrar el bloque
    AES_encrypt(plaintext, key, ciphertext);

    // Mostrar el texto cifrado
    printf("Texto cifrado: ");
    for (int i = 0; i < 16; i++) {
        printf("%02X ", ciphertext[i]);
    }
    printf("\n");

    return 0;
}
