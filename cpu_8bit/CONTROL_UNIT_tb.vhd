
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 

 
ENTITY CONTROL_UNIT_tb IS
END CONTROL_UNIT_tb;
 
ARCHITECTURE behavior OF CONTROL_UNIT_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CONTROL_UNIT
    PORT(
         OPCODE : IN  std_logic_vector(3 downto 0);
         Z_FLAG : IN  std_logic;
         ACC_EN : OUT  std_logic;
         ALU_SEL : OUT  std_logic_vector(3 downto 0);
         JUMP_EN : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal OPCODE : std_logic_vector(3 downto 0) := (others => '0');
   signal Z_FLAG : std_logic := '0';

 	--Outputs
   signal ACC_EN : std_logic;
   signal ALU_SEL : std_logic_vector(3 downto 0);
   signal JUMP_EN : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CONTROL_UNIT PORT MAP (
          OPCODE => OPCODE,
          Z_FLAG => Z_FLAG,
          ACC_EN => ACC_EN,
          ALU_SEL => ALU_SEL,
          JUMP_EN => JUMP_EN
        );

   -- Clock process definitions
   <clock>_process :process
   begin
		<clock> <= '0';
		wait for <clock>_period/2;
		<clock> <= '1';
		wait for <clock>_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for <clock>_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
