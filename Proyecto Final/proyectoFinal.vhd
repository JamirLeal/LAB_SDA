library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Pong is
    Port (clk : in STD_LOGIC;
		sin_hor_s : out STD_LOGIC; -- Sincronizacion Horizontal
		sin_ver_s : out STD_LOGIC; -- Sincronizacion Vertical
		rojo_s : out STD_LOGIC;	   -- R
		verde_s : out STD_LOGIC;   -- G
		azul_s : out STD_LOGIC;	   -- B
		ps2_clk : in STD_LOGIC;    -- Reloj de sincronizacion con el teclado
		datos_kb : in STD_LOGIC);  -- Datos del teclado
end Pong;

architecture Behavioral of Pong is

	component ControladorTeclado is
		Port (Clock 	: in STD_LOGIC;
		Clock_Teclado 	: in  STD_LOGIC;
	   Datos_Teclado 	: in  STD_LOGIC;
	   Dir_Barra_Izq 	: buffer  integer;
	   Dir_Barra_Der 	: buffer  integer);
	end component;

	signal clock_Vga : STD_LOGIC;
	signal posicion_Horizontal : integer range 0 to 800 := 0;
	signal posicion_Vertical : integer range 0 to 521 := 0;
	signal hsyncEnable : STD_LOGIC;
	signal vsyncEnable : STD_LOGIC;
	signal vga_X : integer range 0 to 640 := 0;
	signal vga_Y : integer range 0 to 480 := 0;
	constant barra_IzqX : integer := 25;
	signal barra_IzqY : integer range 0 to 480 := 240;
	constant barra_DerX : integer := 615;
	signal barra_DerY : integer range 0 to 480 := 240;
	signal barra_Der_Direccion : integer := 0;
	signal barra_Izq_Direccion : integer := 0;
	signal barra_Mitad_Altura : integer range 0 to 50 := 30;
	constant barra_Mitad_Anchura : integer := 6;
	constant lim_Barra_Izq_I : integer := barra_IzqX-barra_Mitad_Anchura;
	constant lim_Barra_Izq_D : integer := barra_IzqX+barra_Mitad_Anchura;
	constant lim_Barra_Der_D : integer := barra_DerX-barra_Mitad_Anchura;
	constant lim_Barra_Der_I : integer := barra_DerX+barra_Mitad_Anchura;
	constant lim_Inf_Barra : integer := 474;
	constant lim_Sup_Barra : integer := 4;
	signal rgb : STD_LOGIC_VECTOR (2 downto 0) := "000";
	signal cont_Reloj_Mov_Bola : integer range 0 to 1000000 := 0;
	signal reloj_Mov_Bola : STD_LOGIC := '0';
	signal cont_Reloj_Mov_Barra : integer range 0 to 1000000 := 0;
	signal reloj_Mov_Barra : STD_LOGIC := '0';
	constant vel_Max_Pelota : integer := 8;
	signal pos_Pelota_X : integer range -100 to 640 := 320;
	signal pos_Pelota_Y : integer range -100 to 480 := 240;
	signal vel_Pelota_X : integer range -100 to 100 := 1;
	signal vel_Pelota_Y : integer range -100 to 100 := 1;
	constant max_Vidas : integer := 5;
	signal vidas_Izq : integer range 0 to 5 := max_Vidas;
	signal vidas_Der : integer range 0 to 5 := max_Vidas;
	signal fin_Juego : STD_LOGIC := '0';
	constant posIni_Vida_Izq : integer := 179;
	constant posIni_Vida_Der : integer := 359;
	constant ancho_Barra_Vida : integer := 100;
	constant alto_Barra_Vida : integer := 3;
	signal reinicio_Pelota : STD_LOGIC := '0';
	signal contador_Reinicio : integer range 0 to 101 := 0;

	begin
		controlador_Teclado : KeyboardController port map (clk, ps2_clk, datos_kb, barra_Izq_Direccion, barra_Der_Direccion);
		-- Generacion pulso de Reloj-VGA
		ajuste_Reloj_Vga 		: process(clk) -- Reloj del vga
			begin
				if rising_edge(clk) then
					clock_Vga <= not clock_Vga;
				end if;
		end process ajuste_Reloj_Vga;
		-- Creacion Pulso del Movimiento de la pelota
		ajuste_Reloj_Mov_Bola 	: process(clk) -- Movimiento de la bola en pulso de reloj (Se detiene en el borde de la vga)	
			begin
				if rising_edge(clk) then
					cont_Reloj_Mov_Bola <= cont_Reloj_Mov_Bola + 1;
					if (cont_Reloj_Mov_Bola = 500000) then
						reloj_Mov_Bola <= not reloj_Mov_Bola;
						cont_Reloj_Mov_Bola <= 0;
					end if;
				end if;
		end process ajuste_Reloj_Mov_Bola;
		-- Creacion Pulso del Mov De una Barra
		ajuste_Reloj_Mov_Barra 	: process(clk) -- Movimiento de la barra en pulso de reloj (Se detiene en el borde de la vga)
			begin
				if rising_edge(clk) then
					cont_Reloj_Mov_Barra <= cont_Reloj_Mov_Barra + 1;
					if (cont_Reloj_Mov_Barra = 100000) then
						reloj_Mov_Barra <= not reloj_Mov_Barra;
						cont_Reloj_Mov_Barra <= 0;
					end if;
				end if;
		end process ajuste_Reloj_Mov_Barra;
		-- Movimiento de la barra del Jugador Izquierdo
		mov_Barra_Izq 			: process(reloj_Mov_Barra) -- Control del jugador izquierdo (Se detiene en el limite)
			begin
				if rising_edge(reloj_Mov_Barra) then
					if barra_IzqY + barra_Izq_Direccion < lim_Inf_Barra - barra_Mitad_Altura and barra_IzqY + barra_Izq_Direccion > lim_Sup_Barra + barra_Mitad_Altura then
						barra_IzqY <= barra_IzqY + barra_Izq_Direccion;
					end if;
				end if;
		end process mov_Barra_Izq;
		-- Movimiento de la barra del Jugador Derecho
		mov_Barra_Der 			: process(reloj_Mov_Barra) -- Control del jugador derecho (Se detiene en el limite)
			begin
				if rising_edge(reloj_Mov_Barra) then
					if barra_DerY + barra_Der_Direccion < lim_Inf_Barra - barra_Mitad_Altura and barra_DerY + barra_Der_Direccion > lim_Sup_Barra + barra_Mitad_Altura then
						barra_DerY <= barra_DerY + barra_Der_Direccion;
					end if;
				end if;
		end process mov_Barra_Der;
		-- Trayectoria De la Pelota
		mov_Bola 				: process(reloj_Mov_Bola,fin_Juego)
			begin
				if fin_Juego = '1' then	-- Detiene la pelota en el centro cuando termina el juego
					pos_Pelota_X <= 319;
					pos_Pelota_Y <= 239;
					vel_Pelota_X <= 0;
					vel_Pelota_Y <= 0;
				elsif rising_edge(reloj_Mov_Bola) then
					if reinicio_Pelota = '1' then
						if contador_Reinicio = 100 then
							contador_Reinicio <= 0;
							pos_Pelota_X <= 319;
							pos_Pelota_Y <= 239;
							reinicio_Pelota <= '0';
						else
							contador_Reinicio <= contador_Reinicio + 1;
						end if;
					else
						if pos_Pelota_X+4 > lim_Barra_Der_D and pos_Pelota_X < lim_Barra_Der_I and pos_Pelota_Y+4 > barra_DerY-barra_Mitad_Altura and pos_Pelota_Y-4 < barra_DerY+barra_Mitad_Altura then
							pos_Pelota_X <= lim_Barra_Der_D - 4; -- Movimiento hacia la izquierda 
							vel_Pelota_Y <= (pos_Pelota_Y - barra_DerY) / 8;
							vel_Pelota_X <= -vel_Max_Pelota + vel_Pelota_Y;
						elsif pos_Pelota_X-4 < lim_Barra_Izq_D and pos_Pelota_X > lim_Barra_Izq_I and pos_Pelota_Y+4 > barra_IzqY-barra_Mitad_Altura and pos_Pelota_Y-4 < barra_IzqY+barra_Mitad_Altura then
							pos_Pelota_X <= lim_Barra_Izq_D + 4; -- Moviemiento hacia la derecha
							vel_Pelota_Y <= ((pos_Pelota_Y - barra_IzqY) / 8);
							vel_Pelota_X <= vel_Max_Pelota - vel_Pelota_Y;
						elsif pos_Pelota_X + vel_Pelota_X < 4 then
							vidas_Izq <= vidas_Izq - 1; -- Se salio por la izquierda
							pos_Pelota_X <= -20;
							pos_Pelota_Y <= -20;
							reinicio_Pelota <= '1';
						elsif pos_Pelota_X + vel_Pelota_X > 635 then
							vidas_Der <= vidas_Der - 1; -- Se salio por la derecha
							pos_Pelota_X <= -20;
							pos_Pelota_Y <= -20;
							reinicio_Pelota <= '1';
						else
							pos_Pelota_X <= pos_Pelota_X + vel_Pelota_X;
						end if;
						
						if pos_Pelota_Y > 470 then
							pos_Pelota_Y <= 470;
							vel_Pelota_Y <= -vel_Pelota_Y;
						elsif pos_Pelota_Y < 10 then
							pos_Pelota_Y <= 10;
							vel_Pelota_Y <= -vel_Pelota_Y;
						else
							pos_Pelota_Y <= pos_Pelota_Y + vel_Pelota_Y;
						end if;
					end if;
				end if;
		end process mov_Bola;
	    -- Actualiza el color que tendra cierto pin
		generador_Rgb 			: process(vga_X, vga_Y, clock_Vga)
			begin
				-- Control de las barras
				if (vga_X >= lim_Barra_Izq_I) and (vga_X <= lim_Barra_Izq_D) and (vga_Y >= barra_IzqY - barra_Mitad_Altura) and (vga_Y <= barra_IzqY + barra_Mitad_Altura) then
					rgb <= "011";
				elsif (vga_X >= lim_Barra_Der_D) and (vga_X <= lim_Barra_Der_I) and (vga_Y >= barra_DerY - barra_Mitad_Altura) and (vga_Y <= barra_DerY + barra_Mitad_Altura) then
					rgb <= "110";
				-- Linea central
				elsif (vga_X = 319) then
					rgb <= "111";
				-- Pelota
				elsif (vga_Y >= pos_Pelota_Y - 2 and vga_Y <= pos_Pelota_Y + 2) and (vga_X >= pos_Pelota_X - 2 and vga_X <= pos_Pelota_X + 2) then
					rgb <= "101";
				elsif (vga_Y >= pos_Pelota_Y - 3 and vga_Y <= pos_Pelota_Y + 3) and (vga_X >= pos_Pelota_X - 1 and vga_X <= pos_Pelota_X + 1) then
					rgb <= "101";
				elsif (vga_Y >= pos_Pelota_Y - 1 and vga_Y <= pos_Pelota_Y + 1) and (vga_X >= pos_Pelota_X - 3 and vga_X <= pos_Pelota_X + 3) then
					rgb <= "101";
				-- Barra de vida (verde)
				elsif (vga_X>=posIni_Vida_Izq and vga_X<posIni_Vida_Izq+(vidas_Izq*20) and vga_Y>=30 and vga_Y<=30+alto_Barra_Vida) or (vga_X>=posIni_Vida_Der and vga_X<posIni_Vida_Der+(vidas_Der*20) and vga_Y>=30 and vga_Y<=30+alto_Barra_Vida) then
					rgb <= "010";
				-- Barra de vida perdida (Roja)
				elsif (vga_X >= (posIni_Vida_Izq+(vidas_Izq*20)) and vga_X <= (posIni_Vida_Izq+(20*max_Vidas)) and vga_Y>=30 and vga_Y<=(30+alto_Barra_Vida)) or (vga_X>=(posIni_Vida_Der+(vidas_Der*20)) and vga_X<= (posIni_Vida_Der+(20*max_Vidas)) and vga_Y>=30 and vga_Y<=(30+alto_Barra_Vida)) then
					rgb <= "100";
				-- Fondo
				else
					rgb <= "000";
				end if;
		end process generador_Rgb;
		-- Generacion senal VGA
		senal_Vga 				: process(clock_Vga)
			begin
				if rising_Edge(clock_Vga) then
					if posicion_Horizontal = 800 then
						posicion_Horizontal <= 0;
						posicion_Vertical <= posicion_Vertical + 1;
						
						if posicion_Vertical = 521 then
							posicion_Vertical <= 0;
						else
							posicion_Vertical <= posicion_Vertical + 1;
						end if;
					else
						posicion_Horizontal <= posicion_Horizontal + 1;
					end if;
				end if;
		end process senal_Vga;
		-- Sincro Hor-Ver VGA
		sincronizacion_Vga 		: process(clock_Vga, posicion_Horizontal, posicion_Vertical)
			begin
				if rising_Edge(clock_Vga) then
					if posicion_Horizontal > 0 and posicion_Horizontal < 97 then
						hsyncEnable <= '0';
					else
						hsyncEnable <= '1';
					end if;
					
					if posicion_Vertical > 0 and posicion_Vertical < 3 then
						vsyncEnable <= '0';
					else
						vsyncEnable <= '1';
					end if;
				end if;
		end process sincronizacion_Vga;
		-- Posicionamiento en coordenadas XY dentro del VGA
		coordenadas : process(posicion_Horizontal, posicion_Vertical)
			begin
				vga_X <= posicion_Horizontal - 144;
				vga_Y <= posicion_Vertical - 31;
		end process coordenadas;
		-- Controlador VGA
		colocar_vga : process(vga_X, vga_Y, clock_Vga)
			begin
				if rising_Edge(clock_Vga) then
					sin_hor_s <= hsyncEnable;
					sin_ver_s <= vsyncEnable;
					
					if (vga_X < 640 and vga_Y < 480) then
						rojo_s <= rgb(2);
						verde_s <= rgb(1);
						azul_s <= rgb(0);
					else
						rojo_s <= '0';
						verde_s <= '0';
						azul_s <= '0';
					end if;
				end if;
		end process colocar_vga;
		-- Finalizacion Del Juego
		fin_Del_Juego : process(vidas_Izq, vidas_Der)
			begin
				if vidas_Izq = 0 or vidas_Der = 0 then
					fin_Juego <= '1';
				end if;
		end process fin_Del_Juego;
end Behavioral;