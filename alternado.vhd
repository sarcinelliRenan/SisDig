--         ______
--input---|      |-16->data
--   clk--|>     |<--ack
--   rst--|______|--->strobe

library ieee;
use ieee.std_logic_1164.all

entity alternado is 
	port (
		input	: in 	std_logic; 
		clk		: in 	std_logic;
		rst		: in 	std_logic;
		data	: out 	std_logic_vector(15 downto 0);
		ack		: in 	std_logic;
		strobe	: out 	std_logic
	);
end entity alternado;

architecture a of alternado is

type tipoestado is (QIDLE,QMONITOR,QL1,QL2,QL3,QRECEBE,QPAR,QSTROBE)
signal estado : tipoestado;
signal clkdiv: integer range 0 to 1000;
signal clkcnt: integer range 0 to 1000;
signal bitcnt: integer range 0 to 15;
signal buff : std_logic_vector(15 downto 0);
signal par,p : std_logic;

begin
	data <= buff 	when estado = QSTROBE else (others => 'z');
	strobe <= '1' 	when estado = QSTROBE else '0';

	process(rst,clk)
	begin
		if rst='1' then
			estado <= QIDLE
		elsif rising_edges(clk) then
			case estado is
			when QIDLE =>
				if input = '1' then
					estado <= QMONITOR;
					clkdiv <= 0;
				end if;
			when QMONITOR =>
				if input = '0' then 
					clkcnt <= clkdiv/2;
					estado <= QL1;
				else
					clkdiv <= clkdiv + 1;
				end if;
			when QL1 =>
				if clkcnt = 0 then
					if input = '0' then 
						clkcnt <= clkdiv;
						estado <= QL2;
					else 
						estado <= QIDLE;
					end if;
				else
					clkcnt <= clk cnt - 1;
				end if;
			when QL2 =>
				if clkcnt = 0 then
					if input = '1' then 
						clkcnt <= clkdiv;
						estado <= QL2;
					else 
						estado <= QIDLE;
					end if;
				else
					clkcnt <= clk cnt - 1;
				end if;
			when QL3 =>
				if clkcnt = 0 then
					if input = '0' then 
						clkcnt <= clkdiv;
						estado <= QL2;
						bitcnt <= 15;
					else 
						estado <= QIDLE;
					end if;
				else
					clkcnt <= clk cnt - 1;
				end if;
			when QRECEBE =>
				if clkcnt = 0 then
					if bitcnt = 0
						par <= data
					else 
						buff <= buff(140 downto 0)&input;
						bitcnt <= bitcnt - 1;
						cnt <= clkcnt;
						p <= p xor input;
					end if;
				else
					clkcnt <= clkcnt - 1;
				end if;
			when QPAR =>
				if p = par then
					estado <= QSTROBE;
				else
					estado <= QIDLE;
				end if;
			when QSTROBE =>
				if ack = '1' then
					estado <= QIDLE;
				end if;
			end case;
		end if;
	end process;
end architecture a; 
