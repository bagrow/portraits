function D = B_Distance( mat1,mat2, varargin )
% matrices mat1 and mat2 have a row and column 
% 'zero' but the matlab indices start at 1


% RESIZE and PAD matrices:
[n_s, m_s] = size(mat1);
[n_l, m_l] = size(mat2);
size_to    = max( [n_s n_l] );

% pad smaller matrix with rows of zeros except column 'zero' is # of nodes:
if n_s < n_l
    mat1 = [mat1; [mat1(1,2)*ones(size_to-n_s,1) zeros(size_to-n_s,m_s-1)] ];
else
    mat2 = [mat2; [mat2(1,2)*ones(size_to-n_l,1) zeros(size_to-n_l,m_l-1)] ];
end

% pad columns with zeros, to align CDFs:
if m_s < m_l
    mat1 = [ mat1 zeros(size_to, m_l-m_s) ];
else
    mat2 = [ mat2 zeros(size_to, m_s-m_l) ];
end


% Get row-wise test statistic:
K = zeros(size_to(1),1);
C1 = Bcdf(mat1);
C2 = Bcdf(mat2);
for i=1:size_to
    K(i) = max( abs( C1(i,:) - C2(i,:) ) );
end
K
length(K)

% shell weights:
b = sum(mat1,2) + sum(mat2,2);
D = b' * K / sum(b);


% optional plot:
if nargin == 3
    plot(K(2:end),'k*-' ); % 2:end because we don't want to plot row 'zero'
    
    %set(gca,'FontSize',36);
    xlabel('Row'); ylabel('K')    
    %set(gca, 'XTick', [1 2 3 4 5])
    set(gca, 'YLim', [0,1])
    set(gca, 'YTick', [ 0.2 0.4 0.6 0.8 1])
    %axis tight
end