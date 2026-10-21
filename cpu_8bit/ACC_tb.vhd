
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ACC_tb IS
END ACC_tb;

ARCHITECTURE behavior OF ACC_tb IS

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT ACC
    PORT(
         CLK     : IN  std_logic;
         RESET   : IN  std_logic;
         ENABLE  : IN  std_logic;
         DATA_IN : IN  std_logic_vector(7 downto 0);
         ACC_OUT : OUT std_logic_vector(7 downto 0)
        );
    END COMPONENT;

    -- Inputs
    signal CLK     : std_logic := '0';
    signal RESET   : std_logic := '0';
    signal ENABLE  : std_logic := '0';
    signal DATA_IN : std_logic_vector(7 downto 0) := (others => '0');

    -- Output
    signal ACC_OUT : std_logic_vector(7 downto 0);

    -- Clock period
    constant CLK_period : time := 10 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: ACC PORT MAP (
          CLK     => CLK,
          RESET   => RESET,
          ENABLE  => ENABLE,
          DATA_IN => DATA_IN,
          ACC_OUT => ACC_OUT
        );

    -- Clock process
    CLK_process: process
    begin
        CLK <= '0';
        wait for CLK_period / 2;
        CLK <= '1';
        wait for CLK_period / 2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin

        -- Wait for 100 ns
        wait for 100 ns;

        -- Test 1: Reset the accumulator
        RESET <= '1';
        ENABLE <= '0';
        wait for CLK_period;

        -- Release reset
        RESET <= '0';
        wait for CLK_period;

        -- Test 2: Load FF into the accumulator
        ENABLE <= '1';
        DATA_IN <= x"FF";
        wait for CLK_period;

        -- Test 3: Load 25 into the accumulator
        DATA_IN <= x"25";
        wait for CLK_period;

        -- Test 4: Disable enable and hold previous value (25)
        ENABLE <= '0';
        DATA_IN <= x"AA";
        wait for CLK_period;

        -- Test 5: Reset while accumulator contains 25
        RESET <= '1';
        wait for CLK_period;

        -- Release reset
        RESET <= '0';
        wait for CLK_period;

        -- Test 6: Load 80 into the accumulator
        ENABLE <= '1';
        DATA_IN <= x"80";
        wait for CLK_period;

        wait;
    end process;

END behavior;