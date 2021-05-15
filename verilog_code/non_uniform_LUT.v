module abSubtraction(X, Y, diff);
	parameter output_size = 18;
    input signed[output_size-1:0] X,Y;
	output reg[output_size-1:0] diff;
	always @(*)
	begin
		diff = (X >= Y) ? (X-Y) : (Y-X);
		if( diff[output_size-1] == 1 )
		begin
			diff = ~diff + 1;
		end
	end 
endmodule

module logAddition_nonUniform (X,Y,Sx,Sy,Z,Sz);
	//This is the parameter for the bits of the input.
	`ifdef Table
		`include `Table
	`endif
	`define bit_size 18
	`define frac 9
	//I edited this line
	parameter output_size = 18;	
	parameter bits = `bit_size - 1;
	parameter output_bits = `bit_size;
	parameter table_bits = `bit_size;
	parameter fractional_bits = `frac;
	//Ask about how to do this without system verilog.

	
	
	Tables Tables1();
	reg[output_size-1:0] diff;
	input signed [bits:0] X,Y;
	input Sx,Sy;
	output [output_bits-1:0] Z;
	reg signed	[output_bits-1:0] Z;
	output Sz;
	reg signed Sz;
	//I do the same thing here to insure that the difference is the same size.

	
	reg signed[output_bits-1:0] deltaP;
	reg signed[output_bits-1:0] deltaM;
	//This portion will return the correct Dplus and Dminus values with the correct index.
	//For example, with a 20 bit table, and a desired 5 bit output, the table will return bits
	//19-15.	
	always @(*)
	begin
		diff = (X >= Y) ? (X-Y) : (Y-X);
		if (diff[output_size-1] == 1)
		begin
			diff = ~diff + 1;
		end
		if (diff[bits - 1: fractional_bits] >= 2)
		begin
			deltaP = Tables1.DplusInteger[diff[bits-1: fractional_bits]];
	        	deltaM = Tables1.DminusInteger[diff[bits-1: fractional_bits]];
		end
		else
		begin 
			deltaP = Tables1.Dplus[diff];
			deltaM = Tables1.Dminus[diff];
		end
		if (Sx == Sy)
		begin
			if (X > Y)
			begin
				//These portions add all of the bits except for the last as that is determined by the sign bit.
				Z = {deltaP[output_bits-1:0]+X[output_bits-1:0]};
				Sz = Sx;
			end
			else
			begin
				Z = {deltaP[output_bits-1:0]+Y[output_bits-1:0]};
				Sz = Sy;
			end
		end
		else
		begin
			if (X > Y )
			begin
				Z = {deltaM[output_bits-1:0]+X[output_bits-1:0]};
				Sz = Sx;
			end
			else
			begin
				Z = {deltaM[output_bits-1:0]+Y[output_bits-1:0]};
				Sz = Sy;
			end
		end
	end
endmodule
