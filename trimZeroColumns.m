function newMat = trimZeroColumns(mat)
% remove the empty columns of a matrix from the right side
% to the left until a non-empty column arrives

[d,N] = size(mat);

for i = 1:N-1
    if sum(mat(:,end-i)) > 0 
        break;
    end
end
newMat = mat(:,1:end-i);
