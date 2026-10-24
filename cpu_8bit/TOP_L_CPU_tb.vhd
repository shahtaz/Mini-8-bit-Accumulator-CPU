----------------------------------------------------------------------------------
-- Testbench for TOP_L_CPU
-- Set 9: LDI, ADD, NOT, SHL, JZ
-- Clock period: 100 ns
-- Program (ROM):
--   0: LDI 0xFF   1: NOT       2: JZ 0x05   3: ADD 0x77 (skipped)
--   4: ADD 0x77 (skipped)      5: ADD 0x11  6: SHL
--   7: JZ 0x00    8: SHL
----------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY TOP_L_CPU_tb IS
END TOP_L_CPU_tb;

ARCHITECTURE behavior OF TOP_L_CPU_tb IS

    -- Component declaration
    COMPONENT TOP_L_CPU
        PORT (
            CLK    : IN  STD_LOGIC;
            RESET  : IN  STD_LOGIC;
            Q      : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            Z      : OUT STD_LOGIC;
            PC_OUT : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;

    CONSTANT CLK_PERIOD : TIME := 100 ns;

    -- Testbench signals
    SIGNAL CLK    : STD_LOGIC := '0';
    SIGNAL RESET  : STD_LOGIC := '1';
    SIGNAL Q      : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL Z      : STD_LOGIC;
    SIGNAL PC_OUT : STD_LOGIC_VECTOR(3 DOWNTO 0);

    SIGNAL done   : BOOLEAN := FALSE;

    -- Hex string helper (VHDL-93 compatible)
    FUNCTION to_hex(v : STD_LOGIC_VECTOR) RETURN STRING IS
        CONSTANT digits : STRING(1 TO 16) := "0123456789ABCDEF";
    BEGIN
        IF v'LENGTH = 8 THEN
            RETURN "0x" &
                   digits(to_integer(unsigned(v(7 DOWNTO 4))) + 1) &
                   digits(to_integer(unsigned(v(3 DOWNTO 0))) + 1);
        ELSE
            RETURN "0x" & digits(to_integer(unsigned(v)) + 1);
        END IF;
    END FUNCTION;

BEGIN

    -- Instantiate the top-level CPU
    uut : TOP_L_CPU
        PORT MAP (
            CLK    => CLK,
            RESET  => RESET,
            Q      => Q,
            Z      => Z,
            PC_OUT => PC_OUT
        );

    -- 100 ns clock, stops when the test is finished
    clk_proc : PROCESS
    BEGIN
        WHILE NOT done LOOP
            CLK <= '0';
            WAIT FOR CLK_PERIOD / 2;
            CLK <= '1';
            WAIT FOR CLK_PERIOD / 2;
        END LOOP;
        WAIT;
    END PROCESS;

    -- Reset, run the Set 9 program and verify every cycle
    stim_proc : PROCESS
        VARIABLE errors : INTEGER := 0;

        PROCEDURE check(
            name  : IN STRING;
            exp_q : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            exp_z : IN STD_LOGIC;
            exp_pc: IN STD_LOGIC_VECTOR(3 DOWNTO 0)
        ) IS
        BEGIN
            IF Q = exp_q AND Z = exp_z AND PC_OUT = exp_pc THEN
                REPORT "PASS: " & name &
                       "  ACC=" & to_hex(Q) &
                       " Z=" & STD_LOGIC'IMAGE(Z) &
                       " NextPC=" & to_hex(PC_OUT)
                    SEVERITY NOTE;
            ELSE
                errors := errors + 1;
                REPORT "FAIL: " & name &
                       "  got ACC=" & to_hex(Q) &
                       " Z=" & STD_LOGIC'IMAGE(Z) &
                       " NextPC=" & to_hex(PC_OUT) &
                       " | expected ACC=" & to_hex(exp_q) &
                       " Z=" & STD_LOGIC'IMAGE(exp_z) &
                       " NextPC=" & to_hex(exp_pc)
                    SEVERITY ERROR;
            END IF;
        END PROCEDURE;

    BEGIN

        ------------------------------------------------------------------
        -- Cycle 0: RESET = 1 for exactly one rising edge
        -- Expected: ACC=00, Z=1, PC=0
        ------------------------------------------------------------------
        RESET <= '1';
        WAIT UNTIL rising_edge(CLK);
        WAIT FOR 1 ns;
        check("Cycle 0: RESET", x"00", '1', x"0");
        RESET <= '0';

        ------------------------------------------------------------------
        -- Cycle 1: PC=0  LDI 0xFF
        ------------------------------------------------------------------
        WAIT UNTIL rising_edge(CLK);
        WAIT FOR 1 ns;
        check("Cycle 1: LDI 0xFF", x"FF", '0', x"1");

        ------------------------------------------------------------------
        -- Cycle 2: PC=1  NOT
        ------------------------------------------------------------------
        WAIT UNTIL rising_edge(CLK);
        WAIT FOR 1 ns;
        check("Cycle 2: NOT", x"00", '1', x"2");

        ------------------------------------------------------------------
        -- Cycle 3: PC=2  JZ 0x05 (taken, Z=1)
        ------------------------------------------------------------------
        WAIT UNTIL rising_edge(CLK);
        WAIT FOR 1 ns;
        check("Cycle 3: JZ 0x05 (taken)", x"00", '1', x"5");

        ------------------------------------------------------------------
        -- Cycle 4: PC=5  ADD 0x11
        ------------------------------------------------------------------
        WAIT UNTIL rising_edge(CLK);
        WAIT FOR 1 ns;
        check("Cycle 4: ADD 0x11", x"11", '0', x"6");

        ------------------------------------------------------------------
        -- Cycle 5: PC=6  SHL
        ------------------------------------------------------------------
        WAIT UNTIL rising_edge(CLK);
        WAIT FOR 1 ns;
        check("Cycle 5: SHL", x"22", '0', x"7");

        ------------------------------------------------------------------
        -- Cycle 6: PC=7  JZ 0x00 (not taken, Z=0)
        ------------------------------------------------------------------
        WAIT UNTIL rising_edge(CLK);
        WAIT FOR 1 ns;
        check("Cycle 6: JZ 0x00 (not taken)", x"22", '0', x"8");

        ------------------------------------------------------------------
        -- Cycle 7: PC=8  SHL
        ------------------------------------------------------------------
        WAIT UNTIL rising_edge(CLK);
        WAIT FOR 1 ns;
        check("Cycle 7: SHL", x"44", '0', x"9");

        ------------------------------------------------------------------
        -- Extra cycle: PC=9 is unused (0x000 = NOP)
        -- ACC and Z must stay unchanged, PC <- PC + 1
        ------------------------------------------------------------------
        WAIT UNTIL rising_edge(CLK);
        WAIT FOR 1 ns;
        check("Cycle 8: NOP (unused address 9)", x"44", '0', x"A");

        ------------------------------------------------------------------
        -- Summary
        ------------------------------------------------------------------
        IF errors = 0 THEN
            REPORT "ALL TESTS PASSED: TOP_L_CPU Set 9 program verified."
                SEVERITY NOTE;
        ELSE
            REPORT "TEST FAILED with " & INTEGER'IMAGE(errors) & " error(s)."
                SEVERITY ERROR;
        END IF;

        done <= TRUE;
        WAIT;
    END PROCESS;

END behavior;