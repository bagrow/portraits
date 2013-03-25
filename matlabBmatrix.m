function matlabBmatrix(fileName)

% fileName is of form 'basename.mat.txt'

%path(path,'/Users/jimbagrow/Desktop/Shell_Distributions')

try
    B = load(fileName);
    figure(1)
    clf
    createfigure( B, fileName(1:end-8) );
    close(1)
catch
    disp('Something went wrong')
    disp(lasterr)
end
%exit()