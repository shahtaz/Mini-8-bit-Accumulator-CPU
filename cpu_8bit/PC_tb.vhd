library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PC_tb is
end PC_tb;

architecture behavior of PC_tb is

    component PC
        Port (
            CLK       : in  STD_LOGIC;
            RESET     : in  STD_LOGIC;
            JUMP_EN   : in  STD_LOGIC;
            JUMP_ADDR : in  STD_LOGIC_VECTOR(3 downto 0);
            PC_OUT    : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    signal CLK       : STD_LOGIC := '0';
    signal RESET     : STD_LOGIC := '1';
    signal JUMP_EN   : STD_LOGIC := '0';
    signal JUMP_ADDR : STD_LOGIC_VECTOR(3 downto 0) := x"0";
    signal PC_OUT    : STD_LOGIC_VECTOR(3 downto 0);
    signal done      : boolean := false;

begin

    uut : PC
        port map (CLK => CLK, RESET => RESET, JUMP_EN => JUMP_EN,
                  JUMP_ADDR => JUMP_ADDR, PC_OUT => PC_OUT);

    -- 100 ns clock, stops when the test ends
    clk_proc : process
    begin
        while not done loop
            CLK <= '0'; wait for 50 ns;
            CLK <= '1'; wait for 50 ns;
        end loop;
        wait;
    end process;

    stim_proc : process
    begin
        -- Test 1: reset
        RESET <= '1'; JUMP_EN <= '0'; JUMP_ADDR <= x"0";
        wait until rising_edge(CLK); wait for 1 ns;
        assert PC_OUT = x"0" report "FAIL: Test 1 reset" severity error;

        -- Test 2: count to 1
        RESET <= '0';
        wait until rising_edge(CLK); wait for 1 ns;
        assert PC_OUT = x"1" report "FAIL: Test 2 count" severity error;

        -- Test 3: count to 2
        wait until rising_edge(CLK); wait for 1 ns;
        assert PC_OUT = x"2" report "FAIL: Test 3 count" severity error;

        -- Test 4: jump to 5
        JUMP_EN <= '1'; JUMP_ADDR <= x"5";
        wait until rising_edge(CLK); wait for 1 ns;
        assert PC_OUT = x"5" report "FAIL: Test 4 jump" severity error;

        -- Test 5: count after jump
        JUMP_EN <= '0';
        wait until rising_edge(CLK); wait for 1 ns;
        assert PC_OUT = x"6" report "FAIL: Test 5 count after jump" severity error;

        -- Test 6: reset has priority over jump
        RESET <= '1'; JUMP_EN <= '1'; JUMP_ADDR <= x"9";
        wait until rising_edge(CLK); wait for 1 ns;
        assert PC_OUT = x"0" report "FAIL: Test 6 reset priority" severity error;

        -- Test 7: jump to 15
        RESET <= '0'; JUMP_EN <= '1'; JUMP_ADDR <= x"F";
        wait until rising_edge(CLK); wait for 1 ns;
        assert PC_OUT = x"F" report "FAIL: Test 7 jump to 15" severity error;

        -- Test 8: wrap from 15 to 0
        JUMP_EN <= '0';
        wait until rising_edge(CLK); wait for 1 ns;
        assert PC_OUT = x"0" report "FAIL: Test 8 wrap around" severity error;

        report "PC_tb finished: if no FAIL message appeared, all tests passed."
            severity note;
        done <= true;
        wait;
    end process;

end behavior;