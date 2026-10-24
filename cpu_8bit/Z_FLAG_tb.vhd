
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Z_FLAG_tb IS
END Z_FLAG_tb;

ARCHITECTURE behavior OF Z_FLAG_tb IS

    COMPONENT Z_FLAG
        PORT (
            CLK     : IN  STD_LOGIC;
            RESET   : IN  STD_LOGIC;
            ENABLE  : IN  STD_LOGIC;
            DATA_IN : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
            Z_OUT   : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL CLK     : STD_LOGIC := '0';
    SIGNAL RESET   : STD_LOGIC := '0';
    SIGNAL ENABLE  : STD_LOGIC := '0';
    SIGNAL DATA_IN : STD_LOGIC_VECTOR(7 DOWNTO 0) := x"00";
    SIGNAL Z_OUT   : STD_LOGIC;

BEGIN

    -- Instantiate the Z flag register
    uut: Z_FLAG
        PORT MAP (
            CLK     => CLK,
            RESET   => RESET,
            ENABLE  => ENABLE,
            DATA_IN => DATA_IN,
            Z_OUT   => Z_OUT
        );

    -- Generate a 100 ns clock period
    CLK <= NOT CLK AFTER 50 ns;

    -- Apply test inputs
    stim_proc: PROCESS
    BEGIN

        -- Test 1: Reset
        RESET <= '1';
        ENABLE <= '0';
        WAIT FOR 100 ns;

        -- Test 2: Nonzero result
        RESET <= '0';
        ENABLE <= '1';
        DATA_IN <= x"FF";
        WAIT FOR 100 ns;

        -- Test 3: Zero result
        DATA_IN <= x"00";
        WAIT FOR 100 ns;

        -- Test 4: Another nonzero result
        DATA_IN <= x"55";
        WAIT FOR 100 ns;

        -- Test 5: Disable update and check retention
        ENABLE <= '0';
        DATA_IN <= x"00";
        WAIT FOR 100 ns;

        WAIT;
    END PROCESS;

END behavior;