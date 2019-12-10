library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY FullAdder IS
    PORT ( A : IN  STD_LOGIC;
           B : IN  STD_LOGIC;
           Cin : IN  STD_LOGIC;
           S : OUT  STD_LOGIC;
           Cout : OUT  STD_LOGIC);
END FullAdder;

ARCHITECTURE Behavioral OF FullAdder IS
    BEGIN
        S <= (A XOR B) XOR Cin;
        Cout <= (A AND B) OR ((A XOR B) AND Cin);
END Behavioral;