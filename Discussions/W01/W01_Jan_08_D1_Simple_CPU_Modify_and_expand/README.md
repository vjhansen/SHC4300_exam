# Question [ Canvas Link ](https://usn.instructure.com/courses/20282/discussion_topics/131056) [Pdf Link](W01_Jan_08_D1_Simple_CPU_Modify_and_expand.pdf)

# Answer 
### 1) The attached test bench was created to check the execution of a program comprising only two instructions: LD R,M (where M should contain ”A0” hexadecimal) and HALT. Use Vivado to carry out the simulation, and explain why R loads FFh instead of A0h; make the appropriate changes so that R loads A0h.

The code in [cpu src file](SimpleCPU/cpu.vhd) , the LD R,M instruction is handled in state ldrm_2. It takes 3 cpu cycle to reach ldrm_2 state from all_0 i.e reset stage.   

```vhdl
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
```
In [ testbench file](SimpleCPU/cpu_tb.vhd), after passing the ldr instruction , there is wait for only 2 cycles. When cpu reaches to ldrm_2 in 3rd cpu cycle, databus (db) is loaded as FF. So FF is loaded into register and ouput of cpu is FF.
```vhdl
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
```

***To fix this we have to change in testbench file***

~~wait for clk_period*2;~~ :x:

wait for clk_period*3; :white_check_mark:

### 2) The attached VHDL description for the CPU shows that the execution of LD R,M takes 3 clock cycles. Would it be possible to execute this instruction in less clock cycles? Change the code appropriately if you answer is yes and prove your solution by simulating with your test bench as created for the previous question.


This can be done, if the LD R,M instruction is handled in state all_1. In this case ldrm_2 state becomes redundant. Below will be changes in [cpu src file](SimpleCPU/cpu.vhd).

```vhdl
	type	state_type is (
		  all_0, all_1   -- common to all instructions
		 );
```

```vhdl
case state_reg is
		when all_0 => 					 
			ir_next <= unsigned(db);  
			pc_next <= pc_reg+1;
			state_next <= all_1;
		when all_1 =>			
			if (ir_reg = LDRM) then
			  r_next <= unsigned(db);
			  pc_next <= pc_reg+1;
			  state_next <= all_0; 
			elsif (ir_reg = HALT) then
				state_next <= all_1;
			else 
				state_next <= all_0;
			end if;	
	end case; 
```


### 3) Expand the VHDL description of this simple CPU in order to support two additional instructions: INC R (increment the content of R) and TOG R (toggle the content of R).
The Code changes will be in [cpu src file](SimpleCPU/cpu.vhd).

```vhdl
	constant LDRM: unsigned := "10100000"; -- A0H	
	constant INCR: unsigned := "10110000"; -- B0H
	constant TOGR: unsigned := "11000000"; -- C0H
	constant HALT: unsigned := "11111111"; -- FFH
```

```vhdl
	type	state_type is (
		  all_0, all_1   -- common to all instructions
		 );
```

```vhdl
	case state_reg is
	when all_0 => 					 
		ir_next <= unsigned(db);  
		pc_next <= pc_reg+1;
		state_next <= all_1;
	when all_1 =>			
		if (ir_reg = LDRM) then
			r_next <= unsigned(db);
			pc_next <= pc_reg+1;
			state_next <= all_0; 
		elsif (ir_reg = INCR) then  -- INCR
			r_next <= r_reg + 1;
			state_next <= all_0;
		elsif (ir_reg = TOGR) then  -- TOGR
			if (r_reg = "00000000")
				r_next <= (others => '0');
			else 
				r_next <= (others => '1');
			end if;
			state_next <= all_0;          
		elsif (ir_reg = HALT) then
			state_next <= all_1;
		else 
			state_next <= all_0;
		end if;	
	end case; 
```
