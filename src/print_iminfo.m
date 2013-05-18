% Print image informations obtained from IMFINFO
function print_iminfo(info)
    fprintf('\tImage: ''%s'' (%s)',info.Filename,info.Format);
    fprintf(' %dx%d', info.Width, info.Height);
    fprintf(' (%d bit - %s)\n', info.BitDepth, info.ColorType);
end