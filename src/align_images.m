% Align a set of images using a translation vector.
%
%   parameters
% images      : array of struct containing the input images
% translation : translation vector
% saveFlag    : if saveFlag != 0 the output images are saved to disk
% filename    : prefixname for the to be saved images
%
%   return
% out : array of struct containing the aligned images
function out = align_images(images,      ... 
                            translation, ...
                            saveFlag,    ...
                            filename)

    % The first image is the reference, so we don't need to align.
    out(1).image = images(1).image;
    save_image(saveFlag,'align',ycbcr2rgb(out(1).image),filename,1);
   
    dim = size(out(1).image);
    N_images = length(images);
    
    %Trovo quali sono gli indici max e min, sia come righe che come colonne
    I_max = dim(1);
    J_max = dim(2);

    for n = 1 : N_images - 1
        temp = uint8( zeros(dim) );

        % definisco di quant'è traslata la figura e di come scegliere gli indici... 
        i_min = 1;     % Min indice come non fosse traslata
        i_max = I_max; % Max stesso criterio di min

        % Se c'è spostamento (quindi spostamento!=0) devo modificare i_min o
        % i_max. Per non far sforare la figura...
        if translation(1,n) > 0
            i_min = 1 + translation(1,n);
            i_max = I_max;
        elseif translation(1,n) < 0
            i_min = 1;
            i_max = I_max + translation(1,n);
        end
        
        %similmente per j agisco come per i
        j_min = 1;
        j_max = J_max;
        if translation(2,n) > 0
            j_min = 1 + translation(2,n);
            j_max = J_max;
        elseif translation(2,n) < 0
            j_min = 1;
            j_max = J_max + translation(2,n);
        end    

        %sposto in stile C... Forse poco efficiente ma temp_image è già inizializzato...
        % FIXME velocizzare
        for i = i_min : i_max
            for j = j_min : j_max
                %fprintf('i=%d j=%d, real_i=%d real_j=%d\t',i,j,spostamento(1,n) + i,spostamento(2,n) + j);
                temp(i,j,:) = images(n+1).image(i - translation(1,n), j - translation(2,n), :);
            end
        end
        out(n+1).image = temp;
        save_image(saveFlag,'align',ycbcr2rgb(out(n+1).image),filename,n+1);
    end
end
