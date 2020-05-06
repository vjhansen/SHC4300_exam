-- 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY cpu_tb IS
END cpu_tb;
 
ARCHITECTURE behavior OF cpu_tb IS 
 
    -- Component Declarations for the Units Under Test (UUT)
    COMPONENT cpu
    PORT(
         clk, reset: in std_logic;
         db: in std_logic_vector(7 downto 0);  -- data bus
         ab: out std_logic_vector(7 downto 0); -- address bus
         ob: out std_logic_vector(7 downto 0)  -- output bus
        );
    END COMPONENT;

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal db : std_logic_vector(7 downto 0);

 	--Outputs
   signal ab : std_logic_vector(7 downto 0);
   signal ob : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: cpu PORT MAP (
          clk => clk,
          reset => reset,
          db => db,
          ab => ab,
          ob => ob
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
        reset <= '1';
        db <= "11111111"; -- HALT
        wait for clk_period*2;
		reset <= '0';	
		db <= "10100000"; -- LD R,M
		wait for clk_period*2;
		db <= "11111111"; -- HALT
		wait for clk_period*50;

   end process;

END;
