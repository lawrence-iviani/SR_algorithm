% Print the values contained in data
function print_vectors(description, data)
    fprintf('\t%s vectors:\n',description);
    N = size(data); N = N(2);
    for n = 1 : N
        fprintf('\t\t%d. [%d\t %d]\n',n, data(1,n), data(2,n));
    end
end