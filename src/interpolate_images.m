% Interpolate a set of decimated images.
%
%	parameters
% images   : the array of struct containing the images
% L        : upsampling rate
% saveFlag : if saveFlag != 0 the output images are saved to disk
% filename : prefixname for the to be saved images
%
%	return
% image_upsampled : array of struct containing M upsampled images
function images_upsampled = interpolate_images(images,   ...
                                               L,        ... 
                                               saveFlag, ...
                                               filename )
    % init 
	N_images = length(images);
    
    % resize
	for i = 1 : N_images
		% resize {'nearest'|'bilinear'|'bicubic'}
		% let's use the default (nearest) so we have some alias
        
        temp = imresize(images(i).image,L);
		save_image(saveFlag,'us',ycbcr2rgb(temp),filename,i);
		images_upsampled(i).image = temp;
	end
end
