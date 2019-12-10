LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;


ENTITY bToBCD IS
    PORT (bin       : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
          decade    : OUT  STD_LOGIC_VECTOR (3 DOWNTO 0);
          unit      : OUT  STD_LOGIC_VECTOR (3 DOWNTO 0));
END bToBCD;

ARCHITECTURE Behavioral OF bToBCD IS
    BEGIN
        PROCESS(bin)
            VARIABLE temp : STD_LOGIC_VECTOR (7 DOWNTO 0);
            VARIABLE bcd : UNSIGNED (7 DOWNTO 0) := (OTHERS => '0');
        
            BEGIN
                bcd := (OTHERS => '0');
                temp(7 DOWNTO 0) := bin;
                
                FOR i IN 0 TO 7 LOOP
                    IF bcd(3 DOWNTO 0) > 4 THEN 
                        bcd(3 DOWNTO 0) := bcd(3 DOWNTO 0) + 3;
                    end if;
                    
                    IF bcd(7 DOWNTO 4) > 4 THEN 
                        bcd(7 DOWNTO 4) := bcd(7 DOWNTO 4) + 3;
                    END IF;
            
                    bcd := bcd(6 DOWNTO 0) & temp(7);
                    temp := temp(6 DOWNTO 0) & '0';
                end loop;
                
                unit <= STD_LOGIC_VECTOR(bcd(3 DOWNTO 0));
                decade <= STD_LOGIC_VECTOR(bcd(7 DOWNTO 4));
        END PROCESS;            
END Behavioral;