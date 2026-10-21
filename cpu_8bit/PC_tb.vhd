LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY PC_tb IS
END PC_tb;

ARCHITECTURE behavior OF PC_tb IS

    COMPONENT PC
    PORT(
         CLK       : IN  std_logic;
         RESET     : IN  std_logic;
         JUMP_EN   : IN  std_logic;
         JUMP_ADDR : IN  std_logic_vector(3 downto 0);
         PC_OUT    : OUT std_logic_vector(3 downto 0)
    );
    END COMPONENT;

    SIGNAL CLK       : std_logic := '0';
    SIGNAL RESET     : std_logic := '0';
    SIGNAL JUMP_EN   : std_logic := '0';
    SIGNAL JUMP_ADDR : std_logic_vector(3 downto 0) := "0000";
    SIGNAL PC_OUT    : std_logic_vector(3 downto 0);

    CONSTANT CLK_period : time := 10 ns;

BEGIN

    uut: PC PORT MAP (
        CLK       => CLK,
        RESET     => RESET,
        JUMP_EN   => JUMP_EN,
        JUMP_ADDR => JUMP_ADDR,
        PC_OUT    => PC_OUT
    );

    CLK_process: PROCESS
    BEGIN
        CLK <= '0';
        WAIT FOR CLK_period / 2;
        CLK <= '1';
        WAIT FOR CLK_period / 2;
    END PROCESS;

    stim_proc: PROCESS
    BEGIN
        -- Reset PC to 0
        RESET <= '1';
        WAIT UNTIL rising_edge(CLK);
        WAIT FOR 1 ns;

        -- Increment PC
        RESET <= '0';
        WAIT UNTIL rising_edge(CLK);
        WAIT FOR 1 ns;

        WAIT UNTIL rising_edge(CLK);
        WAIT FOR 1 ns;

        -- Jump to address 5
        JUMP_EN <= '1';
        JUMP_ADDR <= "0101";
        WAIT UNTIL rising_edge(CLK);
        WAIT FOR 1 ns;

        -- Increment after jump
        JUMP_EN <= '0';
        WAIT UNTIL rising_edge(CLK);
        WAIT FOR 1 ns;

        WAIT;
    END PROCESS;

END behavior;