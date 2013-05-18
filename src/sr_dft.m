% Compute a super resolution image from a set of images using a 
% dft-based algorithm
%
%   parameters
% images       : array of struct containing the images
% registration : registration vectors
% saveFlag     : if saveFlag != 0 the output images are saved to disk
% filename     : prefixname for the to be saved images
% 
%    return
% out :  the SR image
function out = sr_dft(images,       ...
                      registration, ...
                      saveFlag,     ...
                      filename)
    
    % init
    N_im = length(images);
    dim = size(images(1).image);
    x_max = dim(1);
    y_max = dim(2);
    
    % compute the reference spectrum
    img_dft = fftshift(fft2( double(images(1).image) ));
	%images.dft = img_dft;
	
	for n = 2 : N_im
        temp = fftshift(fft2( double(ycbcr2rgb(images(n).image)) ));
        for x = 1 : x_max
			for y = 1 : y_max
				value = [x y] * [registration(1,n-1) registration(2,n-1)]';
				temp(x,y,:) = temp(x,y,:) * exp(-j*2*pi*value);
			end
        end
		img_dft = img_dft + temp;
	end
		
	% normalize and inverse transform 
	out = uint8( real( ifft2(ifftshift( img_dft/N_im )) ) );
    
    save_image(saveFlag,'sr-dft',uint8(out),filename,-1);
end
