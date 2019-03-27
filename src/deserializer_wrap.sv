module deserializer_wrap (
  input               clk_i,
  input               srst_i,
  
  input               data_i,
  input               data_val_i,
  
  output logic [0:15] deser_data_o,
  output logic        deser_data_val_o
  
);

logic        srst_i_wrap;

logic        data_i_wrap;
logic        data_val_i_wrap;

logic [0:15] deser_data_o_wrap;
logic        deser_data_val_o_wrap;


deserializer
  deserializer_1    (
  .clk_i            ( clk_i                 ),
  .srst_i           ( srst_i_wrap           ),
  
  .data_i           ( data_i_wrap           ),
  .data_val_i       ( data_val_i_wrap       ),
  
  .deser_data_o     ( deser_data_o_wrap     ),
  .deser_data_val_o ( deser_data_val_o_wrap )
  
);
  
  
always_ff @( posedge clk_i )
  begin
    srst_i_wrap      <= srst_i;
    
    data_i_wrap      <= data_i;
    data_val_i_wrap  <= data_val_i;
    
    deser_data_o     <= deser_data_o_wrap;
    deser_data_val_o <= deser_data_val_o_wrap;
  end



endmodule
