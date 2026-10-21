
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ACC is
    Port (
        CLK     : in  STD_LOGIC;
        RESET   : in  STD_LOGIC;
        ENABLE  : in  STD_LOGIC;
        DATA_IN : in  STD_LOGIC_VECTOR(7 downto 0);
        ACC_OUT : out STD_LOGIC_VECTOR(7 downto 0)
    );
end ACC;

architecture Behavioral of ACC is

    signal acc_reg : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');

begin

    process(CLK)
    begin
        if rising_edge(CLK) then
            if RESET = '1' then
                acc_reg <= (others => '0');
            elsif ENABLE = '1' then
                acc_reg <= DATA_IN;
            end if;
        end if;
    end process;

    ACC_OUT <= acc_reg;

end Behavioral;