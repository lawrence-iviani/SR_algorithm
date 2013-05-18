% Register a set of interpolated images using the spectrum of a portion
% of the images
%
% 	parameters
% images : array of struct containing the images
%
%	return
% registration : registration vectors
function registration = register_images(images)

    % init
    N_images = length(images);	
	im_size = size(images(1).image);
	% low frequencies bins of the spectrum used for the likelihood 
	bin_y = 0.3*im_size(1)/2;
	bin_x = 0.3*im_size(2)/2;
    
    %the boundary in indexes of the used frequency rectangle.
    %In the natural image the low frequency contains higher energy (then
    %higher information) then the low freq are less sensible to the alias
    beginy = floor(im_size(1)/2 - bin_y + 1);
	endy = floor(im_size(1)/2 + bin_y + 1);
	beginx = floor(im_size(2)/2 - bin_x + 1);
	endx = floor(im_size(2)/2 + bin_x + 1);
    
    %initialization some "burocratic" vectors and matrix, they will be used
    %later for performing the minimum square in order to find the relative
    %shifting in respect to the first image.
    
    %vector of frequency indexes for row and columns
    x = ones(endy - beginy + 1,1) * [beginx : endx]; x = x(:);
    y = [beginy : endy]' * ones(1,endx - beginx + 1); y = y(:);
    %The matrix for preforming minimum square
    M_A = [x y ones(length(x),1)];
    
    %a vector for transform
    sz = [im_size(1) im_size(2)];
	% the first image reference spectrum
	ref_fft = fftshift( fft2( double(images(1).image) ));
		
    % turn off some annoying warnings
    warning off
    
    %init the result vector
	registration = zeros(2, N_images - 1);
	for n = 2 : N_images
		% spectrum of the image to be registered
		img_fft = fftshift( fft2( double(images(n).image) ));
				
		spect_ratio = ref_fft(:,:,1)./img_fft(:,:,1); % ratio between spectra
		phase_diff_rad = angle(spect_ratio); % phase difference
      
		% take only interesting frequency (the low freq) and write in 
		% lexicographic order
		v = phase_diff_rad(beginy : endy,beginx : endx); v = v(:);
		
		% compute the least squares solution for the slopes of the phase difference plane
		r = M_A\v; % left matrix division
		r = [r(2) r(1)];
		
		registration(:,n-1) = floor(-r.*sz/2/pi);
	end
end
