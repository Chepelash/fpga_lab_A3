module deserializer_tb;

parameter int CLK_T = 1000;
parameter int WIDTH = 16;

logic             clk;
logic             rst;

logic             data_i;
logic             data_val_i;
logic [WIDTH-1:0] deser_data_o;
logic             deser_data_val_o;


bit   [WIDTH-1:0] input_values[$];
bit   [WIDTH-1:0] output_value;
int               cntr;


task automatic clk_gen;

  forever
    begin
      # ( CLK_T / 2 );
      clk <= ~clk;
    end
  
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


task automatic init_queue_values;

  for( int i = 0; i < ( 2**WIDTH ); i++ )
    input_values.push_back(i);

endtask


deserializer #(
  .WIDTH            ( WIDTH            )
) deserializer_1    (
  .clk_i            ( clk              ),
  .srst_i           ( rst              ),
  
  .data_i           ( data_i           ),
  .data_val_i       ( data_val_i       ),
  
  .deser_data_o     ( deser_data_o     ),
  .deser_data_val_o ( deser_data_val_o )
);


  
initial
  begin  
    
    init_queue_values();
    
    clk <= 0;
    rst <= 0;
    
    fork
      clk_gen();
    join_none
    
    $display("Starting!\n");
    
    apply_rst();
    
    for( int i = 0; i < ( 2**WIDTH ); i++ )
      begin
        for( int cntr = ( WIDTH - 1 ); cntr >= 0; cntr-- )
          begin
            data_i     <= input_values[i][cntr];
            data_val_i <= 1'b1;
            @( posedge clk );            
          end

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
