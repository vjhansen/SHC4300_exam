-- Basic CPU 

library	ieee;
use	ieee.std_logic_1164.all;
use	ieee.numeric_std.all;

entity	cpu is
	port(
		clk, reset: in std_logic;
		db: in std_logic_vector(7 downto 0);  -- data bus
		ab: out std_logic_vector(7 downto 0); -- address bus
		ob: out std_logic_vector(7 downto 0)  -- output bus
		);
end cpu;

architecture arch of cpu is
    constant ABW: integer:=8;
    constant DBW: integer:=8;
	constant LDRM: unsigned := "10100000"; -- A0H	
	constant HALT: unsigned := "11111111"; -- FFH
	
	type	state_type is (
		  all_0, all_1,   -- common to all instructions
		  ldrm_2         -- instruction LD R,M
		 );
	signal	state_reg, state_next:	state_type;
	signal	pc_reg, pc_next: unsigned(ABW-1 downto 0);
	signal	ir_reg, ir_next: unsigned(DBW-1 downto 0);
	signal	r_reg, r_next: unsigned(DBW-1 downto 0);

begin
process(clk,reset)						-- state register code section
begin
	if (reset='1') then
		state_reg <= all_0;
		pc_reg <= (others => '0');	-- reset address is all-0
		ir_reg <= (others => '1'); 	-- default opcode is HALT (all '1')
		r_reg  <= (others => '0');	-- initialize data register to 0
	elsif (clk'event and clk='1') then
		state_reg <= state_next;
		pc_reg <= pc_next;
		ir_reg <= ir_next;
		r_reg <= r_next;
	end if;
end process;

process(state_reg,db,pc_reg,r_reg)	-- next state + (Moore) outputs code section
begin
	state_next <= state_reg;
	pc_next <= pc_reg;	
	ir_next <= ir_reg;
	r_next <= r_reg;
	
	case state_reg is
		when all_0 => 					 
			ir_next <= unsigned(db);  
			pc_next <= pc_reg+1;
			state_next <= all_1;
		when all_1 =>			
			if (ir_reg = LDRM) then	  
				state_next <= ldrm_2;
			elsif (ir_reg = HALT) then
				state_next <= all_1;
			else 
				state_next <= all_0;
			end if;
														-- Instruction RST 			
		when ldrm_2 =>					
			r_next <= unsigned(db);
			pc_next <= pc_reg+1;
			state_next <= all_0;
			
	end case; 
end process;

ab <= std_logic_vector(pc_reg);
ob <= std_logic_vector(r_reg);

end arch;


