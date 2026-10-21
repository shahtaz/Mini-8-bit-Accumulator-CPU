
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ALU_tb IS
END ALU_tb;

ARCHITECTURE behavior OF ALU_tb IS

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT ALU
    PORT(
         OPCODE  : IN  std_logic_vector(3 downto 0);
         OPERAND : IN  std_logic_vector(7 downto 0);
         ACC_IN  : IN  std_logic_vector(7 downto 0);
         ALU_OUT : OUT std_logic_vector(7 downto 0)
        );
    END COMPONENT;

    -- Inputs
    signal OPCODE  : std_logic_vector(3 downto 0) := (others => '0');
    signal OPERAND : std_logic_vector(7 downto 0) := (others => '0');
    signal ACC_IN  : std_logic_vector(7 downto 0) := (others => '0');

    -- Output
    signal ALU_OUT : std_logic_vector(7 downto 0);

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: ALU PORT MAP (
          OPCODE  => OPCODE,
          OPERAND => OPERAND,
          ACC_IN  => ACC_IN,
          ALU_OUT => ALU_OUT
        );

    -- Stimulus process
    stim_proc: process
    begin

        -- Wait for 100 ns before starting tests
        wait for 100 ns;

        -- Test 1: LDI FF
        OPCODE  <= "0001";
        OPERAND <= x"FF";
        ACC_IN  <= x"00";
        wait for 10 ns;

        -- Test 2: ADD 10 + 77 = 87
        OPCODE  <= "0010";
        OPERAND <= x"77";
        ACC_IN  <= x"10";
        wait for 10 ns;

        -- Test 3: ADD overflow FF + 01 = 00
        OPCODE  <= "0010";
        OPERAND <= x"01";
        ACC_IN  <= x"FF";
        wait for 10 ns;

        -- Test 4: NOT FF = 00
        OPCODE  <= "0111";
        OPERAND <= x"00";
        ACC_IN  <= x"FF";
        wait for 10 ns;

        -- Test 5: NOT 00 = FF
        OPCODE  <= "0111";
        OPERAND <= x"00";
        ACC_IN  <= x"00";
        wait for 10 ns;

        -- Test 6: SHL 81 = 02
        OPCODE  <= "1000";
        OPERAND <= x"00";
        ACC_IN  <= x"81";
        wait for 10 ns;

        -- Test 7: SHL 22 = 44
        OPCODE  <= "1000";
        OPERAND <= x"00";
        ACC_IN  <= x"22";
        wait for 10 ns;

        -- Test 8: Unsupported opcode
        OPCODE  <= "0000";
        OPERAND <= x"00";
        ACC_IN  <= x"5A";
        wait for 10 ns;

        -- End simulation
        wait;

    end process;

END behavior;