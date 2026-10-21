
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Z_FLAG is
    Port (
        CLK     : in  STD_LOGIC;
        RESET   : in  STD_LOGIC;
        ENABLE  : in  STD_LOGIC;
        DATA_IN : in  STD_LOGIC_VECTOR(7 downto 0);
        Z_OUT   : out STD_LOGIC
    );
end Z_FLAG;

architecture Behavioral of Z_FLAG is

    signal z_reg : STD_LOGIC := '1';

begin

    process(CLK)
    begin
        if rising_edge(CLK) then
            if RESET = '1' then
                z_reg <= '1';

            elsif ENABLE = '1' then
                if DATA_IN = x"00" then
                    z_reg <= '1';
                else
                    z_reg <= '0';
                end if;
            end if;
        end if;
    end process;

    Z_OUT <= z_reg;

end Behavioral;