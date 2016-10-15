--         ________
-- data-8-|        |
-- send---|  CAN   |--->s
--   clk--|>       |
--   rst--|________|

library ieee;
use ieee.std_logic_1164.all

entity can is
	port(
		data	: in	std_logic_vector(8 downto 0);
		send	: in	std_logic;
		s		: out	std_logic;
		clk		: in	std_logic;
		rst		: in	std_logic
	);
end entity can;

architecture a of can is

type tipoestado is (QIDLE,QSEND,QEND,QSTUFF,QSTART);
signal estado: tipoestado;
signal buff: std_logic_vector(7 downto 0);
signal bitcnt,bytecnt: integer range 0 to 7;
signal onecnt: integer range 0 to 4;
signal clkcnt: integer range 0 to 15;

begin
	can <= buff(0) 	when estado = QSEND
					elsif '0' when estado = QSTUFF or estado = QSTART
					elsif '1' when estado = QEND or estado = Q
					
					else '1';
	process (clk,rst)
		if rst='1' then 
			estado = QIDLE;
		elsif rising_edges(clk) then
			case estado is
			when QIDLE =>
				if send ='1' then
					clkcnt <= 15;
					estado <= QSTART;
				end if;
			when QSTART =>
				if clkcnt = 0 then
					estado <= QSEND;
					bytecnt <= 7;
					bitcnt <= 7;
					onecnt <= 4;
					clkcnt <= 15;
					buff <= data;
				else 
					clkcnt <= clkcnt -1 ;
				end if;
			when QSEND =>
				/*if bitcnt = 0 then
					bitcnt <= 7;
					onecnt <= 4;
					clkcnt <= 15;
					buff <= data;
					if bytecnt = 0
						estado <= QEND
					end if;
				elsif bit*/
				if bitcnt /= then
					bitcnt <= bitcnt - 1;
				else
					bitcnt <= 7;
					bytecnt <= bytecnt - 1;
					if send = 1 and bytecnt /= 0 then
						buff <= data;
						onecnt <= 4;
					else
						estado <= QEND;
						bitcnt <= 6;
					end if;
				end if;
				if buff(0) = '1' then
					onecnt <= onecnt - 1;
				else
					onecnt <= 4;
				end if;
				if onecnt = '0' then
					estado <= QSTUFF;
				else
					buff <= '0' & buff(7 downto 1);
				end if;
			when QSTUFF =>
				bitcnt <= bitcnt + 1;
				onecnt <= 4;
				estado <= QSEND;  
			when QEND =>
				if bitcnt = 0 then
					estado <= QIDLE;
				else
					bitcnt <= bitcnt - 1;
				end if;
			end case;
		end if;
	end process;
end architecture a of can;
