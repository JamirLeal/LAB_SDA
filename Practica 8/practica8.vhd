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

signal hs : integer;
signal vs : integer;
signal clk25_mhz : std_logic;
signal rojo_s : std_logic;

begin
	process (clk50_in) -- Generacion de el reloj de 25_Mhz
		begin
			if rising_edge(clk50_in) then
				if (clk25_mhz = '0') then              
					clk25_mhz <= '1';
				else
					clk25_mhz <= '0';
				end if;
			end if;
	end process;

	process (clk25_mhz)
		begin
			if rising_edge(clk25_mhz) then
				if ((hs >= 147 and hs <= 152) or (hs >= 774 and hs <= 779)) and vs >= 4 and vs <= 483 then
					rojo 	<= 	'1';
					azul 	<= 	'0';
					verde 	<= 	'0';
					rojo_s 	<= 	'1';
				elsif hs >= 147 and hs <= 779 and ((vs >= 4 and vs <= 9) or(vs >= 478 and vs <= 483)) then
					rojo 	<= '1';
					azul 	<= '0';
					verde 	<= '0';
					rojo 	<= '1';
				elsif (hs >= 461 and hs <= 466) and vs >= 4 and vs <= 483 then
					rojo 	<= '1';
					azul 	<= '0';
					verde 	<= '0';
					rojo_s 	<= '1';
				elsif hs >= 147 and hs <= 779 and (vs >= 241 and vs <= 246) then
					rojo 	<= '1';
					azul 	<= '0';
					verde 	<= '0';
					rojo_s 	<= '1'; 
				elsif hs >= 147 and hs <= 779 and vs >= 4 and vs <= 483 and rojo_s = '0' then             
					rojo 	<= '0';
					azul 	<= '1';
					verde 	<= '0';
					rojo_s 	<= '0';
				else
					rojo 	<= '0';
					azul 	<= '0';
					verde 	<= '0';
					rojo_s 	<= '0';
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