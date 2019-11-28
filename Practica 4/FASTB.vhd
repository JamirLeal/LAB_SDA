--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:00:58 11/27/2019
-- Design Name:   
-- Module Name:   /home/ricardochapa/Desktop/XILINX projects/FullAdder/FASTB.vhd
-- Project Name:  FullAdder
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: FASCompletos
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types bit and
-- bit_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY FASTB IS
END FASTB;
 
ARCHITECTURE behavior OF FASTB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT FASCompletos
    PORT(
         A : IN bit_vector(7 downto 0);
         B : IN bit_vector(7 downto 0);
         S : IN bit;
         E : OUT bit_vector(7 downto 0);
         Cout : OUT bit;
         Overflow : OUT  bit
        );
    END COMPONENT;
    

   --Inputs
   signal A : bit_vector(7 downto 0) := (others => '0');
   signal B : bit_vector(7 downto 0) := (others => '0');
   signal S : bit := '0';

 	--Outputs
   signal E : bit_vector(7 downto 0);
   signal Cout : bit;
   signal Overflow : bit;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: FASCompletos PORT MAP (
          A => A,
          B => B,
          S => S,
          E => E,
          Cout => Cout,
          Overflow => Overflow
        );

   -- Clock process definition

   -- Stimulus process
   stim_proc: process
   begin		
      A <= "00000000";
		B <= "00000000";
		S <= '1';
      wait for 100 ns;	
      -- insert stimulus here 

      wait;
   end process;

END;
