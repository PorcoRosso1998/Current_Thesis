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
	//This is the parameter for the bits of the input.	
  reg [11:0] Dplus[15:0];
  reg [11:0] Dminus[15:0];
  reg [11:0] DminusID[15:0];
  reg [11:0] DplusID[15:0];
  initial begin
    DminusID[0] = 12'b00000_1000000;
    DminusID[1] = 12'b00001_0000000;
    DminusID[2] = 12'b00001_1000000;
    DminusID[3] = 12'b00010_0000000;
    DminusID[4] = 12'b00010_1000000;
    DminusID[5] = 12'b00011_0000000;
    DminusID[6] = 12'b00011_1000000;
    DminusID[7] = 12'b00100_0000000;
    DminusID[8] = 12'b00100_1000000;
    DminusID[9] = 12'b00101_0000000;
    DminusID[10] = 12'b00101_1000000;
    DminusID[11] = 12'b00110_0000000;
    DminusID[12] = 12'b00110_1000000;
    DminusID[13] = 12'b00111_0000000;
    DminusID[14] = 12'b00111_1000000;
    DminusID[15] = 12'b01000_0000000;
    DplusID[0] = 12'b00000_1000000;
    DplusID[1] = 12'b00001_0000000;
    DplusID[2] = 12'b00001_1000000;
    DplusID[3] = 12'b00010_0000000;
    DplusID[4] = 12'b00010_1000000;
    DplusID[5] = 12'b00011_0000000;
    DplusID[6] = 12'b00011_1000000;
    DplusID[7] = 12'b00100_0000000;
    DplusID[8] = 12'b00100_1000000;
    DplusID[9] = 12'b00101_0000000;
    DplusID[10] = 12'b00101_1000000;
    DplusID[11] = 12'b00110_0000000;
    DplusID[12] = 12'b00110_1000000;
    DplusID[13] = 12'b00111_0000000;
    DplusID[14] = 12'b00111_1000000;
    DplusID[15] = 12'b01000_0000000;
    Dplus[0]    = 12'b00000_1110000;
    Dplus[1]    = 12'b00000_1010110;
    Dplus[2]    = 12'b00000_1000000;
    Dplus[3]    = 12'b00000_0110000;
    Dplus[4]    = 12'b00000_0100011;
    Dplus[5]    = 12'b00000_0011001;
    Dplus[6]    = 12'b00000_0010010;
    Dplus[7]    = 12'b00000_0001101;
    Dplus[8]    = 12'b00000_0001001;
    Dplus[9]    = 12'b00000_0000110;
    Dplus[10]   = 12'b00000_0000100;
    Dplus[11]   = 12'b00000_0000011;
    Dplus[12]   = 12'b00000_0000010;
    Dplus[13]   = 12'b00000_0000001;
    Dplus[14]   = 12'b00000_0000001;
    Dplus[15]   = 12'b00000_0000000;
	`define bit_size 22
	//I edited this line
	parameter bits = `bit_size - 1;
	parameter output_bits = `bit_size;
	parameter table_bits = `bit_size;
	//Ask about how to do this without system verilog.

	
	
	Tables Tables1();
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
	assign deltaP = Tables1.Dplus[diff][table_bits-1:table_bits-output_bits];
	assign deltaM = Tables1.Dminus[diff][table_bits-1:table_bits-output_bits];
	
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
