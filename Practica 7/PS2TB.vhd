
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
  
ENTITY PS2TB IS
END PS2TB;
 
ARCHITECTURE behavior OF PS2TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ps2_keyboard
    PORT(
         clk : IN  std_logic;
         ps2_clk : IN  std_logic;
         ps2_data : IN  std_logic;
         ps2_code_new : INOUT  std_logic;
         ps2_code : INOUT  std_logic_vector(7 downto 0);
         segm7_control : OUT  std_logic_vector(3 downto 0);
         seg7_output : OUT  std_logic_vector(6 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal ps2_clk : std_logic := '0';
   signal ps2_data : std_logic := '0';

	--BiDirs
   signal ps2_code_new : std_logic;
   signal ps2_code : std_logic_vector(7 downto 0);

 	--Outputs
   signal segm7_control : std_logic_vector(3 downto 0);
   signal seg7_output : std_logic_vector(6 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
   constant ps2_clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ps2_keyboard PORT MAP (
          clk => clk,
          ps2_clk => ps2_clk,
          ps2_data => ps2_data,
          ps2_code_new => ps2_code_new,
          ps2_code => ps2_code,
          segm7_control => segm7_control,
          seg7_output => seg7_output
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
   ps2_clk_process :process
   begin
		ps2_clk <= '0';
		wait for ps2_clk_period/2;
		ps2_clk <= '1';
		wait for ps2_clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
