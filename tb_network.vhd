LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.pack_neuralnet.ALL;  -- ajoute cette ligne !

ENTITY tb_network IS
END ENTITY;

ARCHITECTURE sim OF tb_network IS
	SIGNAL clk_test    : std_logic := '0';
    SIGNAL input_test  : tab_int_const := (OTHERS => 0);
    SIGNAL output_test : tab_layer(1 TO 2);  -- remet tab_layer
	CONSTANT period : time := 10 ns;

BEGIN
    DUT : ENTITY work.network
        GENERIC MAP (Nb_Layers => 3)
        PORT MAP (
			clk    => clk_test, 
            input  => input_test,
            output => output_test
        );

	-- Génération de l'horloge
    clk_process : PROCESS
    BEGIN
        clk_test <= '0';
        WAIT FOR period / 2;
        clk_test <= '1';
        WAIT FOR period / 2;
    END PROCESS;
			
    -- Processus de stimuli
    stimuli_process : PROCESS
    BEGIN
        -- Initialisation
        input_test <= (OTHERS => 0);
        WAIT FOR 20 ns;
        -- T1 : Entrées faibles
        input_test <= (1,0,1,0,1,0,1,0);
        WAIT FOR 100 ns; -- On attend plus longtemps pour laisser le signal traverser les couches
        -- T2 : Entrées moyennes
        input_test <= (1,1,1,1,1,1,1,1);
        WAIT FOR 100 ns;
        -- T3: Entrées fortes (Vmax probable)
        input_test <= (16,16,16,16,16,16,16,16);
        WAIT FOR 100 ns;
        -- T4 : Entrées maximales (6 bits)
        input_test <= (63,63,63,63,63,63,63,63);
        WAIT FOR 100 ns;
        WAIT;
    END PROCESS;

END ARCHITECTURE;
