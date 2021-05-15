module abSubtraction(X, Y, diff);
	parameter output_size = 22;
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

module logAddition (X,Y,Sx,Sy,Z,Sz);
	`ifdef deltaTable
		`include `deltaTable
	`endif
	`define bit_size 22
	parameter bits = `bit_size - 1;
	parameter output_bits = `bit_size;
	parameter table_bits = `bit_size;

	
	
	Tables deltaTables1();
	input signed [bits:0] X,Y;
	input Sx,Sy;
	output [output_bits-1:0] Z;
	reg signed	[output_bits-1:0] Z;
	output Sz;
	reg signed Sz;
	//I do the same thing here to insure that the difference is the same size.
	wire[table_bits-1 :table_bits-output_bits] diff;
	abSubtraction #(output_bits) diffXY(
	.X(X),
	.Y(Y),
	.diff(diff));
	
	wire signed[output_bits-1:0] deltaP;
	wire signed[output_bits-1:0] deltaM;
	//This portion will return the correct Dplus and Dminus values with the correct index.
	//For example, with a 20 bit table, and a desired 5 bit output, the table will return bits
	//19-15.
	assign deltaP = deltaTables1.Dplus[diff][table_bits-1:table_bits-output_bits];
	assign deltaM = deltaTables1.Dminus[diff][table_bits-1:table_bits-output_bits];
	
	always @(*)
	begin
		if(Sx == Sy)
		begin
			if(X > Y)
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
			if(X > Y )
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
		
		
			
