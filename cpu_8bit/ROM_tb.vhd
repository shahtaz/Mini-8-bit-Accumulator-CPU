library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ROM_tb is
end ROM_tb;

architecture behavior of ROM_tb is

    component ROM
        Port (
            ADDRESS     : in  STD_LOGIC_VECTOR(3 downto 0);
            INSTRUCTION : out STD_LOGIC_VECTOR(11 downto 0)
        );
    end component;

    signal ADDRESS     : STD_LOGIC_VECTOR(3 downto 0) := x"0";
    signal INSTRUCTION : STD_LOGIC_VECTOR(11 downto 0);

begin

    uut : ROM
        port map (ADDRESS => ADDRESS, INSTRUCTION => INSTRUCTION);

    stim_proc : process
    begin
        ADDRESS <= x"0"; wait for 10 ns;
        assert INSTRUCTION = x"1FF" report "FAIL: addr 0 LDI 0xFF" severity error;

        ADDRESS <= x"1"; wait for 10 ns;
        assert INSTRUCTION = x"700" report "FAIL: addr 1 NOT" severity error;

        ADDRESS <= x"2"; wait for 10 ns;
        assert INSTRUCTION = x"C05" report "FAIL: addr 2 JZ 0x05" severity error;

        ADDRESS <= x"3"; wait for 10 ns;
        assert INSTRUCTION = x"277" report "FAIL: addr 3 ADD 0x77" severity error;

        ADDRESS <= x"4"; wait for 10 ns;
        assert INSTRUCTION = x"277" report "FAIL: addr 4 ADD 0x77" severity error;

        ADDRESS <= x"5"; wait for 10 ns;
        assert INSTRUCTION = x"211" report "FAIL: addr 5 ADD 0x11" severity error;

        ADDRESS <= x"6"; wait for 10 ns;
        assert INSTRUCTION = x"800" report "FAIL: addr 6 SHL" severity error;

        ADDRESS <= x"7"; wait for 10 ns;
        assert INSTRUCTION = x"C00" report "FAIL: addr 7 JZ 0x00" severity error;

        ADDRESS <= x"8"; wait for 10 ns;
        assert INSTRUCTION = x"800" report "FAIL: addr 8 SHL" severity error;

        ADDRESS <= x"9"; wait for 10 ns;
        assert INSTRUCTION = x"000" report "FAIL: addr 9 should be NOP" severity error;

        ADDRESS <= x"F"; wait for 10 ns;
        assert INSTRUCTION = x"000" report "FAIL: addr 15 should be NOP" severity error;

        report "ROM_tb finished: if no FAIL message appeared, all tests passed."
            severity note;
        wait;
    end process;

end behavior;