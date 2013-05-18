% Print informations obtained using TIC, TOC commands
function print_time(t,operation)
    if (operation ~= ' ')
        fprintf('\tElapsed time for %s is %3.6f seconds.\n',operation,t);
    else
        fprintf('\tElapsed time is %3.6f seconds.\n',t);
    end
end