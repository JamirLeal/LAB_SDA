library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ControladorTeclado is
    Port ( Clock            : in STD_LOGIC;
	       Clock_Teclado    : in  STD_LOGIC;
           Datos_Teclado    : in  STD_LOGIC;
           Dir_Barra_Izq    : buffer  integer;
           Dir_Barra_Der    : buffer  integer
	);
end ControladorTeclado;

architecture Behavioral of ControladorTeclado is

signal contBits : integer range 0 to 100 := 0;
signal scancodeListo : STD_LOGIC := '0';
signal scancode : STD_LOGIC_VECTOR(7 downto 0);
signal recibido : STD_LOGIC := '0';

constant teclaA : STD_LOGIC_VECTOR(7 downto 0) := "00011100";
constant teclaY : STD_LOGIC_VECTOR(7 downto 0) := "00011010";
constant teclaK : STD_LOGIC_VECTOR(7 downto 0) := "01000010";
constant teclaM : STD_LOGIC_VECTOR(7 downto 0) := "00111010";

begin

	recepcion_Datos : process(Clock_Teclado)
	begin
		if falling_edge(Clock_Teclado) then
			if contBits = 0 and Datos_Teclado = '0' then -- El teclado tiene nueva informacion para enviar
				scancodeListo <= '0';
				contBits <= contBits + 1;
			elsif contBits > 0 and contBits < 9 then -- Hacemos shift a la izquierda
				scancode <= Datos_Teclado & scancode(7 downto 1);
				contBits <= contBits + 1;
			elsif contBits = 9 then -- Bit de paridad
				contBits <= contBits + 1;
			elsif contBits = 10 then -- Fin del mensaje
				scancodeListo <= '1';
				contBits <= 0;
			end if;
		end if;
	end process recepcion_Datos;
	
	generacion_Movimiento : process(scancodeListo, scancode)
	begin
        if rising_edge(scancodeListo) then
			-- Cortamos el mensaje del scancode
			if recibido = '1' then 
				recibido <= '0';
				if scancode = teclaA or scancode = teclaY then
					Dir_Barra_Izq <= 0;
				elsif scancode = teclaK or scancode = teclaM then
					Dir_Barra_Der <= 0;
				end if;
			elsif recibido = '0' then
				-- Marcamos el recibido
				if scancode = "11110000" then -- Marca para cuando recibamos el siguiente
					recibido <= '1';
				end if;
				
				if scancode = teclaA then
					Dir_Barra_Izq <= -1;
				elsif scancode = teclaY then
					Dir_Barra_Izq <= 1;
				elsif scancode = teclaK then
					Dir_Barra_Der <= -1;
				elsif scancode = teclaM then
					Dir_Barra_Der <= 1;
				end if;
			end if;
		end if;
	end process generacion_Movimiento;
end Behavioral;