% Generate a set of LR images without removing the alias, 
% since it is needed for the SR.
%
% 	parameters
% image    : the input image
% M        : decimation rate 
% N_images : number of LR output images
% saveFlag : if saveFlag != 0 the output images are saved to disk
% filename : prefixname for the to be saved images
%
%	return
% image_downsampled : a structure of N_images images
% translation_vect  : matrix made up of the translation vectors of each image
function [images_ds translation] = generate_images( image,    ...
                                                    M,        ...
                                                    N_images, ...
                                                    saveFlag, ...
                                                    filename )
    % init      
	dim = size(image);
	width = floor(dim(1)/M);
	height = floor(dim(2)/M);
	
	% choose randomly the translation vectors
	% FIXME: ovviamente questa "tecnica" va raffinata
	first_row = [1  floor( (M-1) .* rand(1,N_images-1) ) + 1];
	first_col = [1  floor( (M-1) .* rand(1,N_images-1) ) + 1];
	translation = [first_row ; first_col];
	
	% filtering without removing alias
	%H = fir1(5,3/M); %  do not use 1/M in order to leave some alias (blur)
	H = fir1(4,1.5/M); % TODO: test to find out the optimal filter
	H = H' * H;
	image_filt = imfilter(image,H);
	
	% downsample
	for i = 1 : N_images
        % generate the image using the randomly choosed initial position
		temp = image_filt(first_row(i)+1:M:M*width, ...
                         first_col(i)+1:M:M*height, :);
		images_ds(i).image = temp;
        save_image(saveFlag,'ds',ycbcr2rgb(temp),filename,i);
	end
end