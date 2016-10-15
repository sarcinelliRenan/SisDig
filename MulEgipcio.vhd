--         ________
--    x-n-|        |
--    y-n-|        |-2n->s
-- start--|  MULT  |
--   clk--|>       |-->ready
--   rst--|________|

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mult is
	generic (n:natural := 8);
	port(
		rst		: in std_logic;
		clk		: in std_logic;
		start	: in std_logic;
		x		: in std_logic_vector(n downto 0);
		y		: in std_logic_vector(n downto 0);
		s		: out std_logic_vector(2*n downto 0);
		ready	: out std_logic
	);
end entity mult;

architecture a of mult is 

type tipoestado is (QIDLE,QMULT,QRESULT);
signal estado : tipoestado;
signal mult : std_logic_vector (2*n downto 0);
signal a,b : std_logic_vector (n downto 0);

begin
	s <= mult;

	ready <= '1'	when estado = QRESULT
					else '0';
	process(clk,rst)
	begin
		if rst = '1'then
			estado <= QIDLE;
		elsif rising_edge(clk) then
			case estado is
			when QIDLE =>
				if start = '1' then
					estado <= QMULT;
					a <= x;
					b <= y;
					mult <= (others => '0');
				end if;
			when QMULT =>
				if unsigned(a) /= 1 then 
					a <= '0' & a(n downto 1);
					b <= y(n-1 downto 0) & '0';
					if x(0) = '1' then 
						mult <= std_logic_vector(unsigned(mult)+unsigned(b));
					end if;
				else
					estado <= QRESULT ;
				end if;
			when QRESULT =>
				estado <= QIDLE;
			end case;		
		end if;
	end process;
end architecture a;
