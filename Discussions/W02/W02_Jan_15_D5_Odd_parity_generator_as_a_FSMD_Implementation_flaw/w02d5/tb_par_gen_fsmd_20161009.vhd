library ieee;
use ieee.std_logic_1164.all;

entity tb_par_gen_fsmd is
end tb_par_gen_fsmd;

architecture tb of tb_par_gen_fsmd is

    component par_gen_fsmd
        port (clk, reset : in std_logic;
              input   : in std_logic;
              output   : out std_logic
			  );
    end component;

    signal clk, reset : std_logic;
    signal input   : std_logic; -- module input
    signal output   : std_logic; -- module output

    constant clk_period : time := 10 ns;

begin

    uut : par_gen_fsmd
    port map (clk => clk, reset => reset,
              input => input,
              output => output);


clk_process: process 
   begin
      clk <= '0';
      wait for clk_period/2;
      clk <= '1';
      wait for clk_period/2;
   end process;

-- Stimuli process 
   stim_proc: process
      begin
         input <= '1';
         reset <= '1';      
         wait for clk_period*2;
         reset <= '0';      
		 
         input <= '1';      
         wait for clk_period*2;
         input <= '0'; -- start bit
         wait for clk_period*2; -- start bit + one data bit = 0
         input <= '1';      
         wait for clk_period*10;
         input <= '0';
         wait for clk_period*2; -- new start bit + one data bit = 0
         input <= '1';      
         wait for clk_period;
         input <= '0';
         wait for clk_period*2;
         input <= '1';      
         wait for clk_period;
         input <= '0';
         wait for clk_period*6;
                 
      end process ;

end tb;
