LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ps2_keyboard IS      
  port(
    clk          : in  std_logic;                     
    ps2_clk      : in  std_logic;                     
    ps2_data     : in  std_logic;                     
    newps : inout std_logic;                    
    bcds     : inout std_logic_vector(7 downto 0)); 
end ps2_keyboard;

architecture behavioral of ps2_keyboard IS      
  signal ps2_clk_output  : std_logic;                          
  signal ps2_data_output : std_logic;                          
  signal ps2_input     : std_logic_vector(10 downto 0);      
  signal parity        : std_logic;                          
  signal counter   : integer RANGE 0 TO 2778; 
  
begin
 
  process(clk)
  begin
    if(clk'EVENT and clk = '1') then  
			ps2_clk_output <= ps2_clk;
			ps2_data_output <= ps2_data;
    end if;
  end process;

  process(ps2_clk_output)
  begin
    if(ps2_clk_output'EVENT and ps2_clk_output = '0') then    
      ps2_input <= ps2_data_output & ps2_input(10 downto 1);  
    end if;
  end process;
    
  parity <= not (not ps2_input(0) and ps2_input(10) and (ps2_input(9) xor ps2_input(8) xor
        ps2_input(7) xor ps2_input(6) xor ps2_input(5) xor ps2_input(4) xor ps2_input(3) xor 
        ps2_input(2) xor ps2_input(1)));  

  process(clk)
  begin
    if(clk'EVENT and clk = '1') then          
      if(ps2_clk_output = '0') then                 
        counter <= 0;                          
      elsif(counter /= 2778) then 
          counter <= counter + 1;            
      end if;
      
      if(counter = 2778 and parity = '0') then 
        newps <= '1';                                   
        bcds <= ps2_input(8 downto 1);                      
      else                                                   
        newps <= '0';                                  
      end if;
      
    end if;
  end process;
end behavioral;