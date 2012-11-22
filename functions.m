#pasar de rgb a Y'CrCb
function ycbcrimage = rgbToycbcr(img)
	R = img(:,:,1);
	G = img(:,:,2);
	B = img(:,:,3);
	ycbcrimage(:,:,1) = 0.299*r + 0.587*g + 0.114*b;		#Y
	ycbcrimage(:,:,2) = 128 - 0.1687*r - 0.3313*g + 0.5*b;	#Cr
	ycbcrimage(:,:,3) = 128 + 0.5*r - 0.4187*g - 0.0813*b;	#Cb
end


#pasar de Y'CrCb a RGB
function rgbimage = ycbcrTorgb(img)
	y = ycbcr(:, :, 1); 
	Cb = ycbcr(:, :, 2); 
	Cr = ycbcr(:, :, 3);
	rgbimage(:, :, 1) = round(y+0*(Cb-128) +1.402*(Cr-128)); 
	rgbimage(:, :, 2) = round(y-0.34414*(Cb-128) -0.71414*(Cr-128)); 
	rgbimage(:, :, 3) = round(y+1.772*(Cb-128) +0*(Cr-128));
end



#transformada discreta del coseno ESTA HAY QUE CAMBIARLA
function G = TDC(g)
	for u = 1:N
		for v = 1:N
		
			acum = 0;
			au = sqrt(choose(u==1, 1, 2)/N);
			av = sqrt(choose(v==1, 1, 2)/N);
			
			pi_N = pi/N;
			
			for x = 1:N
				for y = 1:N
					val = au*av*g(x, y)*cos(pi_N*((x-1)+0.5*(u-1))*cos(pi_N*((y-1)+0.5)*(v-1));
					acum = acum + val;
				end
			end
			G(u, v) = acum;
		end
	end
	
end


#Calcula la anti transformada del coseno, hay que cambiarla
function g = ITDC(G)
	for x = 1:N
		for y = 1:N
			
			acum = 0;
			pi_N = (pi/N);
			
			for u = 1:N
				for v = 1:N
					au = sqrt(choose(u==1, 1, 2)/N);
					if( u == 1 )
						av = 1
					else
						av = 2
					end
					if( v == 1 )
						au = 1
					else
						au = 2
					end
					av = sqrt(av/N)
					au = sqrt(au/N)
					
					val = au*av*G(u, v)*cos(pi_N*((x-1)+0.5)*(u-1))*cos(pi_N*((y-1)+0.5)*(v-1));
					acum = acum + val;
				end
			end
			
			g(x, y) = acum;
		end
	end
	
end



#calcula la cuantización con la luma
function B = quantizationLuma(A)
	Q_y = 	[16 11 10 16 124 140 151 161;
			 12 12 14 19 126 158 160 155;
			 14 13 16 24 140 157 169 156;
			 14 17 22 29 151 187 180 162;
			 18 22 37 56 168 109 103 177;
			 24 35 55 64 181 104 113 192;
			 49 64 78 87 103 121 120 101;
			 72 92 95 98 112 100 103 199];
	
	B = A./Q_y;
end

#calcula la descuantización con la luma
function A = dequatizationLuma(B)
	Q_y = 	[16 11 10 16 124 140 151 161;
			 12 12 14 19 126 158 160 155;
			 14 13 16 24 140 157 169 156;
			 14 17 22 29 151 187 180 162;
			 18 22 37 56 168 109 103 177;
			 24 35 55 64 181 104 113 192;
			 49 64 78 87 103 121 120 101;
			 72 92 95 98 112 100 103 199];
			 
	B = A.*B;
end


#calcula la cuantización con la crominancia
function B = cuantizationCro(A)
	Q_c = [17 18 24 47 99 99 99 99;
				18 21 26 66 99 99 99 99; 
				24 26 56 99 99 99 99 99; 
				47 66 99 99 99 99 99 99; 
				99 99 99 99 99 99 99 99; 
				99 99 99 99 99 99 99 99; 
				99 99 99 99 99 99 99 99; 
				99 99 99 99 99 99 99 99];
	
	B = A./Q_c;
end

#calcula la descuantización con la crominancia
function A = decuatizationCro(B)
	Q_c = [17 18 24 47 99 99 99 99;
			18 21 26 66 99 99 99 99; 
			24 26 56 99 99 99 99 99; 
			47 66 99 99 99 99 99 99; 
			99 99 99 99 99 99 99 99; 
			99 99 99 99 99 99 99 99; 
			99 99 99 99 99 99 99 99; 
			99 99 99 99 99 99 99 99];
	B = A.*Q_c;
end