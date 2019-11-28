library IEEE;
use ieee.std_logic_1164.all;


entity FullAS is
	port(Cin:in bit;
		  A,B: in bit;
		  E: out bit;
		  Cout: out bit);
end FullAS;

architecture Behavioral of FullAS is

begin
	E <= A xor B xor Cin;
	Cout <= (A and B) or (Cin and A) or (Cin and B);
	
end Behavioral;