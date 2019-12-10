library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
 
ENTITY btbcd_tb IS
END btbcd_tb;
 
ARCHITECTURE behavior OF btbcd_tb IS 
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT bToBCD
        PORT(
            bin : IN  std_logic_vector(7 downto 0);
            decade : OUT  std_logic_vector(3 downto 0);
            unit : OUT  std_logic_vector(3 downto 0)
            );
    END COMPONENT;
   --Inputs
   signal bin : std_logic_vector(7 downto 0) := (others => '0');
   --Outputs
   signal decade : std_logic_vector(3 downto 0);
   signal unit : std_logic_vector(3 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
    BEGIN
            -- Instantiate the Unit Under Test (UUT)
        uut: bToBCD PORT MAP (
                bin => bin,
                decade => decade,
                unit => unit
                );
        -- Stimulus process
        stim_proc: process
            begin		
                wait for 100 ns;	

                for i in 0 to 99 loop
                        bin <= bin + 1;
                        wait for 100 ns;   
                    end loop;
                -- insert stimulus here 
                wait;
        end process;
END;