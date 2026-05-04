LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.pack_neuralnet.ALL;

ENTITY network IS
    GENERIC (
        Nb_Layers : positive := 3
    );
    PORT (
        input  : IN  tab_int_const;
        output : OUT tab_int(1 TO 2)
    );
END ENTITY;

ARCHITECTURE behavioral OF network IS
    TYPE layer_outputs IS ARRAY(0 TO Nb_Layers) OF tab_int(1 TO N);
    
    FUNCTION nb_neurons(layer : integer) RETURN integer IS
    BEGIN
        IF layer <= 0 THEN
            RETURN N;
        ELSE
            RETURN N / (2 ** (layer - 1));
        END IF;
    END FUNCTION;

BEGIN

    PROCESS(input)
        VARIABLE layer_out : layer_outputs := (OTHERS => (OTHERS => 0));
        VARIABLE weighted_sum : integer := 0;
    BEGIN
        -- Connecter les entrées à la couche 0
        FOR i IN 1 TO N LOOP
            layer_out(0)(i) := input(i);
        END LOOP;

        -- Calculer chaque couche
        FOR layer IN 1 TO Nb_Layers LOOP
            FOR neuron_idx IN 1 TO nb_neurons(layer) LOOP
                weighted_sum := 0;
                FOR k IN 1 TO nb_neurons(layer - 1) LOOP
                    weighted_sum := weighted_sum + 
                        Wi_LUT(layer, neuron_idx)(k) * layer_out(layer-1)(k);
                END LOOP;
                IF weighted_sum > T THEN
                    layer_out(layer)(neuron_idx) := Vmax;
                ELSE
                    layer_out(layer)(neuron_idx) := Vmin;
                END IF;
            END LOOP;
        END LOOP;

        -- Sorties
        output(1) <= layer_out(Nb_Layers)(1);
        output(2) <= layer_out(Nb_Layers)(2);

    END PROCESS;

END ARCHITECTURE;
