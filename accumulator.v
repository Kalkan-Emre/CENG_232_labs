`timescale 1ns / 1ps

module lab4_2(// INPUTS
              input wire      mode,
              input wire[2:0] opCode,
              input wire[3:0] value,
              input clk,
              input reset,
              // OUTPUTS
              output reg[9:0] result,
              output reg cacheFull,
              output reg invalidOp,
              output reg overflow);

    //================//
    // INITIAL BLOCK  //
    //================//
    //Modify the lines below to implement your design
	 reg [2:0] opCode_q [31:0];
	 reg [3:0] value_q [31:0];
	 reg [9:0] p0;
	 reg [9:0] p1;
	 reg [9:0] temp;
	 reg [2:0] curr_opcode;
	 reg [3:0] curr_value;
	 integer load_index; //Instruction load index
	 integer calc_index; //Instruction load index
	 integer capacity;
	 integer i;
	 integer temp_int;
	 integer off_set;
    initial begin
			off_set = 0;
			capacity = 32;
			load_index = -1;
			calc_index = 0;
			overflow=0;
			cacheFull=0;
			invalidOp=0;
			p0 = 0;
			p1 = 0;
			for(i=0;i<10;i=i+1)
			begin
				opCode_q[i]=0;
				value_q[i]=0;
			end
    end

    //================//
    //      LOGIC     //
    //================//
    //Modify the lines below to implement your design
    always @(posedge clk or posedge reset)
    begin
			//Reset//
			if(reset==1)
			begin
				for(i=0;i<10;i=i+1)
				begin
					opCode_q[i]=0;
					value_q[i]=0;
				end
				off_set=0;
				load_index = -1;
				calc_index = 0;
				p0 = 0;
				p1 = 0;
				cacheFull = 0;
				invalidOp = 0;
				overflow = 0;
				result=0;
			end
			//Load Mode//
			else if(mode==0)
			begin
			
				if(load_index==capacity-1)
				begin
					cacheFull = 1;
				end
				
				else
				begin
				
					if((opCode==3'b011) ^ (opCode==3'b111))
					begin
						invalidOp = 1;
					end
					
					else
					begin
						invalidOp = 0;
						load_index = load_index + 1;
						opCode_q[load_index] = opCode;
						value_q[load_index] = value;
						calc_index = off_set;
					end
					
				end
			end
			
			//Calculate Mode//
			else if(mode==1)
			begin
				invalidOp=0;
				if(load_index==-1)
				begin
					p1=p0;
					p0=0;
					result = 0;
				end 
				
				else
				begin
				
					curr_value = value_q[calc_index];
					curr_opcode = opCode_q[calc_index];
				
					if(curr_opcode==3'b000)
					begin
						p1=p0;
						if((p0+curr_value)>1023)
						begin
							p0=p0+curr_value-1024;
							overflow = 1;
						end
						
						else
						begin
							p0=p0+curr_value;
							overflow = 0;
						end
						result=p0;
					end
				
					else if(curr_opcode==3'b001)
					begin
						temp=p1;
						p1=p0;
						if((p0+temp+curr_value)>1023)
						begin
							p0=p0+temp+curr_value-1024;
							overflow = 1;
						end
						
						else
						begin
							p0=p0+temp+curr_value;
							overflow = 0;
						end
						result=p0;
					end
				
					else if(curr_opcode==3'b010)
					begin
						temp=p1;
						p1=p0;
						if((p0*temp + curr_value)>1023)
						begin
							p0=p0*temp + curr_value-1024;
							overflow = 1;
						end
						
						else
						begin
							p0=p0*temp + curr_value;
							overflow = 0;
						end
						result=p0;
					end
				
				
					else if(curr_opcode==3'b100)
					begin
						overflow = 0;
						p1 = p0;
						temp_int=0;
						for(i=0;i<10;i=i+1)
						begin
							if(p0[i]==1)
							begin
								temp_int=temp_int+1;
							end
						end
						p0=temp_int;
						result=p0;
					end
				
					else if(curr_opcode==3'b101)
					begin
						overflow = 0;
						p1=p0;
						for(i=0;i<10;i=i+1)
						begin
							temp[i]=p0[9-i];
						end
						p0=temp;
						result=p0;
					end
				
					else if(curr_opcode==3'b110)
					begin
						off_set=curr_value;
					end
					
					if(calc_index == load_index)
					begin
						calc_index = off_set;
					end
						
					else
					begin
						calc_index = calc_index + 1;
					end
				end
			end
    end
endmodule