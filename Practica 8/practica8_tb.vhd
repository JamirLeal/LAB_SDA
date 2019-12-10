LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY vga_tb IS
END vga_tb;
 
ARCHITECTURE behavior OF vga_tb IS 
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT VGA
        PORT(clk50_in : IN  std_logic;
            red : OUT  std_logic;
            green : OUT  std_logic;
            blue : OUT  std_logic;
            hs_out : OUT  std_logic;
            vs_out : OUT  std_logic);
    END COMPONENT;
   --Inputs
   signal clk50_in : std_logic := '0';
 	--Outputs
   signal red : std_logic;
   signal green : std_logic;
   signal blue : std_logic;
   signal hs_out : std_logic;
   signal vs_out : std_logic;
   -- Clock period definitions
   constant clk50_in_period : time := 40 ns;

BEGIN
	-- Instantiate the Unit Under Test (UUT)
   uut: VGA PORT MAP (
          clk50_in => clk50_in,
          red => red,
          green => green,
          blue => blue,
          hs_out => hs_out,
          vs_out => vs_out
        );
   -- Clock process definitions
   clk50_in_process :process
   begin
		clk50_in <= '0';
		wait for clk50_in_period/2;
		clk50_in <= '1';
		wait for clk50_in_period/2;
   end process;
   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ms;	
      -- insert stimulus here 
      wait;
   end process;
END;