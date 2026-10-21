library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CONTROL_UNIT is
    Port (
        OPCODE  : in  STD_LOGIC_VECTOR(3 downto 0);
        Z_IN    : in  STD_LOGIC;                      -- renamed (was Z_FLAG)
        ACC_EN  : out STD_LOGIC;
        ALU_SEL : out STD_LOGIC_VECTOR(3 downto 0);
        JUMP_EN : out STD_LOGIC
    );
end CONTROL_UNIT;

architecture Behavioral of CONTROL_UNIT is
begin
    process(OPCODE, Z_IN)
    begin
        -- Defaults = NOP
        ACC_EN  <= '0';
        ALU_SEL <= "0000";
        JUMP_EN <= '0';

        case OPCODE is
            when "0001" =>              -- LDI
                ACC_EN  <= '1';
                ALU_SEL <= OPCODE;

            when "0010" =>              -- ADD
                ACC_EN  <= '1';
                ALU_SEL <= OPCODE;

            when "0111" =>              -- NOT
                ACC_EN  <= '1';
                ALU_SEL <= OPCODE;

            when "1000" =>              -- SHL
                ACC_EN  <= '1';
                ALU_SEL <= OPCODE;

            when "1100" =>              -- JZ (ACC and Z unchanged)
                if Z_IN = '1' then
                    JUMP_EN <= '1';
                end if;

            when others =>              -- NOP
                null;
        end case;
    end process;
end Behavioral;