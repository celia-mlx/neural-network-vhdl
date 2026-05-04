LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.pack_neuralnet.ALL;

ENTITY network IS
    GENERIC (
        Nb_Layers : positive := 3 -- Number of layers in the network
    );
    PORT (
        clk    : IN  std_logic;       -- Global clock signal for synchronization
        input  : IN  tab_int_const;   -- Global network inputs
        output : OUT tab_layer(1 TO 2) -- Final network outputs
    );
END ENTITY;

ARCHITECTURE structural OF network IS
    -- Array to store signals between each layer
    TYPE layer_outputs IS ARRAY(0 TO Nb_Layers) OF tab_int_const;
    SIGNAL layer_signals : layer_outputs := (OTHERS => (OTHERS => 0));
    
    -- Function to calculate the number of active neurons per layer
    FUNCTION nb_neurons(layer : integer) RETURN integer IS
    BEGIN
            RETURN N / (2 ** (layer - 1));
    END FUNCTION;

BEGIN
    -- Connecting global inputs to the "layer 0" signal
    GEN_IN_NET : FOR i IN 1 TO N GENERATE
        layer_signals(0)(i) <= input(i);
    END GENERATE;

    -- Structural generation of layers
    GEN_LAYERS : FOR layer IN 1 TO Nb_Layers GENERATE
        GEN_NEURONS : FOR neuron_idx IN 1 TO N GENERATE
            
            -- Instantiating only the required number of neurons per layer
            ACTIVE_NEURONS : IF neuron_idx <= nb_neurons(layer) GENERATE
                
                SIGNAL neuron_input_bus : tab_int_const := (OTHERS => 0);
                
            BEGIN
                -- Management of the neuron input bus (zero-padding if the previous layer is smaller)
                GEN_BUS : FOR k IN 1 TO N GENERATE
                    BUS_DATA : IF k <= nb_neurons(layer - 1) GENERATE
                        neuron_input_bus(k) <= layer_signals(layer-1)(k);
                    END GENERATE;
                    BUS_ZERO : IF k > nb_neurons(layer - 1) GENERATE
                        neuron_input_bus(k) <= 0;
                    END GENERATE;
                END GENERATE;

                -- Instantiation of the synchronous neuron component
                INST_NEURON : ENTITY work.neuron
                    GENERIC MAP (
                        wi => Wi_LUT(layer, neuron_idx) -- Loading weights from the LUT
                    )
                    PORT MAP (
                        clk    => clk,
                        input  => neuron_input_bus,
                        output => layer_signals(layer)(neuron_idx)
                    );
            END GENERATE ACTIVE_NEURONS;

        END GENERATE GEN_NEURONS;
    END GENERATE GEN_LAYERS;

    -- 3. Assignment of the final network outputs
    output(1) <= layer_signals(Nb_Layers)(1);
    output(2) <= layer_signals(Nb_Layers)(2);

END ARCHITECTURE;
