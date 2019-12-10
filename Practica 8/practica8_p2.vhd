library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity VGA is
	port(clk50_in : in std_logic;
			 rojo       : out std_logic;
			 verde     : out std_logic;
			 azul     : out std_logic;
			 hs_sal   : out std_logic;
			 vs_sal   : out std_logic);       
	end VGA;
architecture Behavioral of VGA is

signal hs 		: integer;
signal vs 		: integer;
signal clk25 	: std_logic;

begin
	process (clk50_in)
		begin
			if rising_edge(clk50_in) then

				if (clk25 = '0') then              
					clk25 <= '1';
				else
					clk25 <= '0';
				end if;
			end if;
	end process;

	process (clk25)
		begin
			if rising_edge(clk25) then
				if hs >= 147 and hs <= 223 and vs >= 4 and vs <= 483 then
					rojo 	<= '1';
					azul 	<= '1';
					verde 	<= '1';
				elsif hs >= 224 and hs <= 303 and vs >= 4 and vs <= 483 then
					rojo 	<= '1';
					azul 	<= '0';
					verde 	<= '1';
				elsif hs >= 304 and hs <= 383 and vs >= 4 and vs <= 483 then
					rojo 	<= '0';
					azul 	<= '0';
					verde 	<= '1';
				elsif hs >= 384 and hs <= 463 and vs >= 4 and vs <= 483 then
					rojo 	<= '0';
					azul 	<= '1';
					verde 	<= '1';
				elsif hs >= 464 and hs <= 543 and vs >= 4 and vs <= 483 then
					rojo 	<= '1';
					azul 	<= '1';
					verde 	<= '0';
				elsif hs >= 544 and hs <= 623 and vs >= 4 and vs <= 483 then
					rojo 	<= '1';
					azul 	<= '0';
					verde 	<= '0';
				elsif hs >= 624 and hs <= 703 and vs >= 4 and vs <= 483 then
					rojo 	<= '0';
					azul 	<= '1';
					verde 	<= '0';
				else
					rojo 	<= '0';
					azul 	<= '0';
					verde 	<= '0';
				end if;

				if (hs > 0 ) and (hs < 97 ) then
					hs_sal <= '0';
				else
					hs_sal <= '1';
				end if;

				if (vs > 0 ) and (vs < 3 ) then
					vs_sal <= '0';
				else
					vs_sal <= '1';
				end if;

				hs <= hs + 1 ;

				if (hs = 800) then  
					vs <= vs + 1;   
					hs <= 0;
				end if;

				if (vs = 521) then                 
					vs <= 0;
				end if;

			end if;
	end process;
end Behavioral;