function C = Bcdf(B)
% compute the matrix of cumulative distributions of B
% C_{l,k} = \sum_{k'\leq k} B_{\l,k'} / \sum_{k'}B_{l,k'}

[n,m] = size(B);
C = zeros(n,m);

row_sum = sum(B,2);
for i=1:n
    if row_sum(i) > 0
        C(i,:) = cumsum( B(i,:) ) ./ row_sum(i);
    else % avoid this by including column 'zero' in B:
        C(i,:) = ones(1,m); % ones or zeros or 0.5's?
    end
end


