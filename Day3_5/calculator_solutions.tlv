\m4_TLV_version 1d: tl-x.org
\SV
   // ======================================================
   // Sequential Calculator - day 3
   // Makerchip sandbox url:
	// 	https://www.makerchip.com/sandbox/0L9fPhmQy/0xGh1jV
	// latest change:  calc & counter in stage 1 of pipeline
   // ======================================================
     
   // Macro providing required top-level module definition, random
   // stimulus support, and Verilator config.
   m4_makerchip_module   // (Expanded in Nav-TLV pane.)
\TLV
   $reset = *reset;
   
   // $val1[31:0] = $rand1[3:0];  // randomized val1
   
   |calc
      @1
         // val1 input from prev. cycle out, or reset to 0 
         $val1[31:0] = $reset ? 0 : >>1$out[31:0];
   
         $val2[31:0] = $rand2[3:0];  // rnd val2
         $op[1:0] = $randop[1:0];  // rnd ops
   
         $sum[31:0] = $val1[31:0] + $val2[31:0];  // add
         $diff[31:0] = $val1[31:0] - $val2[31:0];  // sub
         $prod[31:0] = $val1[31:0] * $val2[31:0];  // mult
         $quot[31:0] = $val1[31:0] / $val2[31:0];  // div
   
         // Mux to select operation for ouput result 
         $out[31:0] = $op[1:0] == 2'b00 ? $sum[31:0] :  // sum
                $op[1:0] == 2'b01 ? $diff[31:0] :  // difference
                $op[1:0] == 2'b10 ? $prod[31:0] :  // product (multiply)
                // default 
                $quot[31:0];  // quotient (divide)
         // resetable count by 1
         $cnt[31:0] = $reset ? 0 : (>>1$cnt + 1);  // incr. by 1 counter 

   
   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
\SV
   endmodule
