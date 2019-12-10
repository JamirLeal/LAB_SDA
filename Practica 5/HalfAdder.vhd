LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY HalfAdder IS
    PORT ( A : IN  STD_LOGIC;
           B : IN  STD_LOGIC;
           S : OUT STD_LOGIC;
			  C : OUT STD_LOGIC);
END HalfAdder;

ARCHITECTURE Behavioral OF HalfAdder IS
    BEGIN
        S <= A XOR B;
        c <= A AND B;
END Behavioral;