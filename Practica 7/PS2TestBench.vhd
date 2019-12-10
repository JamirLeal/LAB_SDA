
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY PS2TestBench IS
END PS2TestBench;
 
ARCHITECTURE behavior OF PS2TestBench IS 
  
    COMPONENT PStoBLCD
    PORT(
         new_data : INOUT  std_logic;
         clk : INOUT  std_logic;
         ps2_clk : INOUT  std_logic;
         ps2_data : INOUT  std_logic;
         lcd_reset : INOUT  std_logic;
         lcd_bus : INOUT  std_logic_vector(9 downto 0);
         bcd_DU : INOUT  std_logic_vector(7 downto 0);
         seg7_control : OUT  std_logic_vector(3 downto 0);
         seg7_outputs : OUT  std_logic_vector(6 downto 0);
         LCD_output : OUT  std_logic_vector(7 downto 0);
         RW : OUT  std_logic;
         RS : OUT  std_logic;
         E : OUT  std_logic;
         Busy : OUT  std_logic
        );
    END COMPONENT;
    

	--BiDirs
   signal new_data : std_logic;
   signal clk : std_logic;
   signal ps2_clk : std_logic;
   signal ps2_data : std_logic;
   signal lcd_reset : std_logic;
   signal lcd_bus : std_logic_vector(9 downto 0);
   signal bcd_DU : std_logic_vector(7 downto 0);

 	--Outputs
   signal seg7_control : std_logic_vector(3 downto 0);
   signal seg7_outputs : std_logic_vector(6 downto 0);
   signal LCD_output : std_logic_vector(7 downto 0);
   signal RW : std_logic;
   signal RS : std_logic;
   signal E : std_logic;
   signal Busy : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
   constant ps2_clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PStoBLCD PORT MAP (
          new_data => new_data,
          clk => clk,
          ps2_clk => ps2_clk,
          ps2_data => ps2_data,
          lcd_reset => lcd_reset,
          lcd_bus => lcd_bus,
          bcd_DU => bcd_DU,
          seg7_control => seg7_control,
          seg7_outputs => seg7_outputs,
          LCD_output => LCD_output,
          RW => RW,
          RS => RS,
          E => E,
          Busy => Busy
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
      wait for 100 ns;	
		bcd_DU <= "00010101";
		lcd_bus <= "1000110001";
		wait for 100 ns;
		wait for 100 ns;	
		bcd_DU <= "00101010";
		lcd_bus <= "1000110001";
		wait for 100 ns;
		

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
