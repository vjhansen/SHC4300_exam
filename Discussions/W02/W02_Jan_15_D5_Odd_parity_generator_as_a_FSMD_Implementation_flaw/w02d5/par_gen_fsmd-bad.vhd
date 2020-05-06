-- DFDS-3101 2016/17 odd parity generator as a FSMD (bad) | josemmf | 2016.10.09

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity par_gen_fsmd is
   port(
      clk, reset: in std_logic;
      input: in std_logic;
      output: out std_logic
		);
end par_gen_fsmd;

architecture arch of par_gen_fsmd is
   type state_type is (state0, state1);
   signal state_reg, state_next: state_type;
   signal bit_cntr_reg, bit_cntr_next: unsigned(3 downto 0);
   signal par_reg, par_next: std_logic;

begin
   -- state register
   process(clk,reset)
   begin
      if (reset='1') then
         state_reg <= state0;
         bit_cntr_reg <= (others => '0');
         par_reg <= '0';
      elsif (clk'event and clk='1') then
         state_reg <= state_next;
         bit_cntr_reg <= bit_cntr_next;
         par_reg <= par_next;
      end if;
   end process;
	
   -- next-state/output logic
   process(state_reg, input, bit_cntr_reg)
   begin
    
      state_next <= state_reg;
      bit_cntr_next <= bit_cntr_reg;
      par_next <= par_reg;

      case state_reg is
		
        when state0 =>
            bit_cntr_next <= "1000";
            if (input = '0') then -- wait for start bit
                state_next <= state1;							
			end if;
				
        when state1 =>
            if (bit_cntr_reg = 0) then
                output <= not(par_reg);
                state_next <= state0;
            elsif (input = '1') then
                 par_next <= not(par_reg);
                 bit_cntr_next <= bit_cntr_reg-1;    
            else
                 bit_cntr_next <= bit_cntr_reg-1;
            end if;                       
                                   		
        end case;
   end process;

end arch;

