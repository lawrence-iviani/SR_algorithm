% Compute a super resolution image from a set of images using a 
% mean filter
%
%   parameters
% images   : array of struct containing the images
% saveFlag : if saveFlag != 0 the output images are saved to disk
% filename : prefixname for the to be saved images
% 
%    return
% out :  the SR image
function out = sr_mean(images,   ...
                       saveFlag, ...
                       filename)
    % init
    N_im = length(images);
    dim = size(images(1).image);
    i_max = dim(1);
    j_max = dim(2);

    out = uint8( zeros(dim) );
    
    % TODO: ridurre la complessità
    for i = 1 : i_max
        for j = 1 : j_max
            temp = zeros(N_im,3);
            for n = 1 : N_im
                temp(n,:) = images(n).image(i,j,:);
            end
            out(i,j,1) = uint8( mean(temp(:,1)) );
            out(i,j,2) = uint8( mean(temp(:,2)) );
            out(i,j,3) = uint8( mean(temp(:,3)) );
        end
    end

    save_image(saveFlag,'sr-mean',ycbcr2rgb(uint8(out)),filename,-1);
end