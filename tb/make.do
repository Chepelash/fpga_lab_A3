transcript on


vlib work

vlog -sv ../src/deserializer.sv
vlog -sv ./deserializer_tb.sv

vsim -novopt deserializer_tb

add wave /deserializer_tb/clk
add wave /deserializer_tb/rst
add wave /deserializer_tb/data_i
add wave /deserializer_tb/data_val_i
add wave /deserializer_tb/deser_data_o
add wave /deserializer_tb/deser_data_val_o

run -all

