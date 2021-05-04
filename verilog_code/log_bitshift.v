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

module logAddition_bitshift (X,Y,Sx,Sy,Z,Sz);
	//This is the parameter for the bits of the input.	
	`define bit_size 18
	`define bit_shift 9
	//I edited this line
	parameter bits = `bit_size - 1;
	parameter output_bits = `bit_size;
	parameter table_bits = `bit_size;
	//the reason I dont have bits-1 here, is because the last bit is for the sign. So the actual size of the number
	//is still bits, it just happens to have another sign bit added on.
	input signed [bits:0] X,Y;
	reg[bits:0] deltaP,deltaM, difference;
	input Sx,Sy;
	output [output_bits-1:0] Z;
	reg signed	[output_bits-1:0] Z;
	output Sz;
	reg signed Sz;
	wire[table_bits-1 :table_bits-output_bits] diff;
	abSubtraction #(output_bits) diffXY(
	.X(X),
	.Y(Y),
	.diff(diff));	
	always @(*)
	begin
		difference = diff;
		//These are shifted, because at the moment it treats the first bits as decimal bits, so we need to shift it.
		deltaP = 1 << `bit_shift;
		deltaM = 3 << `bit_shift; //1.5 in our system
		difference = difference >> `bit_shift;
		//Shifted to the right, because the difference is inverted to negative when put into the function.
		deltaP = deltaP >> difference;
		deltaM = deltaM >> difference;
		deltaM = (~deltaM + 1'b1);
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
		
		
			
