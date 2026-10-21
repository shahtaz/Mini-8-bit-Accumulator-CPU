LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ROM_tb IS
END ROM_tb;

ARCHITECTURE behavior OF ROM_tb IS

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT ROM
    PORT(
         ADDRESS     : IN  std_logic_vector(3 downto 0);
         INSTRUCTION : OUT std_logic_vector(11 downto 0)
        );
    END COMPONENT;

    -- Inputs
    signal ADDRESS : std_logic_vector(3 downto 0) := (others => '0');

    -- Outputs
    signal INSTRUCTION : std_logic_vector(11 downto 0);

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: ROM PORT MAP (
          ADDRESS     => ADDRESS,
          INSTRUCTION => INSTRUCTION
        );

    -- Stimulus process
    stim_proc: process
    begin

        ADDRESS <= "0000";
        wait for 10 ns;

        ADDRESS <= "0001";
        wait for 10 ns;

        ADDRESS <= "0010";
        wait for 10 ns;

        ADDRESS <= "0011";
        wait for 10 ns;

        ADDRESS <= "0100";
        wait for 10 ns;

        ADDRESS <= "0101";
        wait for 10 ns;

        ADDRESS <= "0110";
        wait for 10 ns;

        ADDRESS <= "0111";
        wait for 10 ns;

        ADDRESS <= "1000";
        wait for 10 ns;

        ADDRESS <= "1001";
        wait for 10 ns;

        ADDRESS <= "1010";
        wait for 10 ns;

        ADDRESS <= "1011";
        wait for 10 ns;

        ADDRESS <= "1100";
        wait for 10 ns;

        ADDRESS <= "1101";
        wait for 10 ns;

        ADDRESS <= "1110";
        wait for 10 ns;

        ADDRESS <= "1111";
        wait for 10 ns;

        wait;
    end process;

END behavior;