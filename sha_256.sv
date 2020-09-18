module sha_256(input_data,out_data,clk,reset);
input [255:0]input_data;
output reg [255:0] out_data;
input reset;
input clk;

reg [31:0]a;
reg [31:0]b;
reg [31:0]c;
reg [31:0]d;
reg [31:0]e;
reg [31:0]f;
reg [31:0]g;
reg [31:0]h;
	
reg [31:0]constant_h[7:0];
reg [31:0]constant_k[63:0];
reg [511:0] padded_data;
reg [0:2047] W;

int j;
int i;

reg [31:0] temp1;
reg [31:0] temp2;
reg [31:0] temp3;
reg [31:0] temp4;
reg [31:0] temp5;
reg [31:0] temp6;

reg [31:0] ch;
reg [31:0] maj;
reg [31:0] cs1;
reg [31:0] cs0;
reg [31:0] ss1;
reg [31:0] ss0;
reg [31:0] ct1;
reg [31:0] ct2;

function [31:0]Ch;
input [31:0] x;
input [31:0] y;
input [31:0] z;
begin
 Ch= (x&y)^((~x)&z);
end
endfunction

function [31:0]Maj;
input [31:0] x;
input [31:0] y;
input [31:0] z;
begin
	Maj=(x&y)^(x&z)^(y&z);
end
endfunction

function [31:0]SmallSigma0;
input [31:0]msg;
begin
SmallSigma0 = {msg[6:0],msg[31:7]} ^ {msg[17:0],msg[31:18]} ^ {3'b0,msg[31:3]};
end
endfunction

function [31:0]SmallSigma1;
input [31:0]msg;
begin
SmallSigma1 = {msg[16:0],msg[31:17]} ^ {msg[18:0],msg[31:19]} ^ {10'b0,msg[31:10]} ;
end
endfunction

function [31:0]CapitalSigma0;
input [31:0]msg;
begin
CapitalSigma0 ={msg[1:0],msg[31:2]}^{msg[12:0],msg[31:13]}^{msg[21:0],msg[31:22]};
end
endfunction

function [31:0]CapitalSigma1;
input [31:0]msg;
begin
CapitalSigma1 ={msg[5:0],msg[31:6]}^{msg[10:0],msg[31:11]}^{msg[24:0],msg[31:25]};
end
endfunction

reg [63:0]length=64'd256; //binary rep of 256 is feeded into 64 bit register
reg add_one=1'b1;
reg [190:0]append_zero=191'b0;

function [511:0]message_padding;
input [255:0] msg;
begin
	message_padding={msg,add_one,append_zero,length};
end
endfunction

always @(posedge clk)
	begin
		if(reset==1)
			begin
			padded_data=message_padding(input_data);
			$display("Padded Message is = %h\n\n",padded_data);
						
		constant_h[0] = 32'h6a09e667;
		constant_h[1] = 32'hbb67ae85;
		constant_h[2] = 32'h3c6ef372;
		constant_h[3] = 32'ha54ff53a;
		constant_h[4] = 32'h510e527f;
		constant_h[5] = 32'h9b05688c;
		constant_h[6] = 32'h1f83d9ab;
		constant_h[7] = 32'h5be0cd19;
		#10;
		
		W[0:511]=padded_data[511:0];
		
		a<=constant_h[0];
		b<=constant_h[1];
		c<=constant_h[2];
		d<=constant_h[3];
		e<=constant_h[4];
		f<=constant_h[5];
		g<=constant_h[6];
		h<=constant_h[7];
		
		#10;	
		constant_k[0] <= 32'h428a2f98;
		constant_k[1] <= 32'h71374491;
		constant_k[2] <= 32'hb5c0fbcf;
		constant_k[3] <= 32'he9b5dba5;
		constant_k[4] <= 32'h3956c25b;
		constant_k[5] <= 32'h59f111f1;
		constant_k[6] <= 32'h923f82a4;
		constant_k[7] <= 32'hab1c5ed5;
		constant_k[8] <= 32'hd807aa98;
		constant_k[9] <= 32'h12835b01;
		constant_k[10]<= 32'h243185be;		
		constant_k[11]<= 32'h550c7dc3;
		constant_k[12]<= 32'h72be5d74;
		constant_k[13]<= 32'h80deb1fe;
		constant_k[14]<= 32'h9bdc06a7;
		constant_k[15]<= 32'hc19bf174;
		constant_k[16]<= 32'he49b69c1;
		constant_k[17]<= 32'hefbe4786;
		constant_k[18]<= 32'h0fc19dc6;
		constant_k[19]<= 32'h240ca1cc;
		constant_k[20]<= 32'h2de92c6f;
		constant_k[21]<= 32'h4a7484aa;
	    constant_k[22]<= 32'h5cb0a9dc;
	    constant_k[23]<= 32'h76f988da;
        constant_k[24]<= 32'h983e5152;
        constant_k[25]<= 32'ha831c66d;
        constant_k[26]<= 32'hb00327c8;
        constant_k[27]<= 32'hbf597fc7;
        constant_k[28]<= 32'hc6e00bf3;
        constant_k[29]<= 32'hd5a79147;
        constant_k[30]<= 32'h06ca6351;		  
	    constant_k[31]<= 32'h14292967;
        constant_k[32]<= 32'h27b70a85;
        constant_k[33]<= 32'h2e1b2138;
        constant_k[34]<= 32'h4d2c6dfc;
        constant_k[35]<= 32'h53380d13;
        constant_k[36]<= 32'h650a7354;
        constant_k[37]<= 32'h766a0abb;
        constant_k[38]<= 32'h81c2c92e;
        constant_k[39]<= 32'h92722c85;
        constant_k[40]<= 32'ha2bfe8a1;
	    constant_k[41]<= 32'ha81a664b;
        constant_k[42]<= 32'hc24b8b70;
        constant_k[43]<= 32'hc76c51a3;
        constant_k[44]<= 32'hd192e819;
        constant_k[45]<= 32'hd6990624;
        constant_k[46]<= 32'hf40e3585;
        constant_k[47]<= 32'h106aa070;
        constant_k[48]<= 32'h19a4c116;
        constant_k[49]<= 32'h1e376c08;
        constant_k[50]<= 32'h2748774c;
		constant_k[51]<= 32'h34b0bcb5;
        constant_k[52]<= 32'h391c0cb3;
        constant_k[53]<= 32'h4ed8aa4a;
        constant_k[54]<= 32'h5b9cca4f;
        constant_k[55]<= 32'h682e6ff3;
        constant_k[56]<= 32'h748f82ee;
        constant_k[57]<= 32'h78a5636f;
        constant_k[58]<= 32'h84c87814;
        constant_k[59]<= 32'h8cc70208;
        constant_k[60]<= 32'h90befffa;
        constant_k[61]<= 32'ha4506ceb;
        constant_k[62]<= 32'hbef9a3f7;
        constant_k[63]<= 32'hc67178f2;
		#10;
		
		for(j=16;j<=63;j=j+1)
				begin
					temp1=	W[(j-2)*32+:32];
					temp2= SmallSigma1(temp1);
					
					temp3=	W[(j-7)*32+:32];
					
					temp4=	W[(j-15)*32+:32];
					temp5= SmallSigma0(temp4);
					
					temp6=	W[(j-16)*32+:32];
					
					W[j*32 +: 32]= temp2 + temp3 + temp5 + temp6;
				end
		
	for(i=0;i<=63;i=i+1)
		begin 
			$display("Iteration No. %d : a = %h, b = %h, c = %h, d = %h, e = %h, f = %h, g = %h, h =%h \n",i,a,b,c,d,e,f,g,h);
				ss1=CapitalSigma1(e);
				ch=Ch(e,f,g);
				maj=Maj(a,b,c);
				ss0=CapitalSigma0(a);
				
				ct1= h+ss1+ch+ constant_k[i]+ W[i*32+:32];
				ct2= ss0+maj;
				
				#10;
				
				h=g;
				g=f;
				f=e;
				e=d+ct1;
				d=c;
				c=b;
				b=a;
				a=ct1+ct2;
				
				#10;
		end
		
		#10;
		
		constant_h[0]=a+constant_h[0];
		constant_h[1]=b+constant_h[1];
		constant_h[2]=c+constant_h[2];
		constant_h[3]=d+constant_h[3];
		constant_h[4]=e+constant_h[4];
		constant_h[5]=f+constant_h[5];
		constant_h[6]=g+constant_h[6];
		constant_h[7]=h+constant_h[7];
		
		out_data = {h[0],h[1],h[2],h[3],h[4],h[5],h[6],h[7]};
			
		$display("Iteration No. %d  : a = %h, b = %h, c = %h, d = %h, e = %h, f = %h, g = %h, h =%h\n",i,a,b,c,d,e,f,g,h);
		$display("Hashed Output:    : h[0] = %h, h[1] = %h, h[2] = %h, h[3] = %h, h[4] = %h, h[5] = %h, h[6] = %h, h[7]= %h\n",constant_h[0],constant_h[1],constant_h[2],constant_h[3],constant_h[4],constant_h[5],constant_h[6],constant_h[7]);
		$display("**********DONE**********\n");	
		  end
		
		else
			begin
			out_data<=256'b0;
			$display("Not ready to perform the HASH Function, Please provide reset as 1'b1\n");
			end
end
endmodule








		
		
			
			
			