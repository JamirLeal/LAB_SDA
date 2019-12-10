LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY bToSev IS
END bToSev;
 
ARCHITECTURE behavior OF bToSev IS 
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT bcdToSeg
    PORT(
         bcd : IN  std_logic_vector(3 downto 0);
         sevSeg : OUT  std_logic_vector(6 downto 0)
        );
    END COMPONENT;
	signal clock : std_logic := '0';
   --Inputs
   signal bcd : std_logic_vector(3 downto 0) := (others => '0');
 	--Outputs
   signal sevSeg : std_logic_vector(6 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
   constant clock_period : time := 10 ns;
 
    BEGIN
        
            -- Instantiate the Unit Under Test (UUT)
        uut: bcdToSeg PORT MAP (
                bcd => bcd,
                sevSeg => sevSeg
                );

        -- Clock process definitions
        clock_process :process
        begin
                clock <= '0';
                wait for clock_period/2;
                clock <= '1';
                wait for clock_period/2;
        end process;
        -- Stimulus process
        stim_proc: process
        begin		
            -- hold reset state for 100 ns.
            wait for 100 ns;
            -- insert stimulus here  
                bcd <= "0000";
                wait for 100 ns;
                
                bcd <= "0001";
                wait for 100 ns;
                
                bcd <= "0010";
                wait for 100 ns;
                
                bcd <= "0011";
                wait for 100 ns;
                
                bcd <= "0100";
                wait for 100 ns;
                
                bcd <= "0101";
                wait for 100 ns;
                
                bcd <= "0110";
                wait for 100 ns;
                
                bcd <= "0111";
                wait for 100 ns;
                
                bcd <= "1000";
                wait for 100 ns;
                
            bcd <= "1001";
                wait for 100 ns;
            wait;
        end process;
END;