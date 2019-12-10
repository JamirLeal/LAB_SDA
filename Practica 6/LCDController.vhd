LIBRARY ieee;
use ieee.std_logic_1164.all;

entity lcd_controller is
  port(clk        : in    std_logic;  
    reset_n    : in    std_logic;  
    lcd_enable : in    std_logic; 
    lcd_bus    : in    std_logic_vector(9 downto 0);  
    busy       : out   std_logic := '1';  
    rw, rs, e  : out   std_logic;
    lcd_data   : out   std_logic_vector(7 downto 0)); 
end lcd_controller;

architecture controller of lcd_controller is
  type CONTROL is(power_up, initialize, ready, send);
  signal    state      : CONTROL;
  constant  freq       : integer := 50; 
begin
  process(clk)
    variable clk_count : integer := 0; 
  begin
  if(clk'EVENT and clk = '1') then

      case state is

        when power_up =>

          busy <= '1';

          if(clk_count < (50000 * freq)) then    
            clk_count := clk_count + 1;
            state <= power_up;

          else                                  

            clk_count := 0;
            rs <= '0';
            rw <= '0';
            lcd_data <= "00110000";
            state <= initialize;

          end if;

       

        when initialize =>

          busy <= '1';

          clk_count := clk_count + 1;

          if(clk_count < (10 * freq)) then       
            lcd_data <= "00111100";    

            e <= '1';

            state <= initialize;

          elsif(clk_count < (60 * freq)) then    

            lcd_data <= "00000000";

            e <= '0';

            state <= initialize;

          elsif(clk_count < (70 * freq)) then   

            lcd_data <= "00001100";      
            e <= '1';
            state <= initialize;

          elsif(clk_count < (120 * freq)) then   
            lcd_data <= "00000000";
            e <= '0';
            state <= initialize;

          elsif(clk_count < (130 * freq)) then   

            lcd_data <= "00000001";
            e <= '1';
            state <= initialize;

          elsif(clk_count < (2130 * freq)) then 
            lcd_data <= "00000000";
            e <= '0';
            state <= initialize;
          elsif(clk_count < (2140 * freq)) then 

            e <= '1';

            state <= initialize;

          elsif(clk_count < (2200 * freq)) then 

            lcd_data <= "00000000";

            e <= '0';

            state <= initialize;

          else                                   

            clk_count := 0;
            busy <= '0';
            state <= ready;

          end if;    

     

        when ready =>
          if(lcd_enable = '1') then
            busy <= '1';
            rs <= lcd_bus(9);
            rw <= lcd_bus(8);
            lcd_data <= lcd_bus(7 downto 0);
            clk_count := 0;            
            state <= send;

          else

            busy <= '0';
            rs <= '0';
            rw <= '0';
            lcd_data <= "00000000";
            clk_count := 0;
            state <= ready;

          end if;

        
        when send =>
        busy <= '1';
        if(clk_count < (50 * freq)) then  
           busy <= '1';
           if(clk_count < freq) then     
            e <= '0';
           elsif(clk_count < (14 * freq)) then  
            e <= '1';
           elsif(clk_count < (27 * freq)) then  
            e <= '0';
           end if;
           clk_count := clk_count + 1;
           state <= send;
        else
          clk_count := 0;
          state <= ready;
        end if;
      end case;    

      if(reset_n = '1') then
          state <= power_up; 
      end if;
    end if;
  end process;
end controller;