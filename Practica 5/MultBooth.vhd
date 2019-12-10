LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY MultiplicadorBooth IS
    PORT ( a : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
           b : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
           z : OUT  STD_LOGIC_VECTOR (7 DOWNTO 0));
END MultiplicadorBooth;

ARCHITECTURE Behavioral OF MultiplicadorBooth IS

    COMPONENT HalfAdder IS

        PORT (  A : IN STD_LOGIC;
                B : IN STD_LOGIC;
                S : OUT STD_LOGIC;
                C : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT FullAdder IS
        PORT ( A : IN STD_LOGIC;
            B : IN STD_LOGIC;
            Cin : IN STD_LOGIC;
            S : OUT STD_LOGIC;
            Cout : OUT STD_LOGIC);
    END COMPONENT;

	SIGNAL b0    : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL b1    : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL b2    : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL b3    : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL p1    : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL p2    : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL carry : STD_LOGIC_VECTOR(10 DOWNTO 0);
	SIGNAL carryFp1 : STD_LOGIC;
    SIGNAL carryFp2 : STD_LOGIC;

    BEGIN

        b0(3) <= a(3) NAND b(0);
        b0(2) <= a(2) AND b(0);
        b0(1) <= a(1) AND b(0);
        b0(0) <= a(0) AND b(0);
        
        b1(3) <= a(3) NAND b(1);
        b1(2) <= a(2) AND b(1);
        b1(1) <= a(1) AND b(1);
        b1(0) <= a(0) AND b(1);
        
        b2(3) <= a(3) NAND b(2);
        b2(2) <= a(2) AND b(2);
        b2(1) <= a(1) AND b(2);
        b2(0) <= a(0) AND b(2);
        
        b3(3) <= a(3) AND b(3);
        b3(2) <= a(2) NAND b(3);
        b3(1) <= a(1) NAND b(3);
        b3(0) <= a(0) NAND b(3);
            
        z(0) <= b0(0);
        
        iP1 : HalfAdder PORT MAP(b0(1), b1(0), z(1), carry(0));
        
        p1der : FullAdder PORT MAP(b0(2), b1(1), carry(0), p1(0), carry(1));
        p1med : FullAdder PORT MAP(b0(3), b1(2), carry(1), p1(1), carry(2));
        p1izq : FUllAdder PORT MAP('1'  , b1(3), carry(2), p1(2), carryFp1);
        
        iP2 : HalfAdder PORT MAP(p1(0), b2(0), z(2), carry(3));
        
        p2der : FullAdder PORT MAP(p1(1), b2(1), carry(3), p2(0), carry(4));
        p2med : FullAdder PORT MAP(p1(2), b2(2), carry(4), p2(1), carry(5));
        p2izq : FullAdder PORT MAP(carryFp1, b2(3), carry(5), p2(2), carryFp2);
        
        z3 : HalfAdder PORT MAP(p2(0), b3(0), z(3), carry(6));
        z4 : FullAdder PORT MAP(p2(1), b3(1), carry(6), z(4), carry(7));
        z5 : FullAdder PORT MAP(p2(2), b3(2), carry(7), z(5), carry(8));
        z6 : FullAdder PORT MAP(carryFp2, b3(3), carry(8), z(6), carry(9));
        z7 : HalfAdder PORT MAP('1', carry(9), z(7), carry(10));

END Behavioral;
