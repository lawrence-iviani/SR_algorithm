% Save an image using a suffix name
function save_image(flag,suffix,image,filename,index)
    if (flag)
        % save with the right filename
        if (index < 0)
            imwrite(image, sprintf('%s_%s.png',filename,suffix),'png');
        else
            imwrite(image, sprintf('%s_%s-%d.png',filename,suffix,index),'png');
        end
    end
end