
library IEEE;
use ieee.std_logic_1164.all;


entity FASCompletos is
	port(A,B: in bit_vector(7 downto 0);
		  S: in bit;
		  E: out bit_vector(7 downto 0);
		  Cout, Overflow: out bit);
end FASCompletos;

architecture Behavioral of FASCompletos is

component FullAS is
	port(Cin:in bit;
		  A,B: in bit;
		  E: out bit;
		  Cout: out bit);
end component;

signal Cout_s: bit_vector(6 downto 0);
signal B_s: bit_vector(7 downto 0);
signal Cout_ss: bit;

begin
B_s(0) <= B(0) xor S;
B_s(1) <= B(1) xor S;
B_s(2) <= B(2) xor S;
B_s(3) <= B(3) xor S;
B_s(4) <= B(4) xor S;
B_s(5) <= B(5) xor S;
B_s(6) <= B(6) xor S;
B_s(7) <= B(7) xor S;

FA1: FullAS port map(S, A(0), B_s(0), E(0), Cout_s(0));
FA2: FullAS port map(Cout_s(0), A(1), B_s(1), E(1), Cout_s(1));
FA3: FullAS port map(Cout_s(1), A(2), B_s(2), E(2), Cout_s(2));
FA4: FullAS port map(Cout_s(2), A(3), B_s(3), E(3), Cout_s(3));
FA5: FullAS port map(Cout_s(3), A(4), B_s(4), E(4), Cout_s(4));
FA6: FullAS port map(Cout_s(4), A(5), B_s(5), E(5), Cout_s(5));
FA7: FullAS port map(Cout_s(5), A(6), B_s(6), E(6), Cout_s(6));
FA8: FullAS port map(Cout_s(6), A(7), B_s(7), E(7), Cout_ss);

Cout <= Cout_ss;
Overflow <= Cout_ss xor Cout_s(6);
end Behavioral;

