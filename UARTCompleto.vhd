--     _   ________
--   R/W--|        |
-- data-8-|        |<--Rx
-- READY--|  UART  |
--   CLK--|>       |-->Tx
--   RST--|________|


library ieee;
use ieee.std_logic_1164.all;

entity UART is
	port(
		-- control
		rw		: in	std_logic,
		data	: inout	std_logic_vector(7 downto 0),
		ready	: in	std_logic,
		-- circuit
		clk		: in	std_logic,
		rst		: in	std_logic,
		-- communication
		rx		: in	std_logic,
		tx		: out	std_logic
	);
end UART;

architecture a of UART is

type tipoestado is(QIDLE,QSTART,QSEND,QSTOP,QCHECK,QRCV,QEND);
signal estado: tipoestado;
signal cnt integer range 0 to 7; 
signal oversampling integer range 0to 15;
signal clkcnt integer range 0 to oversampling;
signal buff: std_logic_vector(7 downto 0)
begin
	process(clk,rst)
		if rst='1' then
			estado <= IDLE;
		elsif rising_edge(clk) then
			case estado is
			when QIDLE =>
				clkcnt <= oversampling;
				if rw = '0' then
					estado <= QSTART;
				elsif rw = '1' and rx = '0'
					estado <= QWAIT;
				end if;
--- WRITE-----------------------
			when QSTART =>
				if clkcnt = '0' then
					estado <= QSEND;
					clkcnt <= oversampling;
					cnt <= 7;
					buff <= data;
				else 
					clkcnt <= clkcnt - 1;
				end if;
			when QSEND =>
				if clkcnt = '0' then
					buff <= '0' & buff(7 down to 1);
					cnt <= cnt-1;
					clkcnt <= oversampling;
					if cnt = '0' then
						estado <= QSTOP;
					end if;
				else
					clkcnt <= clkcnt -1 ;
	 			end if;
			when QSTOP =>
				if clkcnt = '0' then
					estado <= QIDLE;
				else
					clkcnt <= clkcnt-1 ;
				end if;
--- READ---------------------
			when QWAIT =>
				if clkcnt = '0' and rx = '0' then
					estado <= QRCV;
					clkcnt <= oversampling;
					cnt <= 7;
				elsif rx = '0' then
					clkcnt <= oversampling/2;
				elsif clkcnt = '0'
					estado <= QIDLE;
				else 
					clkcnt <= clkcnt -1;
				end if;
			when QRCV =>
				if clkcnt = '0' then
					buff <= tx & buff(7 downto 1);
					cnt <= cnt-1
					clkcnt <= oversampling;
					if cnt = '0' then
						estado <= QEND;
					end if;
				else
					clkcnt <= clkcnt-1;
				end if;
			when QEND =>
				if clkcnt = '0' then
					estado <= QIDLE
				else 
					clkcnt <= clkcnt-1;
				end if;
			end case;
		end if;
	end process;
	
	tx <= buff(0) 	when estado = QSEND
					else '1';
	ready <= '1'	when estado = QEND
					else '0';
	data <= buff 	when estado = QEND
					else "zzzzzzzz";
end architecture a;
	 
	
					 
				
