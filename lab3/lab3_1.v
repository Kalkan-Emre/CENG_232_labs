`timescale 1ns / 1ps

module ab(input A, input B, input clk, output reg Q);

    initial Q = 0;

    // You can implement your code here
	 always@(posedge clk)
	 begin
		if({A,B}==2'b01)
			Q<=1;
		else if({A,B}==2'b10)
			Q<=0;
		else if({A,B}==2'b11)
			Q<=(~Q);
		else 
			Q<=Q;
	 end
    // ...

endmodule

module ic1337(// Inputs
              input I0,
              input I1,
              input I2,
              input clk,
              // Outputs
              output Q0,
              output Q1,
              output Z);

    // You can implement your code here
	 wire G1,G2;
	 wire A1,B1,A2,B2;

	 assign A1 = ~(I0 | ~I1)& (~I2);
	 assign B1 = I2;
	 assign A2 = ~I2;
	 assign B2 = (~(I2|~I1)~^I0);
	 ab ff1(A1,B1,clk,G1);
	 ab ff2(A2,B2,clk,G2);
	 assign Q0 = G1;
	 assign Q1 = G2;
	 assign Z = (G1^G2);
    // ...

endmodule

