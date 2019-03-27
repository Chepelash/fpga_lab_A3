module deserializer #(
  parameter WIDTH = 16
)(
  input                    clk_i,
  input                    srst_i,
  
  input                    data_i,
  input                    data_val_i,
  
  output logic [0:WIDTH-1] deser_data_o,
  output logic             deser_data_val_o
);

logic [$clog2(WIDTH)-1:0] cntr;


always_ff @( posedge clk_i )
  begin
    if( srst_i )
      begin
        cntr             <= '0;
        deser_data_val_o <= '0;
      end
    else if( data_val_i )
      begin
        cntr <= cntr + 1'b1;
        if( cntr == ( WIDTH - 1 ) )
          deser_data_val_o <= 1'b1;
        else
          deser_data_val_o <= 1'b0;
      end
    else
      begin
        deser_data_val_o <= 1'b0;
      end          

  end  


always_ff @( posedge clk_i )
  begin
    if( srst_i )      
        deser_data_o <= '0;  
    else if( data_val_i )       
        deser_data_o[cntr] <= data_i; 
  end


endmodule
