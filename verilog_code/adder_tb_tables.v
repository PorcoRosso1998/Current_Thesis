`timescale 1 ns / 100 ps

module adder_tb_tables;
	`define bit_size 22
	`define bits 22
	`define seed 22
	reg signed[`bits-1:0] X,Y,x,y;
	reg signed Sx,sx,Sy,sy;
	wire signed [`bits - 1:0] Z;
	wire signed Sz;
	integer seed;
	integer test_num;
	integer file_results; 
	integer test_inputs;
	integer     fd;
	integer status;
	integer count;

	logAddition test(X,Y,Sx,Sy,Z,Sz);
					 
	 task TEST_ADDER;
	 input [`bits:0] x;
	 input sx;
	 input [`bits:0] y;
	 input sy; 
	
	begin
		X = x;
		Sx = sx;
		Y = y;
		Sy = sy;
		$display("Values have been assigned");
		
	end
	
	endtask



    initial begin
	    file_results = $fopen("logAdderResults.txt", "a");
	    count = 0;
	    fd = $fopen("input11_11.txt", "r");
	    if (!fd) $error("could not read file");
	    while (count < 10000) begin
			count = count + 1;
		status = $fscanf(fd,"%b%b%b%b",x,sx,y,sy);
			$display("Hello");
			$display("X = %b, Sx = %b, Y = %b, Sy = %b",x,sx,y,sy);
			TEST_ADDER(x,sx,y,sy);
			#7
			$display("Success! Z = %b, Sz = %b",Z,Sz);
			$fdisplay (file_results,"%f", $itor(Z)*(2**-(`bits - 11.0)));
			$fdisplay (file_results,"%b",Sz);
	   end
end
endmodule
