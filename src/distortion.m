% Compute the PSNR and MSE between two images.
% printFlag : if printFlag != 0 the returned values are printed on screen
% label     : label the printed output
function [PSNR MSE] = distortion(original, reconstructed, printFlag, label)
    
    dim1 = size(original);
    dim2 = size(reconstructed);
    
    if (dim1(1) ~= dim2(1))
        original = imresize(original, dim2(1)/dim1(1) );
        dim1 = size(original);
    end
    
    %If there's some approximation...
    row=min(dim1(1),dim2(1));
    col=min(dim1(2),dim2(2));
    error = reconstructed(1:row,1:col) - original(1:row,1:col);
    MSE = sum( sum(error.^2) ) / ( row*col);
    PSNR = 10*log10(255^2/MSE);
    
    if (printFlag)
        fprintf('\t%s\t: PSNR = %3.4f (dB)\t MSE = %3.4f\n',label,PSNR,MSE);
    end
end