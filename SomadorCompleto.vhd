--       _____
--   A--|     |--S
--   B--| SUM |
-- VEM--|_____|--VAI
 
library ieee;
use ieee.std_logic_1164.all

entity somador is 
	port(
		A	: in std_logic,
		B	: in std_logic,
		VEM	: in std_logic,
		VAI	: out std_logic,
		S	: out std_logic
	);
end somador;

architecture a of somador
begin
	S   <= A xor B xor VEM;
	VAI <= (A and B) or (A and VEM) or (B and VEM);
end a;
