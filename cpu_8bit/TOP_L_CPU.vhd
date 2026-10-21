library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TOP_L_CPU is
    Port (
        CLK    : in  STD_LOGIC;
        RESET  : in  STD_LOGIC;
        Q      : out STD_LOGIC_VECTOR(7 downto 0);
        Z      : out STD_LOGIC;
        PC_OUT : out STD_LOGIC_VECTOR(3 downto 0)
    );
end TOP_L_CPU;

architecture Behavioral of TOP_L_CPU is

    signal pc_value    : STD_LOGIC_VECTOR(3 downto 0);
    signal instruction : STD_LOGIC_VECTOR(11 downto 0);
    signal opcode      : STD_LOGIC_VECTOR(3 downto 0);
    signal operand     : STD_LOGIC_VECTOR(7 downto 0);
    signal acc_value   : STD_LOGIC_VECTOR(7 downto 0);
    signal alu_result  : STD_LOGIC_VECTOR(7 downto 0);
    signal acc_en      : STD_LOGIC;
    signal alu_sel     : STD_LOGIC_VECTOR(3 downto 0);
    signal jump_en     : STD_LOGIC;
    signal z_value     : STD_LOGIC;

    component PC
        Port (
            CLK       : in  STD_LOGIC;
            RESET     : in  STD_LOGIC;
            JUMP_EN   : in  STD_LOGIC;
            JUMP_ADDR : in  STD_LOGIC_VECTOR(3 downto 0);
            PC_OUT    : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    component ROM
        Port (
            ADDRESS     : in  STD_LOGIC_VECTOR(3 downto 0);
            INSTRUCTION : out STD_LOGIC_VECTOR(11 downto 0)
        );
    end component;

    component ALU
        Port (
            OPCODE  : in  STD_LOGIC_VECTOR(3 downto 0);
            OPERAND : in  STD_LOGIC_VECTOR(7 downto 0);
            ACC_IN  : in  STD_LOGIC_VECTOR(7 downto 0);
            ALU_OUT : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    component ACC
        Port (
            CLK     : in  STD_LOGIC;
            RESET   : in  STD_LOGIC;
            ENABLE  : in  STD_LOGIC;
            DATA_IN : in  STD_LOGIC_VECTOR(7 downto 0);
            ACC_OUT : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    component CONTROL_UNIT
        Port (
            OPCODE  : in  STD_LOGIC_VECTOR(3 downto 0);
            Z_IN    : in  STD_LOGIC;
            ACC_EN  : out STD_LOGIC;
            ALU_SEL : out STD_LOGIC_VECTOR(3 downto 0);
            JUMP_EN : out STD_LOGIC
        );
    end component;

    component Z_FLAG
        Port (
            CLK     : in  STD_LOGIC;
            RESET   : in  STD_LOGIC;
            ENABLE  : in  STD_LOGIC;
            DATA_IN : in  STD_LOGIC_VECTOR(7 downto 0);
            Z_OUT   : out STD_LOGIC
        );
    end component;

begin

    PC_inst : PC
        port map (
            CLK       => CLK,
            RESET     => RESET,
            JUMP_EN   => jump_en,
            JUMP_ADDR => operand(3 downto 0),
            PC_OUT    => pc_value
        );

    ROM_inst : ROM
        port map (
            ADDRESS     => pc_value,
            INSTRUCTION => instruction
        );

    opcode  <= instruction(11 downto 8);
    operand <= instruction(7 downto 0);

    CU_inst : CONTROL_UNIT
        port map (
            OPCODE  => opcode,
            Z_IN    => z_value,
            ACC_EN  => acc_en,
            ALU_SEL => alu_sel,
            JUMP_EN => jump_en
        );

    ALU_inst : ALU
        port map (
            OPCODE  => alu_sel,
            OPERAND => operand,
            ACC_IN  => acc_value,
            ALU_OUT => alu_result
        );

    ACC_inst : ACC
        port map (
            CLK     => CLK,
            RESET   => RESET,
            ENABLE  => acc_en,
            DATA_IN => alu_result,
            ACC_OUT => acc_value
        );

    Z_inst : Z_FLAG
        port map (
            CLK     => CLK,
            RESET   => RESET,
            ENABLE  => acc_en,
            DATA_IN => alu_result,
            Z_OUT   => z_value
        );

    Q      <= acc_value;
    Z      <= z_value;
    PC_OUT <= pc_value;

end Behavioral;