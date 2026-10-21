library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    Port (
        OPCODE   : in  STD_LOGIC_VECTOR(3 downto 0);
        OPERAND  : in  STD_LOGIC_VECTOR(7 downto 0);
        ACC_IN   : in  STD_LOGIC_VECTOR(7 downto 0);
        ALU_OUT  : out STD_LOGIC_VECTOR(7 downto 0)
    );
end ALU;

architecture Behavioral of ALU is

begin

    process(OPCODE, OPERAND, ACC_IN)
    begin
        case OPCODE is

            -- LDI: Load immediate operand
            when "0001" =>
                ALU_OUT <= OPERAND;

            -- ADD: Add operand to accumulator
            when "0010" =>
                ALU_OUT <= std_logic_vector(
                    unsigned(ACC_IN) + unsigned(OPERAND)
                );

            -- NOT: Invert all accumulator bits
            when "0111" =>
                ALU_OUT <= not ACC_IN;

            -- SHL: Shift accumulator left by one bit
            when "1000" =>
                ALU_OUT <= ACC_IN(6 downto 0) & '0';

            -- Unsupported instruction: no operation
            when others =>
                ALU_OUT <= ACC_IN;

        end case;
    end process;

end Behavioral;