--       ______
--   A--|      |--DIR[2]
--   B--| QUAD |
-- CLK--|>     |
-- RST--|______|--PULSO

entity quadratura is 
	port(
		a 	: in std_logic, 
		b 	: in std_logic,
		clk	: in std_logic,
		rst	: in std_logic,
		dir	: out std_logic,
		pul	: out std_logic
	);
end quadratura;

architecture a of quadratura
type tipoestado is (Q0,Q1,Q2,Q3);
signal estado : tipoestado;
begin
	process (clk, rst)
	begin
		if rst = '1' then
			estado <= QO;
		elsif rising_edge(clk) then
			case estado is
				when Q0 =>
					if a='1' and b='0' then
						estado <= Q1;
					elsif a='0' and b='1' then
						estado <= Q3;
					else
						estado <= Q0;
					end if;
				when Q1 =>
					if a='1' and b='1' then
						estado <= Q2;
					elsif a='0' and b='0' then
						estado <= Q0;
					else
						estado <= Q1;
					end if;
				when Q2 =>
					if a='1' and b='0' then
						estado <= Q3;
					elsif a='0' and b='1' then
						estado <= Q1;
					else
						estado <= Q2;
					end if;
				when Q3 =>
					if a='0' and b='0' then
						estado <= Q0;
					elsif a='1' and b='1' then
						estado <= Q2;
					else
						estado <= Q3;
					end if;
			end case;
		end if;
	end process;
	
	dir <= '0' 	when 
				(estado=Q0 and a ='1' and b ='0') or
				(estado=Q1 and a ='1' and b ='1') or
				(estado=Q2 and a ='0' and b ='1') or
				(estado=Q3 and a ='0' and b ='0') 
				else '1'when
				(estado=Q0 and a ='0' and b ='1') or
				(estado=Q1 and a ='0' and b ='0') or
				(estado=Q2 and a ='1' and b ='0') or
				(estado=Q3 and a ='1' and b ='1') ;				

	pul <= '0' 	when 
				(estado=Q0 and a ='0' and b ='0') or
				(estado=Q1 and a ='0' and b ='1') or
				(estado=Q2 and a ='1' and b ='0') or
				(estado=Q3 and a ='1' and b ='1') 
				else '1' ;
end a;
