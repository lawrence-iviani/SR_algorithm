% Enhance an RGB image by mean of smoothing and sharpening
function out = image_enhance(in,saveFlag,filename)
     %h = fspecial('average');  % square average filter
     %h = fspecial('gaussian'); % low-pass filter
     h = fspecial('disk',2.5); % circular average filter
     out = imfilter(in,h,'replicate');
     h = fspecial('unsharp',0.1);
     out = imfilter(out,h,'replicate');
     save_image(saveFlag,'en',out,filename,-1);
end