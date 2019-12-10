LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
 
ENTITY bcdToSeg IS
    PORT(bcd    : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        sevSeg  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END bcdToSeg;
 
ARCHITECTURE Behavioral OF bcdToSeg IS
    BEGIN
        sevSeg <= "0000001" WHEN bcd = "0000" ELSE
            "1001111"       WHEN bcd = "0001" ELSE
            "0010010"       WHEN bcd = "0010" ELSE
            "0000110"       WHEN bcd = "0011" ELSE
            "1001100"       WHEN bcd = "0100" ELSE
            "0100100"       WHEN bcd = "0101" ELSE
            "0100000"       WHEN bcd = "0110" ELSE
            "0001111"       WHEN bcd = "0111" ELSE
            "0000000"       WHEN bcd = "1000" ELSE
            "0000100"       WHEN bcd = "1001" ELSE
            "1111111";
END Behavioral;

