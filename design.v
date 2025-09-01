// Dual Port RAM

`ifndef DATA_WIDTH
	`define DATA_WIDTH 8
`endif

`ifndef ADDR_WIDTH
	`define ADDR_WIDTH 3
`endif

`ifndef DEPTH
	`define DEPTH 8
`endif

module dual_port_ram(
  input clka, rsta,
  input [`DATA_WIDTH-1:0] data_ina,
  input [`ADDR_WIDTH-1:0] addra,
  input we_a,
  output reg [`DATA_WIDTH-1:0] data_outa,
  input clkb, rstb,
  input [`DATA_WIDTH-1:0] data_inb,
  input [`ADDR_WIDTH-1:0] addrb,
  input we_b,
  output reg [`DATA_WIDTH-1:0] data_outb
);
  
  reg [`DATA_WIDTH-1:0] ram [0:`DEPTH-1];
  
  always@(posedge clka, posedge rsta) begin
    
    if(rsta) begin
      data_outa <= 0;
    end
    else begin
      if(we_a) begin
        ram[addra] <= data_ina;
      end
      data_outa <= ram[addra];
    end
    
  end
  
  
  always@(posedge clkb, posedge rstb) begin
    if(rstb) begin
      data_outb <= 0;
    end
    else begin
      if(we_b) begin
        ram[addrb] <= data_inb;
      end
      data_outb <= ram[addrb];
    end
  end
  
  integer i;
  
  always@(posedge rsta, posedge rstb) begin
    if(rsta||rstb) begin
      for(i=0; i<`DEPTH; i=i+1) begin // generally in FPGA large RAM clearing is done at every clock not at once
        ram[i] <= 0;
      end
    end
  end
  
endmodule
