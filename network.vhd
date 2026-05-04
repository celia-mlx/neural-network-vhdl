LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.pack_neuralnet.ALL;

ENTITY network IS
    GENERIC (
        Nb_Layers : positive := 3
    );
    PORT (
        clk : IN std_logic; -- add clk
        input  : IN  tab_int_const;
        output : OUT tab_layer(1 TO 2)
    );
END ENTITY;

ARCHITECTURE structural OF network IS
    TYPE layer_outputs IS ARRAY(0 TO Nb_Layers) OF tab_int_const;
    SIGNAL layer_signals : layer_outputs := (OTHERS => (OTHERS => 0));
    
    FUNCTION nb_neurons(layer : integer) RETURN integer IS
    BEGIN
            RETURN N / (2 ** (layer - 1));
    END FUNCTION;

BEGIN
    -- Connexion des entrées globales au signal de la "couche 0"
    GEN_IN_NET : FOR i IN 1 TO N GENERATE
        layer_signals(0)(i) <= input(i);
    END GENERATE;

    -- Génération structurelle des couches
    GEN_LAYERS : FOR layer IN 1 TO Nb_Layers GENERATE
        GEN_NEURONS : FOR neuron_idx IN 1 TO N GENERATE
            
            -- On n'instancie que le nombre nécessaire de neurones par couche
            ACTIVE_NEURONS : IF neuron_idx <= nb_neurons(layer) GENERATE
                
                SIGNAL neuron_input_bus : tab_int_const := (OTHERS => 0);
                
            BEGIN
                -- Gestion du bus d'entrée du neurone (padding à 0 si la couche précédente est plus petite)
                GEN_BUS : FOR k IN 1 TO N GENERATE
                    BUS_DATA : IF k <= nb_neurons(layer - 1) GENERATE
                        neuron_input_bus(k) <= layer_signals(layer-1)(k);
                    END GENERATE;
                    BUS_ZERO : IF k > nb_neurons(layer - 1) GENERATE
                        neuron_input_bus(k) <= 0;
                    END GENERATE;
                END GENERATE;

                -- Instantiation du composant neurone synchrone
                INST_NEURON : ENTITY work.neuron
                    GENERIC MAP (
                        wi => Wi_LUT(layer, neuron_idx) -- Chargement des poids depuis la LUT
                    )
                    PORT MAP (
                        clk    => clk,
                        input  => neuron_input_bus,
                        output => layer_signals(layer)(neuron_idx)
                    );
            END GENERATE ACTIVE_NEURONS;

        END GENERATE GEN_NEURONS;
    END GENERATE GEN_LAYERS;

    -- 3. Affectation des sorties finales du réseau
    output(1) <= layer_signals(Nb_Layers)(1);
    output(2) <= layer_signals(Nb_Layers)(2);

END ARCHITECTURE;
