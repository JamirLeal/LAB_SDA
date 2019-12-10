library IEEE;
use IEEE.std_logic_1164.ALL;
use ieee.numeric_std.all;
use ieee.numeric_bit.all;
use ieee.std_logic_unsigned.all;

entity PStoBLCD is
	port( new_data, clk, ps2_clk, ps2_data, lcd_reset: inout std_logic;
			lcd_bus: inout std_logic_vector(9 downto 0);
			bcd_DU: inout std_logic_vector(7 downto 0);
			seg7_control: out std_logic_vector(3 downto 0);
			seg7_outputs: out std_logic_vector(6 downto 0);
			LCD_output: out std_logic_vector(7 downto 0);
			RW, RS, E, Busy: out std_logic);
end PStoBLCD;

architecture Behavioral of PStoBLCD is
	type state is(state0, state1);
	signal next_state, actual_state : state := state0;
	signal seg7_output : std_logic_vector(13 downto 0);
	signal lcd_busy, lcd_E, lcd_RW, lcd_Rs: std_logic;
	signal enter: std_logic := '0';
	signal dumb: std_logic_vector(7 downto 0);

	component ps2_keyboard
	port(
	 clk          : in  std_logic;                    
    ps2_clk      : in  std_logic;                  
    ps2_data     : in  std_logic;                     
    newps : inout std_logic;                     
    bcds     : inout std_logic_vector(7 DOWNTO 0));
	end component;
	
	component bcdToSeg 
	port(bcd : in std_logic_vector(3 DOWNTO 0);
	sevSeg : out std_logic_vector(6 DOWNTO 0));
	end component;
	
	component lcd_controller
		  port( clk: in std_logic;
		reset_n    : in    std_logic;  
    lcd_enable : in    std_logic;  
    lcd_bus    : in    std_logic_vector(9 DOWNTO 0); 
    busy       : out   std_logic := '1'; 
    rw, rs, e  : out   std_logic;  
    lcd_data   : out   std_logic_vector(7 DOWNTO 0));
	end component;
begin
keyboard: ps2_keyboard port map(clk, ps2_clk, ps2_data, new_data, bcd_DU);
seg7D: bcdToSeg port map(bcd_DU(7 downto 4), seg7_output(13 downto 7));
seg7C: bcdToSeg port map(bcd_DU(3 downto 0), seg7_output(6 downto 0));
--lcdcont2: lcd_controller port map(clk, lcd_reset, '1', "0000000010", lcd_busy, lcd_RW, lcd_RS, lcd_E, dumb);
lcdcont: lcd_controller port map(clk,lcd_reset, new_data, lcd_bus, Busy, RW, RS, E, LCD_output);

seg7_outputs <= seg7_output(13 downto 7) when actual_state = state0 else
					 seg7_output(6 downto 0) when actual_state = state1;
process(clk, next_state)
variable i: integer := 0;
begin
if clk'event and clk = '1' then
	if i <= 500000 then 
		i:= i+1;
	elsif i > 500000 then
		i:= 0;
		actual_state <= next_state;
	end if;
	
	case actual_state is
		when state0 =>
			seg7_control <= "0111";
			next_state <= state1;
		when state1 => 
			seg7_control <= "1011";
			next_state <= state0;
	end case;
end if;
end process;

	lcd_bus <= "1001010001" when bcd_DU = "00010101" else --Q
			 "1001010111" when bcd_DU = "00011101"	else --W
			 "1001000101" when bcd_DU = "00100100" else --E
			 "1001010010" when bcd_DU = "00101101" else --R --
			 "1001010100" when bcd_DU = "00101100"	else --T --
			 "1001011001" when bcd_DU = "00110101" else --Y--
			 "1001010101" when bcd_DU = "00111100" else --U--
			 "1001001001" when bcd_DU = "01000011"	else --I--
			 "1001001111" when bcd_DU = "01000100" else --O--
			 "1001010000" when bcd_DU = "01001101" else --P --
			 "1001000001" when bcd_DU = "00011100"	else --A--
			 "1001010011" when bcd_DU = "00011011" else --S--
			 "1001000100" when bcd_DU = "00100011" else --D--
			 "1001000110" when bcd_DU = "00101011"	else --F--
			 "1001000111" when bcd_DU = "00110100" else --G--
			 "1001001000" when bcd_DU = "00110011" else --H --
			 "1001001010" when bcd_DU = "00111011"	else --J--
			 "1001001011" when bcd_DU = "01000010" else --K--
			 "1001001100" when bcd_DU = "01001011" else --L--
			 "1001011000" when bcd_DU = "00100010"	else --X--
			 "1001000011" when bcd_DU = "00100001" else --C--
			 "1001010110" when bcd_DU = "00101010" else --V --
			 "1001000010" when bcd_DU = "00110010"	else --B--
			 "1001001110" when bcd_DU = "00110001" else --N--
			 "1001001101" when bcd_DU = "00111010"	else --M--
			 "1000111001" when bcd_DU = "01000110" else --0-- 
			 "1000111000" when bcd_DU = "00111110" else --1 --
			 "1000110111" when bcd_DU = "00111101"	else --2-- 
			 "1000110110" when bcd_DU = "00110110" else --3-- 
			 "1000110101" when bcd_DU = "00101110" else --4-- 
			 "1000110100" when bcd_DU = "00100101"	else --5--
			 "1000110011" when bcd_DU = "00100110" else --6-
			 "1000110010" when bcd_DU = "00011110" else --7 --
			 "1000110001" when bcd_DU = "00010110"	else --8-- 
			 "1000110000" when bcd_DU = "01000101" else --9 -- 
			 "1000100000" when bcd_DU = "00101001" else --space
			 "1011111111" when bcd_DU = "01011010" else --enter
			 "1001011010";
end Behavioral;