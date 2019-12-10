LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY MB_tb IS
END MB_tb;
 
ARCHITECTURE behavior OF MB_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MultiplicadorBooth
        PORT(
            a : IN  std_logic_vector(3 downto 0);
            b : IN  std_logic_vector(3 downto 0);
            z : OUT  std_logic_vector(7 downto 0)
            );
    END COMPONENT;
	 
   signal clk : std_logic := '0';
   --Inputs
   signal a : std_logic_vector(3 downto 0) := (others => '0');
   signal b : std_logic_vector(3 downto 0) := (others => '0');  
 	--Outputs
   signal z : std_logic_vector(7 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
    constant clk_period : time := 10 ns;
 
    BEGIN
        -- Instantiate the Unit Under Test (UUT)
    uut: MultiplicadorBooth PORT MAP (
            a => a,
            b => b,
            z => z
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
            -- insert stimulus here 
                a <= "0000";
                b <= "0000";
                wait for 10 ns;
                
                a <= "0001";
                wait for 10 ns;
                
                b <= "0001";
                wait for 10 ns;
                
                b <= "0101";
                wait for 10 ns;
                
                a <= "0110";
                wait for 10 ns;
                
                a <= "1001";
                wait for 10 ns;
                
                b <= "1001";
                wait for 10 ns;
            wait;
    end process;
END;
