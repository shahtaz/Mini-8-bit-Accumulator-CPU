library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CONTROL_UNIT_tb is
end CONTROL_UNIT_tb;

architecture behavior of CONTROL_UNIT_tb is

    component CONTROL_UNIT
        Port (
            OPCODE  : in  STD_LOGIC_VECTOR(3 downto 0);
            Z_IN    : in  STD_LOGIC;
            ACC_EN  : out STD_LOGIC;
            ALU_SEL : out STD_LOGIC_VECTOR(3 downto 0);
            JUMP_EN : out STD_LOGIC
        );
    end component;

    signal OPCODE  : STD_LOGIC_VECTOR(3 downto 0) := x"0";
    signal Z_IN    : STD_LOGIC := '0';
    signal ACC_EN  : STD_LOGIC;
    signal ALU_SEL : STD_LOGIC_VECTOR(3 downto 0);
    signal JUMP_EN : STD_LOGIC;

begin

    uut : CONTROL_UNIT
        port map (OPCODE => OPCODE, Z_IN => Z_IN, ACC_EN => ACC_EN,
                  ALU_SEL => ALU_SEL, JUMP_EN => JUMP_EN);

    stim_proc : process
    begin
        -- Test 1: LDI
        OPCODE <= "0001"; Z_IN <= '0'; wait for 10 ns;
        assert (ACC_EN = '1' and ALU_SEL = "0001" and JUMP_EN = '0')
            report "FAIL: Test 1 LDI" severity error;

        -- Test 2: ADD
        OPCODE <= "0010"; Z_IN <= '0'; wait for 10 ns;
        assert (ACC_EN = '1' and ALU_SEL = "0010" and JUMP_EN = '0')
            report "FAIL: Test 2 ADD" severity error;

        -- Test 3: NOT
        OPCODE <= "0111"; Z_IN <= '0'; wait for 10 ns;
        assert (ACC_EN = '1' and ALU_SEL = "0111" and JUMP_EN = '0')
            report "FAIL: Test 3 NOT" severity error;

        -- Test 4: SHL
        OPCODE <= "1000"; Z_IN <= '0'; wait for 10 ns;
        assert (ACC_EN = '1' and ALU_SEL = "1000" and JUMP_EN = '0')
            report "FAIL: Test 4 SHL" severity error;

        -- Test 5: JZ taken (Z = 1)
        OPCODE <= "1100"; Z_IN <= '1'; wait for 10 ns;
        assert (ACC_EN = '0' and ALU_SEL = "0000" and JUMP_EN = '1')
            report "FAIL: Test 5 JZ taken" severity error;

        -- Test 6: JZ not taken (Z = 0)
        OPCODE <= "1100"; Z_IN <= '0'; wait for 10 ns;
        assert (ACC_EN = '0' and ALU_SEL = "0000" and JUMP_EN = '0')
            report "FAIL: Test 6 JZ not taken" severity error;

        -- Test 7: NOP (opcode 0000)
        OPCODE <= "0000"; Z_IN <= '1'; wait for 10 ns;
        assert (ACC_EN = '0' and ALU_SEL = "0000" and JUMP_EN = '0')
            report "FAIL: Test 7 NOP" severity error;

        -- Test 8: unsupported opcode (SUB) acts as NOP
        OPCODE <= "0011"; Z_IN <= '1'; wait for 10 ns;
        assert (ACC_EN = '0' and ALU_SEL = "0000" and JUMP_EN = '0')
            report "FAIL: Test 8 unsupported opcode" severity error;

        report "CONTROL_UNIT_tb finished: if no FAIL message appeared, all tests passed."
            severity note;
        wait;
    end process;

end behavior;