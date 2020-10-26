\m4_TLV_version 1d: tl-x.org
\SV
   // ======================================================
   // Sequential Calculator - day 3
   // Makerchip sandbox url:
	// 	https://www.makerchip.com/sandbox/0L9fPhmQy/0KOh2y0
	// latest change:  Lab: 2-cyc calc with Validity
   // ======================================================
     
   // Macro providing required top-level module definition, random
   // stimulus support, and Verilator config.
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
            // $op[1:0] = $randop[1:0];  // rnd ops

            // $reset_or_not_valid = $reset || !$valid;
            // Mux to select operation for ouput result 
            $out[31:0] = $reset ? 32'b0 :
                  $op[1:0] == 2'b00 ? $sum[31:0] :  // sum
                  $op[1:0] == 2'b01 ? $diff[31:0] :  // difference
                  $op[1:0] == 2'b10 ? $prod[31:0] :  // product (multiply)
                   // default 
                  $quot[31:0];  // quotient (divide)
   
   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
\SV
   endmodule
