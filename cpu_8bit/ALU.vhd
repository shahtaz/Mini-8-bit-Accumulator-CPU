library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    Port (
        OPCODE  : in  STD_LOGIC_VECTOR(3 downto 0);
        OPERAND : in  STD_LOGIC_VECTOR(7 downto 0);
        ACC_IN  : in  STD_LOGIC_VECTOR(7 downto 0);
        ALU_OUT : out STD_LOGIC_VECTOR(7 downto 0)
    );
end ALU;

architecture Behavioral of ALU is
begin
    process(OPCODE, OPERAND, ACC_IN)
    begin
        case OPCODE is
            when "0001" =>  -- LDI
                ALU_OUT <= OPERAND;
            when "0010" =>  -- ADD (carry discarded)
                ALU_OUT <= std_logic_vector(unsigned(ACC_IN) + unsigned(OPERAND));
            when "0111" =>  -- NOT
                ALU_OUT <= not ACC_IN;
            when "1000" =>  -- SHL (0 enters LSB)
                ALU_OUT <= ACC_IN(6 downto 0) & '0';
            when others =>  -- NOP: pass ACC through
                ALU_OUT <= ACC_IN;
        end case;
    end process;
end Behavioral;