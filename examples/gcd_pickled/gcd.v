

module gcd
(
  clk_i,
  reset_i,
  en_i,
  v_i,
  a_i,
  b_i,
  ready_o,
  v_o,
  data_o,
  yumi_i
);

  input [31:0] a_i;
  input [31:0] b_i;
  output [31:0] data_o;
  input clk_i;
  input reset_i;
  input en_i;
  input v_i;
  input yumi_i;
  output ready_o;
  output v_o;
  wire ready_o,v_o,N0,N1,N2,N3,N4,N5,a_less_than_b,N6,N7,N8,N9,N10,N11,N12,N13,N14,N15,
  N16,N17,N18,N19,N20,N21,N22,N23,N24,N25,N26,N27,N28,N30,N31,N33,N34,N35,N36,N37,
  N38,N39,N40,N41,N42,N43,N44,N45,N46,N47,N48,N49,N50,N51,N52,N53,N54,N55,N56,N57,
  N58,N59,N60,N61,N62,N63,N64,N65,N66,N67,N68,N69,N70,N71,N72,N73,N74,N75,N76,N77,
  N78,N79;
  wire [31:0] a_minus_b,a_n,b_n;
  wire [1:0] state_n;
  reg [1:0] state_r;
  reg [31:0] data_o,b_r;
  assign a_less_than_b = data_o < b_r;
  assign N28 = state_r[0] | state_r[1];
  assign ready_o = ~N28;
  assign N30 = ~state_r[1];
  assign N31 = state_r[0] | N30;
  assign v_o = ~N31;
  assign N33 = state_r[0] | N30;
  assign N34 = ~N33;
  assign N35 = ~state_r[0];
  assign N36 = N35 | state_r[1];
  assign N37 = ~N36;
  assign N38 = state_r[0] | state_r[1];
  assign N39 = ~N38;
  assign N40 = N35 | state_r[1];
  assign N41 = ~N40;
  assign N42 = b_r[30] | b_r[31];
  assign N43 = b_r[29] | N42;
  assign N44 = b_r[28] | N43;
  assign N45 = b_r[27] | N44;
  assign N46 = b_r[26] | N45;
  assign N47 = b_r[25] | N46;
  assign N48 = b_r[24] | N47;
  assign N49 = b_r[23] | N48;
  assign N50 = b_r[22] | N49;
  assign N51 = b_r[21] | N50;
  assign N52 = b_r[20] | N51;
  assign N53 = b_r[19] | N52;
  assign N54 = b_r[18] | N53;
  assign N55 = b_r[17] | N54;
  assign N56 = b_r[16] | N55;
  assign N57 = b_r[15] | N56;
  assign N58 = b_r[14] | N57;
  assign N59 = b_r[13] | N58;
  assign N60 = b_r[12] | N59;
  assign N61 = b_r[11] | N60;
  assign N62 = b_r[10] | N61;
  assign N63 = b_r[9] | N62;
  assign N64 = b_r[8] | N63;
  assign N65 = b_r[7] | N64;
  assign N66 = b_r[6] | N65;
  assign N67 = b_r[5] | N66;
  assign N68 = b_r[4] | N67;
  assign N69 = b_r[3] | N68;
  assign N70 = b_r[2] | N69;
  assign N71 = b_r[1] | N70;
  assign N72 = b_r[0] | N71;
  assign N73 = state_r[0] | state_r[1];
  assign N74 = ~N73;
  assign N75 = N35 | state_r[1];
  assign N76 = ~N75;
  assign a_minus_b = data_o - b_r;
  assign state_n = (N0)? { 1'b0, 1'b1 } : 
                   (N1)? { 1'b1, 1'b0 } : 
                   (N2)? { 1'b0, 1'b0 } : 1'b0;
  assign N0 = N6;
  assign N1 = N7;
  assign N2 = N8;
  assign { N14, N13 } = (N3)? { 1'b0, 1'b0 } : 
                        (N4)? state_n : 1'b0;
  assign N3 = reset_i;
  assign N4 = N12;
  assign a_n = (N5)? a_i : 
               (N20)? b_r : 
               (N23)? a_minus_b : 1'b0;
  assign N5 = N39;
  assign b_n = (N5)? b_i : 
               (N20)? data_o : 1'b0;
  assign N6 = N74 & v_i;
  assign N7 = N78 & N79;
  assign N78 = N41 & N77;
  assign N77 = ~a_less_than_b;
  assign N79 = ~N72;
  assign N8 = N34 & yumi_i;
  assign N9 = N7 | N6;
  assign N10 = N8 | N9;
  assign N11 = ~N10;
  assign N12 = ~reset_i;
  assign N15 = N76 & a_less_than_b;
  assign N16 = N37 & N72;
  assign N17 = N15 | N39;
  assign N18 = N16 | N17;
  assign N19 = ~N18;
  assign N20 = N15 & N38;
  assign N21 = ~N15;
  assign N22 = N38 & N21;
  assign N23 = N16 & N22;
  assign N24 = N11 & N12;
  assign N25 = ~N24;
  assign N26 = N23 | N19;
  assign N27 = ~N26;

  always @(posedge clk_i) begin
    if(N25) begin
      { state_r[1:0] } <= { N14, N13 };
    end 
    if(N18) begin
      { data_o[31:0] } <= { a_n[31:0] };
    end 
    if(N27) begin
      { b_r[31:0] } <= { b_n[31:0] };
    end 
  end


endmodule

