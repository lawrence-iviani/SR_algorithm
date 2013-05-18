% SUPER RESOLUTION
% rewritten code
close all
clear all
clc

%% initialization
fprintf(' Superresolution\n\n');
fprintf(' * initialization ... \t\t\t\t');

D = 8;			% downsampling factor for LR
N_images = 15;   % number of LR images
U = 2;			% upsampling factor for SR

filename = 'lena';
%filename = 'paolo';
%filename = 'konqi';
%filename = 'kmenu';

saveFlag = 1;   % flag for saving non-final images
showFlag = 0;   % flag for showing in a detailed way the final images
loadname = sprintf('%s.png',filename);

image = imread(loadname);
image = rgb2ycbcr(image);

fprintf('done\n');
print_iminfo(imfinfo(loadname));

%% generate LR images subset
fprintf(' * generating %d images decimating by %d ... \t',N_images,D);

[ds_images translation] = generate_images(image,D,N_images,saveFlag,filename);

fprintf('done\n');

% extra infos
%print_vectors('translation',translation);

%stop;

%% interpolate to HR 
fprintf(' * interpolating by %d... \t\t\t',U);

us_images = interpolate_images(ds_images,U,saveFlag,filename);

fprintf('done\n');

%% registration
fprintf(' * registering ... \t\t\t\t');
tic
registration = register_images(us_images);
t = toc;
fprintf('done\n');

% extra infos
%print_vectors('registration',registration);
print_time(t,'registration');

%% alignment
fprintf(' * aligning ... \t\t\t\t');
tic
aligned_images = align_images(us_images,registration,saveFlag,filename);
t = toc;
fprintf('done\n');

print_time(t,'alignment');
%stop;

%% super resolution
fprintf(' * super resolution:\n');
saveFlag = 1;

fprintf('\tmean ... \t\t\t');
tic
sr_image_mean = sr_mean(aligned_images,saveFlag,filename);
t = toc;
fprintf('done\n');
print_time(t,' ');

fprintf('\tmedian ... \t\t\t');
tic
sr_image_median = sr_median(aligned_images,saveFlag,filename);
t = toc;
fprintf('done\n');
print_time(t,' ');

fprintf('\tdft ... \t\t\t');
% NOTE: colors changed so the MSE is higher
tic
sr_image_dft = sr_dft(aligned_images,registration,saveFlag,filename);
t = toc;
fprintf('done\n');
print_time(t,' ');

%stop;

%% objective measures

fprintf(' * computing distortion ...\n');

% compute PSNR and MSE on the Y channel
% NOTE: using rgb2gray it's possible using the gray level ...
printFlag = 1;

distortion(image(:,:,1),sr_image_mean(:,:,1),printFlag,'mean');
distortion(image(:,:,1),sr_image_median(:,:,1),printFlag,'median');
temp = rgb2ycbcr(sr_image_dft);
distortion(image(:,:,1),temp(:,:,1),printFlag,'dft');

%% visualization (short)

fprintf(' * showing result ...\t\t');

us = ycbcr2rgb(us_images(1).image);
mean = ycbcr2rgb(sr_image_mean);
median = ycbcr2rgb(sr_image_median);
df = ycbcr2rgb(temp);

figure(10)
subplot(221), imshow(us), title('interpolated');
subplot(222), imshow(mean), title('mean');
subplot(223), imshow(median), title('median');
subplot(224), imshow(df), title('dft');

fprintf('done\n');

%% image enhancement (draft)

fprintf(' * image enhancement ...\t\t');

e_mean = image_enhance(mean,saveFlag,strcat(filename,'_sr-mean'));
e_median = image_enhance(median,saveFlag,strcat(filename,'_sr-median'));
e_df = image_enhance(df,saveFlag,strcat(filename,'_sr-dft'));

fprintf('done\n');

%% objective measures of enhanced images

fprintf(' * computing distortion ...\n');

% compute PSNR and MSE on the Y channel (coherency with previous measures)
printFlag = 1;
temp1 = rgb2ycbcr(e_mean);
temp2 = rgb2ycbcr(e_median);
temp3 = rgb2ycbcr(e_df);
[PSNR_mean MSE_mean] = distortion(image(:,:,1),temp1(:,:,1),printFlag,'mean');
[PSNR_median MSE_median] = distortion(image(:,:,1),temp2(:,:,1),printFlag,'median');
[PSNR_dft MSE_dft] = distortion(image(:,:,1),temp3(:,:,1),printFlag,'dft');

figure(11)
subplot(221), imshow(us), title('interpolated');
subplot(222), imshow(e_mean), title('enh mean');
subplot(223), imshow(e_median), title('enh median');
subplot(224), imshow(e_df), title('enh dft');

%% visualization (detailed)

if (showFlag)
    figure(1), imshow(ycbcr2rgb(image))
    title('Original image')

    figure(2), imshow(ycbcr2rgb(ds_images(1).image))
    title( sprintf('1 of %d LR image (decimated by %d)',N_images,D))

    figure(3), imshow(ycbcr2rgb(us_images(1).image))
    title( sprintf('1 of %d HR image (interpolated by %d)',N_images,U))

    figure(4), imshow(ycbcr2rgb(sr_image_mean))
    title('SR image using mean')
    
    figure(5), imshow(e_mean)
    title('enhanced SR image using mean')
    
    figure(6), imshow(ycbcr2rgb(sr_image_median))
    title('SR image using median')
     
    figure(7), imshow(e_median)
    title('enhanced SR image using mean')
    
    figure(8), imshow(sr_image_dft)
    title(sprintf('SR image with %d dft factor',U))
    
    figure(9), imshow(e_df)
    title(sprintf('enhanced SR image with %d dft factor',U))
    
    
end