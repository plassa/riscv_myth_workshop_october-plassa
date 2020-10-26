\m4_TLV_version 1d: tl-x.org
\SV
   // ======================================================
   // Sequential Calculator - day 3
   // Makerchip sandbox url:
   // 	https://www.makerchip.com/sandbox/0VOflhyv2/0lOh250
   // latest change:  Lab: 2-cyc calc with Single-Value Memory
   // ======================================================
   
   // This code can be found in: https://github.com/stevehoover/RISC-V_MYTH_Workshop   
   m4_include_lib(['https://raw.githubusercontent.com/stevehoover/RISC-V_MYTH_Workshop/bd1f186fde018ff9e3fd80597b7397a1c862cf15/tlv_lib/calculator_shell_lib.tlv'])

\SV
   m4_makerchip_module   // (Expanded in Nav-TLV pane.)

\TLV
   |calc
      @0
         $reset = *reset;
         
      @1
         $valid_or_reset = $valid || $reset;
         // val1 input from prev. cycle out
         $val1[31:0] = >>2$out;
         $val2[31:0] = $rand2[3:0];  // rnd val2
         // resetable 1-bit cntr
         $valid = $reset ? 1'b0 :
             (>>1$valid + 1'b1);  // incr. by 1 counter 
         
      ?$valid_or_reset
         @1
            $sum[31:0] = $val1 + $val2;  // add
            $diff[31:0] = $val1 - $val2;  // sub
            $prod[31:0] = $val1 * $val2;  // mult
            $quot[31:0] = $val1 / $val2;  // div

         @2
            // operation select
            // $op[2:0] = $randop[2:0];  // rnd ops

            // Mem Mux to reset, store, or hold out[31:0] as $mem[31:0]
            $mem[31:0] = $reset ? 32'b0 :
                  $op[2:0] == 3'b101 ? $val1 :  // store for $op = 5 (same as >>$out)
                  // default
                                       >>2$mem;  // RETAIN prior value
            
            // Mux to select operation for ouput result 
            $out[31:0] = $reset ? 32'b0 :
                  $op[2:0] == 3'b000 ? $sum :  // sum
                  $op[2:0] == 3'b001 ? $diff :  // difference
                  $op[2:0] == 3'b010 ? $prod :  // product (multiply)
                  $op[2:0] == 3'b011 ? $quot :  // quotient (divide)   
                  $op[2:0] == 3'b100 ? >>2$mem :  // mem recall, $op = 4   
                  // default
                                      >>2$out;  // for $op = (5, 6, 7)

         // YOUR CODE HERE
         // ...

      // Macro instantiations for calculator visualization(disabled by default).
      // Uncomment to enable visualisation, and also,
      // NOTE: If visualization is enabled, $op must be defined to the proper width using the expression below.
      //       (Any signals other than $rand1, $rand2 that are not explicitly assigned will result in strange errors.)
      //       You can, however, safely use these specific random signals as described in the videos:
      //  o $rand1[3:0]
      //  o $rand2[3:0]
      //  o $op[x:0]
      
   m4+cal_viz(@3) // Arg: Pipeline stage represented by viz, should be atleast equal to last stage of CALCULATOR logic.

   
   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = *cyc_cnt > 80;
   *failed = 1'b0;
   

\SV
   endmodule
