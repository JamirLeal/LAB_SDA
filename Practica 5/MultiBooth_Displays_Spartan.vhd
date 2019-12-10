LIBRARY ieee;
USE ieee.std_logic_1164.ALL; 
USE ieee.std_logic_arith.ALL;	  
USE ieee.std_logic_unsigned.ALL; 

ENTITY seven_segment_spartan  IS 
	PORT(clk        : IN  std_logic;     
		  myInput   : IN std_logic_vector(7 DOWNTO 0);
		  myOutput  : OUT std_logic_vector(6 DOWNTO 0);
		  sal       : OUT std_logic_vector(7 DOWNTO 0);
		  enable    : OUT std_logic_vector(3 DOWNTO 0)); 
END seven_segment_spartan;

ARCHITECTURE bhv OF seven_segment_spartan  IS
    COMPONENT MultiplicadorBooth IS
        PORT ( a    : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
                b   : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
                z   : OUT  STD_LOGIC_VECTOR (7 DOWNTO 0));
    END COMPONENT;

    COMPONENT bToBCD is
        PORT ( bin   : in  STD_LOGIC_VECTOR (7 downto 0);
            decade   : out  STD_LOGIC_VECTOR (3 downto 0);
                unit : out  STD_LOGIC_VECTOR (3 downto 0)); 
    END COMPONENT;

    COMPONENT bcdToSeg IS
        PORT(bcd    : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            sevSeg  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
    END COMPONENT;

    TYPE state IS (state0,state1,state2);
    SIGNAL next_state, ps: state := state0;
    SIGNAL salMulti : std_logic_vector(7 DOWNTO 0);
    SIGNAL num : std_logic_vector(7 DOWNTO 0);
    SIGNAL bcds : std_logic_vector(7 DOWNTO 0);
    SIGNAL sevs : std_logic_vector(13 DOWNTO 0);

    BEGIN	
        Multi       : MultiplicadorBooth PORT MAP (myInput(7 DOWNTO 4), myInput(3 DOWNTO 0), salMulti);
        num <= "11111111" - salMulti + 1 WHEN salMulti(7) = '1' ELSE salMulti;
        BinBCD      : bToBCD PORT MAP (num, bcds(7 downto 4), bcds(3 downto 0));
        BCDtoSevD   : bcdToSeg PORT MAP (bcds(7 DOWNTO 4), sevs(13 DOWNTO 7));
        BCDtoSevU   : bcdToSeg PORT MAP (bcds(3 DOWNTO 0), sevs(6 DOWNTO 0));
        sal <= salMulti;

        myOutput <= "1111110" WHEN next_state = state0 ELSE
        sevs(13 DOWNTO 7) WHEN next_state = state1 ELSE
        sevs(6 DOWNTO 0) WHEN next_state = state2;

        PROCESS(clk,next_state)
            VARIABLE i : INTEGER := 0 ;
                BEGIN
                    IF clk'event AND clk = '1' THEN
                        IF i <= 500000 THEN
                            i := i + 1;
                        ELSIF i > 500000 THEN
                            i := 0 ;
                            next_state <= ps;
                        END IF;

                        CASE next_state IS
                            WHEN state0 =>
                                IF salMulti(7) = '1' THEN 
                                    enable <= "1011";
                                ELSE
                                    enable <= "1111";
                                END IF;
                                ps <= state1;
                            WHEN state1 =>
                                enable <= "1101";
                                ps <= state2;
                            WHEN state2 =>
                                enable <= "1110";
                                ps <= state0;
                        END CASE;
                    END IF;
        END PROCESS;
END bhv;