library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ROM is
    Port (
        ADDRESS     : in  STD_LOGIC_VECTOR(3 downto 0);
        INSTRUCTION : out STD_LOGIC_VECTOR(11 downto 0)
    );
end ROM;

architecture Behavioral of ROM is
begin
    -- Set 9 program (Appendix B)
    process(ADDRESS)
    begin
        case ADDRESS is
            when "0000" => INSTRUCTION <= x"1FF"; -- 0: LDI 0xFF
            when "0001" => INSTRUCTION <= x"700"; -- 1: NOT
            when "0010" => INSTRUCTION <= x"C05"; -- 2: JZ  0x05
            when "0011" => INSTRUCTION <= x"277"; -- 3: ADD 0x77 (skipped)
            when "0100" => INSTRUCTION <= x"277"; -- 4: ADD 0x77 (skipped)
            when "0101" => INSTRUCTION <= x"211"; -- 5: ADD 0x11
            when "0110" => INSTRUCTION <= x"800"; -- 6: SHL
            when "0111" => INSTRUCTION <= x"C00"; -- 7: JZ  0x00
            when "1000" => INSTRUCTION <= x"800"; -- 8: SHL
            when others => INSTRUCTION <= x"000"; -- NOP
        end case;
    end process;
end Behavioral;