LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.pack_neuralnet.ALL; 

ENTITY tb_network IS
END ENTITY;

ARCHITECTURE sim OF tb_network IS
    SIGNAL clk_test    : std_logic := '0';
    SIGNAL input_test  : tab_int_const := (OTHERS => 0);
    SIGNAL output_test : tab_layer(1 TO 2);  
    CONSTANT period : time := 10 ns;

BEGIN
    DUT : ENTITY work.network
        GENERIC MAP (Nb_Layers => 3)
        PORT MAP (
            clk    => clk_test, 
            input  => input_test,
            output => output_test
        );

    -- Clock generation
    clk_process : PROCESS
    BEGIN
        clk_test <= '0';
        WAIT FOR period / 2;
        clk_test <= '1';
        WAIT FOR period / 2;
    END PROCESS;
            
    -- Stimuli process
    stimuli_process : PROCESS
    BEGIN
        -- Initialization
        input_test <= (OTHERS => 0);
        WAIT FOR 20 ns;

        -- T1: Low inputs
        input_test <= (1,0,1,0,1,0,1,0);
        WAIT FOR 100 ns; 

        -- T2: Average inputs
        input_test <= (1,1,1,1,1,1,1,1);
        WAIT FOR 100 ns;

        -- T3: High inputs (likely Vmax)
        input_test <= (16,16,16,16,16,16,16,16);
        WAIT FOR 100 ns;

        -- T4: Maximum inputs (6 bits)
        input_test <= (63,63,63,63,63,63,63,63);
        WAIT FOR 100 ns;

        WAIT;
    END PROCESS;

END ARCHITECTURE;
