`define bsg_mem_1rw_sync_mask_write_bit_macro(words,bits) \
  if (els_p == words && width_p == bits)                  \
  begin: macro                                            \
    free45_1rw_d``words``_w``bits`` mem                   \
      (.clk       ( clk_i        )                        \
      ,.ce_in     ( v_i          )                        \
      ,.we_in     ( w_i          )                        \
      ,.addr_in   ( addr_i       )                        \
      ,.wd_in     ( data_i       )                        \
      ,.w_mask_in ( write_mask_i )                        \
      ,.rd_out    ( data_o       )                        \
      );                                                  \
  end: macro

module bsg_mem_1rw_sync_mask_write_bit

#(parameter width_p=-1
, parameter els_p=-1
, parameter harden_p = 1
, parameter latch_last_read_p = -1

, localparam addr_width_lp=`BSG_SAFE_CLOG2(els_p)
)

( input                       clk_i
, input                       reset_i
, input                       v_i
, input                       w_i
, input [addr_width_lp-1:0]   addr_i
, input [width_p-1:0]         data_i
, input [width_p-1:0]         w_mask_i
, output logic [width_p-1:0]  data_o
);

  // TODO: ADD ANY NEW RAM CONFIGURATIONS HERE
  `bsg_mem_1rw_sync_mask_write_bit_macro (64, 7) else
  `bsg_mem_1rw_sync_mask_write_bit_macro (64, 15) else
  `bsg_mem_1rw_sync_mask_write_bit_macro (64, 248) else

  begin: notmacro
    bsg_mem_1rw_sync_mask_write_bit_synth
      #(.els_p(els_p)
       ,.width_p(width_p))
    synth
      (.*);
  end: notmacro

endmodule
