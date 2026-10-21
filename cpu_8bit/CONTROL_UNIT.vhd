
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CONTROL_UNIT is
    Port (
        OPCODE   : in  STD_LOGIC_VECTOR(3 downto 0);
        Z_FLAG   : in  STD_LOGIC;
        ACC_EN   : out STD_LOGIC;
        ALU_SEL  : out STD_LOGIC_VECTOR(3 downto 0);
        JUMP_EN  : out STD_LOGIC
    );
end CONTROL_UNIT;

architecture Behavioral of CONTROL_UNIT is

begin

    process(OPCODE, Z_FLAG)
    begin

        -- Default control signals
        ACC_EN  <= '0';
        ALU_SEL <= OPCODE;
        JUMP_EN <= '0';

        case OPCODE is

            -- LDI: Load immediate value into ACC
            when "0001" =>
                ACC_EN <= '1';

            -- ADD: Add operand to ACC
            when "0010" =>
                ACC_EN <= '1';

            -- NOT: Invert ACC bits
            when "0111" =>
                ACC_EN <= '1';

            -- SHL: Shift ACC left by one bit
            when "1000" =>
                ACC_EN <= '1';

            -- JZ: Jump if Z flag is 1
            when "1100" =>
                if Z_FLAG = '1' then
                    JUMP_EN <= '1';
                end if;

            -- Unsupported opcode: NOP
            when others =>
                null;

        end case;

    end process;

end Behavioral;