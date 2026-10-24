library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU_tb is
end ALU_tb;

architecture behavior of ALU_tb is

    component ALU
        Port (
            OPCODE  : in  STD_LOGIC_VECTOR(3 downto 0);
            OPERAND : in  STD_LOGIC_VECTOR(7 downto 0);
            ACC_IN  : in  STD_LOGIC_VECTOR(7 downto 0);
            ALU_OUT : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    signal OPCODE  : STD_LOGIC_VECTOR(3 downto 0) := x"0";
    signal OPERAND : STD_LOGIC_VECTOR(7 downto 0) := x"00";
    signal ACC_IN  : STD_LOGIC_VECTOR(7 downto 0) := x"00";
    signal ALU_OUT : STD_LOGIC_VECTOR(7 downto 0);

begin

    uut : ALU
        port map (OPCODE => OPCODE, OPERAND => OPERAND,
                  ACC_IN => ACC_IN, ALU_OUT => ALU_OUT);

    stim_proc : process
    begin
        -- Test 1: LDI 0xA5
        OPCODE <= "0001"; OPERAND <= x"A5"; ACC_IN <= x"00"; wait for 10 ns;
        assert ALU_OUT = x"A5" report "FAIL: Test 1 LDI" severity error;

        -- Test 2: ADD 0x11 to 0x00
        OPCODE <= "0010"; OPERAND <= x"11"; ACC_IN <= x"00"; wait for 10 ns;
        assert ALU_OUT = x"11" report "FAIL: Test 2 ADD" severity error;

        -- Test 3: ADD with carry discarded (F0 + 20 = 110 -> 10)
        OPCODE <= "0010"; OPERAND <= x"20"; ACC_IN <= x"F0"; wait for 10 ns;
        assert ALU_OUT = x"10" report "FAIL: Test 3 ADD carry" severity error;

        -- Test 4: NOT 0xFF
        OPCODE <= "0111"; OPERAND <= x"00"; ACC_IN <= x"FF"; wait for 10 ns;
        assert ALU_OUT = x"00" report "FAIL: Test 4 NOT FF" severity error;

        -- Test 5: NOT 0x55
        OPCODE <= "0111"; OPERAND <= x"00"; ACC_IN <= x"55"; wait for 10 ns;
        assert ALU_OUT = x"AA" report "FAIL: Test 5 NOT 55" severity error;

        -- Test 6: SHL 0x11
        OPCODE <= "1000"; OPERAND <= x"00"; ACC_IN <= x"11"; wait for 10 ns;
        assert ALU_OUT = x"22" report "FAIL: Test 6 SHL 11" severity error;

        -- Test 7: SHL 0x80 (MSB lost)
        OPCODE <= "1000"; OPERAND <= x"00"; ACC_IN <= x"80"; wait for 10 ns;
        assert ALU_OUT = x"00" report "FAIL: Test 7 SHL 80" severity error;

        -- Test 8: NOP passes ACC through
        OPCODE <= "0000"; OPERAND <= x"FF"; ACC_IN <= x"44"; wait for 10 ns;
        assert ALU_OUT = x"44" report "FAIL: Test 8 NOP" severity error;

        -- Test 9: unsupported opcode passes ACC through
        OPCODE <= "0011"; OPERAND <= x"FF"; ACC_IN <= x"44"; wait for 10 ns;
        assert ALU_OUT = x"44" report "FAIL: Test 9 unsupported opcode" severity error;

        report "ALU_tb finished: if no FAIL message appeared, all tests passed."
            severity note;
        wait;
    end process;

end behavior;