LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY ff IS
END ff;

ARCHITECTURE behavior OF ff IS 
    COMPONENT seven_segment_spartan
    PORT(
         clk : IN  std_logic;
         myInput : IN  std_logic_vector(7 downto 0);
         myOutput : OUT  std_logic_vector(6 downto 0);
         enable : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
   signal clk : std_logic := '0';
   signal myInput : std_logic_vector(7 downto 0) := (others => '0');
   signal myOutput : std_logic_vector(6 downto 0);
   signal enable : std_logic_vector(3 downto 0);
   constant clk_period : time := 10 ns;
    BEGIN 
        uut: seven_segment_spartan PORT MAP (
                clk => clk,
                myInput => myInput,
                myOutput => myOutput,
                enable => enable
                );
        -- Clock process definitions
        clk_process :process
            begin
                    clk <= '0';
                    wait for clk_period/2;
                    clk <= '1';
                    wait for clk_period/2;
        end process;
        -- Stimulus process
        stim_proc: process
            begin		
                -- hold reset state for 100 ns.
                wait for 100 ns;	
                wait for clk_period*10;
                -- insert stimulus here 
                    myInput <= "00000000";
                    wait for 30 ms;
                    myInput <= "00010001";
                    wait for 30 ms;
                    myInput <= "10011001";
                    wait for 30 ms;
                    myInput <= "01010011";
                    wait for 30 ms;
        end process;
END;