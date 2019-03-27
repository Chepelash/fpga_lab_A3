module deserializer_tb;

parameter int CLK_T = 1000;

logic        clk;
logic        rst;

logic        data_i;
logic        data_val_i;
logic [15:0] deser_data_o;
logic        deser_data_val_o;


bit [15:0] input_values[$];
bit [15:0] output_value;
int cntr;

task automatic clk_gen;

  # ( CLK_T / 2 );
  clk <= ~clk;
  
endtask


task automatic apply_rst;
  
  rst <= 1'b1;
  @( posedge clk );
  rst <= 1'b0;
  @( posedge clk );

endtask


task automatic apply_valid_input;

  data_val_i <= 1'b1;
  @( posedge clk );
  data_val_i <= 1'b0;
  @( posedge clk );

endtask

task automatic wait_for_data;
  repeat(16)
    begin
      @( posedge clk );
    end
  
endtask


deserializer
  deserializer_1    (
  .clk_i            ( clk              ),
  .srst_i           ( rst              ),
  
  .data_i           ( data_i           ),
  .data_val_i       ( data_val_i       ),
  
  .deser_data_o     ( deser_data_o     ),
  .deser_data_val_o ( deser_data_val_o )
);



always
  begin
    clk_gen();    
  end

  
initial
  begin
  
    input_values = {'b1011_0111_1110_0100, 'b0010_0001_0110_0111, 'b1110_1001_1101_0011};
    
    clk <= 0;
    rst <= 0;
    
    $display("Starting!\n");
    
    apply_rst();
    
    for( int i = 0; i < 3; i++ )
      begin
        for( int cntr = 15; cntr >= 0; cntr-- )
          begin
            data_i     <= input_values[i][cntr];
            data_val_i <= 1'b1;
            @( posedge clk );            
          end
//        wait_for_data();
	      @( posedge deser_data_val_o );
        if( deser_data_o == input_values[i] )
          begin
            $display("OK! Input val = %16b; output val = %16b;", 
                      input_values[i], deser_data_o);
          end
        else
          begin
            $display("Fail! Input val = %16b; output val = %16b;", 
                      input_values[i], deser_data_o);
            $stop();
          end
      end
    $display("Everything is fine!");
    $stop();
    
  end






endmodule
