`define bsg_mem_1rw_sync_mask_write_byte_macro(words,bits)  \
  if (els_p == words && data_width_p == bits)               \
  begin: macro                                              \
    logic [data_width_p-1:0] w_bmask_li;                    \
    for (i = 0; i < write_mask_width_lp; i++)               \
      assign w_bmask_li[8*i+:8] = {8{write_mask_i[i]}};     \
                                                            \
    free45_1rw_d``words``_w``bits`` mem                     \
      (.clk       ( clk_i       )                           \
      ,.ce_in     ( v_i         )                           \
      ,.we_in     ( w_i         )                           \
      ,.addr_in   ( addr_i      )                           \
      ,.wd_in     ( data_i      )                           \
      ,.w_mask_in ( w_bmask_li  )                           \
      ,.rd_out    ( data_o      )                           \
      );                                                    \
  end: macro

module bsg_mem_1rw_sync_mask_write_byte

#(parameter els_p = -1
, parameter data_width_p = -1
, parameter harden_p = 1
, parameter latch_last_read_p = -1

, localparam addr_width_lp = `BSG_SAFE_CLOG2(els_p)
, localparam write_mask_width_lp = data_width_p>>3
)

( input                           clk_i
, input                           reset_i
, input                           v_i
, input                           w_i
, input [addr_width_lp-1:0]       addr_i
, input [data_width_p-1:0]        data_i
, input [write_mask_width_lp-1:0] write_mask_i
, output logic [data_width_p-1:0] data_o
);

  genvar i;

  // TODO: Add any new ram configurations here!
  `bsg_mem_1rw_sync_mask_write_byte_macro (512, 64) else

  begin: notmacro
    bsg_mem_1rw_sync_mask_write_byte_synth
      #(.els_p(els_p)
       ,.data_width_p(data_width_p))
    synth
      (.*);
  end: notmacro

endmodule
