library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ACC_tb is
end ACC_tb;

architecture behavior of ACC_tb is

    component ACC
        Port (
            CLK     : in  STD_LOGIC;
            RESET   : in  STD_LOGIC;
            ENABLE  : in  STD_LOGIC;
            DATA_IN : in  STD_LOGIC_VECTOR(7 downto 0);
            ACC_OUT : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    signal CLK     : STD_LOGIC := '0';
    signal RESET   : STD_LOGIC := '1';
    signal ENABLE  : STD_LOGIC := '0';
    signal DATA_IN : STD_LOGIC_VECTOR(7 downto 0) := x"00";
    signal ACC_OUT : STD_LOGIC_VECTOR(7 downto 0);
    signal done    : boolean := false;

begin

    uut : ACC
        port map (CLK => CLK, RESET => RESET, ENABLE => ENABLE,
                  DATA_IN => DATA_IN, ACC_OUT => ACC_OUT);

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
        RESET <= '1'; ENABLE <= '0'; DATA_IN <= x"00";
        wait until rising_edge(CLK); wait for 1 ns;
        assert ACC_OUT = x"00" report "FAIL: Test 1 reset" severity error;

        -- Test 2: load 0xFF
        RESET <= '0'; ENABLE <= '1'; DATA_IN <= x"FF";
        wait until rising_edge(CLK); wait for 1 ns;
        assert ACC_OUT = x"FF" report "FAIL: Test 2 load FF" severity error;

        -- Test 3: hold when ENABLE = 0
        ENABLE <= '0'; DATA_IN <= x"12";
        wait until rising_edge(CLK); wait for 1 ns;
        assert ACC_OUT = x"FF" report "FAIL: Test 3 hold" severity error;

        -- Test 4: load 0x22
        ENABLE <= '1'; DATA_IN <= x"22";
        wait until rising_edge(CLK); wait for 1 ns;
        assert ACC_OUT = x"22" report "FAIL: Test 4 load 22" severity error;

        -- Test 5: reset has priority over enable
        RESET <= '1'; ENABLE <= '1'; DATA_IN <= x"44";
        wait until rising_edge(CLK); wait for 1 ns;
        assert ACC_OUT = x"00" report "FAIL: Test 5 reset priority" severity error;

        -- Test 6: load after reset
        RESET <= '0';
        wait until rising_edge(CLK); wait for 1 ns;
        assert ACC_OUT = x"44" report "FAIL: Test 6 load 44" severity error;

        report "ACC_tb finished: if no FAIL message appeared, all tests passed."
            severity note;
        done <= true;
        wait;
    end process;

end behavior;