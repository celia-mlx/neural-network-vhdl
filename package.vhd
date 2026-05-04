LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

PACKAGE pack_neuralnet IS
    -- 1. Constantes de base[cite: 7]
    CONSTANT T    : natural := 100;        -- Seuil
    CONSTANT Vmin : natural := 1;          -- Valeur basse
    CONSTANT Vmax : natural := 16;         -- Valeur haute
    CONSTANT N    : positive := 8;         -- Nombre d'entrées

    -- 2. Types pour les données[cite: 7, 8]
    TYPE tab_int IS ARRAY(natural RANGE <>) OF integer;
    SUBTYPE tab_int_const IS tab_int(N DOWNTO 1);
    
    -- Type pour les sorties du réseau (utilisé dans network et tb_network)[cite: 8]
    TYPE tab_layer IS ARRAY(natural RANGE <>) OF integer;
    
    -- Sous-type pour le neurone synchrone (6 bits)
    SUBTYPE short_natural IS natural RANGE 0 TO 63;
    SUBTYPE long_natural  IS natural RANGE 0 TO 16383;

    -- 3. Déclarations pour la table des poids (Wi_LUT)[cite: 1]
    -- Ce type permet de stocker les poids pour 4 couches et 8 neurones par couche
    TYPE Quad_Tab_const IS ARRAY(1 TO 4, 1 TO 8) OF tab_int_const;

    -- La constante Wi_LUT contient les poids appris lors de la phase d'apprentissage[cite: 1]
    CONSTANT Wi_LUT: Quad_Tab_const := (
        ((1,1,5,5,5,5,1,1), (1,0,3,5,3,5,0,7), (0,1,6,5,4,5,2,1), (8,0,5,0,5,5,0,1),
         (4,4,4,4,2,2,2,2), (4,3,5,0,0,5,3,4), (3,3,3,3,3,3,3,3), (1,2,3,6,6,3,2,1)),
        ((4,6,0,3,1,0,6,4), (5,5,1,1,1,1,5,5), (3,3,3,3,3,3,3,3), (0,1,3,8,8,3,1,0),
         (0,0,0,0,0,0,0,0), (0,0,0,0,0,0,0,0), (0,0,0,0,0,0,0,0), (0,0,0,0,0,0,0,0)),
        ((0,9,9,0,0,0,0,0), (6,6,6,6,0,0,0,0), (0,0,0,0,0,0,0,0), (0,0,0,0,0,0,0,0),
         (0,0,0,0,0,0,0,0), (0,0,0,0,0,0,0,0), (0,0,0,0,0,0,0,0), (0,0,0,0,0,0,0,0)),
        OTHERS => (OTHERS => (OTHERS => 0))
    );
END PACKAGE;
