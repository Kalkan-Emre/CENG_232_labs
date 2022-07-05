`timescale 1ns / 1ps 

module is_odd(
    input [4:0] A,
    output reg result
    );

integer i;
integer total;

always@(A)
begin
    total = 0;  //initialize count variable.
    for(i=0;i<5;i=i+1)   //for all the bits.
        total = total + A[i]; //Add the bit to the count.
	if(total%2==1)
		result <= 1;
	else 
		result <= 0;
end

	
endmodule


module lab3_2(
			input[4:0] smartCode,
			input CLK, 
			input lab, //0:Digital, 1:Mera
			input [1:0] mode, //00:exit, 01:enter, 1x: idle 
			output reg [5:0] numOfStuInMera,
			output reg [5:0] numOfStuInDigital,
			output reg restrictionWarnMera,//1:show warning, 0:do not show warning
			output reg isFullMera, //1:full, 0:not full
			output reg isEmptyMera, //1: empty, 0:not empty
			output reg unlockMera,	//1:door is open, 0:closed
			output reg restrictionWarnDigital,//1:show warning, 0:do not show warning
			output reg isFullDigital, //1:full, 0:not full
			output reg isEmptyDigital, //1: empty, 0:not empty
			output reg unlockDigital //1:door is open, 0:closed
	);
	 
	// You may declare your variables below	
	
	initial begin
			numOfStuInMera=0;
			numOfStuInDigital=0;
			restrictionWarnMera=0;
			isFullMera=0;
			isEmptyMera=1'b1;
			unlockMera=0;		
			restrictionWarnDigital=0;
			isFullDigital=0;
			isEmptyDigital=1'b1;
			unlockDigital=0;
	end
	//Modify the lines below to implement your design
	
	// You may declare your variables below
	wire isOdd;
	is_odd check(smartCode,isOdd);

	//Modify the lines below to implement your design
	always @(posedge CLK) 
	begin
		restrictionWarnDigital<=0;
		restrictionWarnMera<=0;
		unlockMera<=0;
		unlockDigital<=0;
		if(lab==0)
		begin
			if(mode==2'b01)
			begin
		
				if(isFullDigital==1)
					unlockDigital<=0;
				else 
				begin
					if(numOfStuInDigital<15)
					begin
						unlockDigital<=1;
						restrictionWarnDigital<=0;
						numOfStuInDigital <= numOfStuInDigital + 1;
						isEmptyDigital<=0;
						if(numOfStuInDigital==29)
							isFullDigital<=1;
						else
							isFullDigital<=0;
					end
					else 
					begin
						if(((lab==0) && (isOdd==0)) || ((lab==1) && (isOdd==1)))
						begin
							unlockDigital<=0;
							restrictionWarnDigital<=1;
						end
						else 
						begin
							unlockDigital<=1;
							restrictionWarnDigital<=0;
							numOfStuInDigital <= numOfStuInDigital + 1;
							isEmptyDigital<=0;
							if(numOfStuInDigital==29)
								isFullDigital<=1;
							else
								isFullDigital<=0;
						end
					end
				end
			end 
			else if(mode==2'b00)
			begin
				unlockDigital<=1;
				restrictionWarnDigital<=0;
				numOfStuInDigital <= numOfStuInDigital - 1;
				isFullDigital<=0;
				if(numOfStuInDigital==1)
					isEmptyDigital<=1;
				else
					isEmptyDigital<=0;
			end
			else 
			begin
				unlockDigital<=0;
				restrictionWarnDigital<=0;
			end
		end
		

		else
		begin
			if(mode==2'b01)
			begin
		
				if(isFullMera==1)
					unlockMera<=0;
				else 
				begin
					if(numOfStuInMera<15)
					begin
						unlockMera<=1;
						restrictionWarnMera<=0;
						numOfStuInMera <= numOfStuInMera + 1;
						isEmptyMera<=0;
						if(numOfStuInMera==29)
							isFullMera<=1;
						else
							isFullMera<=0;
					end
					else 
					begin
						if(((lab==0) && (isOdd==0)) || ((lab==1) && (isOdd==1)))
						begin
							unlockMera<=0;
							restrictionWarnMera<=1;
						end
						else 
						begin
							unlockMera<=1;
							restrictionWarnMera<=0;
							numOfStuInMera <= numOfStuInMera + 1;
							isEmptyMera<=0;
							if(numOfStuInMera==29)
								isFullMera<=1;
							else
								isFullMera<=0;
						end
					end
				end
			end 
			else if(mode==2'b00)
			begin
				unlockMera<=1;
				restrictionWarnMera<=0;
				numOfStuInMera <= numOfStuInMera - 1;
				isFullMera<=0;
				if(numOfStuInMera==1)
					isEmptyMera<=1;
				else
					isEmptyMera<=0;
			end
			else 
			begin
				unlockMera<=0;
				restrictionWarnMera<=0;
			end
		end			

	end
	
	
endmodule


