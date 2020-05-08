## Question

The block diagram represented below corresponds to a FSMD architecture that implements the functional requirements of a cheating electronic dice.

<img src="/Resources/images/w2d2_FSMD_Jose.png" width="600">

1. Assume that only two operating modes are supported: no cheating, and triple probability for the result specified by inputs “result(2:0)”. Present an ASMD chart that illustrates the behaviour of this FSMD. N.B.: In this case, “mode” is a single input that defines the no-cheating mode when at ‘0’, and the triple probability mode when at ‘1’.

2. Make all appropriate corrections and / or simplifications to the ASMD chart represented below, which is supposed to illustrate the behaviour of the architecture represented above, when supporting four operating modes (“00”: no-cheating; “01”: forbidden result; “10”: predefined result; “11”: triple probability).  

3. Build the corresponding VHDL description and prove that your solution works by showing simulation results in Vivado.

<img src="/Resources/images/w2d2_ASMD_Jose.png" height="700">

---

## Answers

#### 1) Biplav 3x probability Solution Asmd chart
<img src="/Resources/images/w2d2_ASMD_3xprob_Biplav.jpg" height="700"> 

#### 2) Biplav Modes Solution Asmd chart
<img src="/Resources/images/w2d2_ASMD_Biplav.jpg">

#### 3) Biplav VHDL Code Solution

```vhdl
-- Fsm Block 

library	ieee;
use	ieee.std_logic_1164.all;
use	ieee.numeric_std.all;

entity fsm is 
	port ( stop: in std_logic;
			clk: in std_logic;
			result: in std_logic_vector ( 2 downto 0);
			mode: in std_logic_vector ( 1 downto 0);
			trprob_cntr: in std_logic_vector ( 1 downto 0);
			result_cntr: in std_logic_vector ( 2 downto 0);
			reset: in std_logic;
			increment_result_cntr: out std_logic;
			reinitialize_result_cntr: out std_logic;
			decrement_trprob_cntr: out std_logic;
			reinitialize_trprob_cntr: out std_logic );
end fsm;


architecture fsm_arch of fsm is

type	state_type is (
		  state_0, state_1
		 );
state_reg,state_nxt: state_type;
signal result_cntr_sg: unsigned (2 downto 0);
begin

process(reset,clk)
begin
	if (reset = '1' )
		state_reg <= state_0;
		state_nxt <= state_0;
	elsif (clk'event and clk='1')
		state_reg <= state_nxt;
	endif;
end process;

result_cntr_sg <= unsigned(result_cntr) + 1 ;

fsm_control: process (state_reg,result,mode,trprob_cntr,result_cntr,stop)

increment_result_cntr <= '0';
reinitialize_result_cntr <= '0';
decrement_trprob_cntr <= '0';
reinitialize_trprob_cntr <= '0';
state_nxt <= state_reg;

begin

	case state_reg is
		when state_0 =>
			reinitialize_trprob_cntr <= '1';
			reinitialize_result_cntr <= '1';
			state_nxt <= state_1;
		when state_1 =>
			state_nxt <= state_1;
			if ( stop = '1' ) then
				if (mode = "01" and result = std_logic_vector(result_cntr_sg) ) then
					if ( result_cntr_sg = 6 ) then
						reinitialize_result_cntr <= '1';
					else
						increment_result_cntr <= '1';
					end if;
				elsif (mode = "10" and unsigned(result) >= 1 and unsigned(result) <= 6 and 
						result != std_logic_vector(result_cntr_sg) )
					if ( result_cntr_sg = 6 ) then
						reinitialize_result_cntr <= '1';
					else
						increment_result_cntr <= '1';
					end if;
				end if;
			else
				if (mode = "11" and result = std_logic_vector(result_cntr_sg) ) then
					if ( trprob_cntr < "10" )then
						reinitialize_trprob_cntr <= '1';
					else
						decrement_trprob_cntr <= '1'
					end if;
				elsif (mode = "10" and result = std_logic_vector(result_cntr_sg) ) then
					increment_result_cntr <= '0'; -- this line not required as it will be automatically taken care of but the condition is required
				else
					if ( result_cntr_sg = 6 ) then
						reinitialize_result_cntr <= '1';
					else
						increment_result_cntr <= '1';
					end if;
					
				end if;
			end if;
	end case;
end process;


end fsm_arch;
```
