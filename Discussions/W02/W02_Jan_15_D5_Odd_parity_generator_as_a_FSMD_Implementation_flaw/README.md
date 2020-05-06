# Question [Canvas Link](https://usn.instructure.com/courses/20282/discussion_topics/129433)  [Pdf Link](W02_Jan_15_D5_Odd_parity_generator_as_a_FSMD_Implementation_flaw.pdf)

# Answer 
After this section in file i.e. [after line 48](w02d5/par_gen_fsmd-bad.vhd#L48)
```vhdl
   process(state_reg, input, bit_cntr_reg)
   begin
    
      state_next <= state_reg;
      bit_cntr_next <= bit_cntr_reg;
      par_next <= par_reg;

      case state_reg is
		
        when state0 =>
            bit_cntr_next <= "1000";
            if (input = '0') then -- wait for start bit

```
Add below lines :white_check_mark: :white_check_mark: :white_check_mark:
```vhdl
                  output <= '0';
                  par_next <= '0';
```
