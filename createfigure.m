function h = createfigure(mat,varargin)
%CREATEFIGURE(MAT,CUTLEVEL,BASENAME)
%  MAT:      node-shell matrix to be plotted,
%            first row/column will always be omitted.
%  CUTLEVEL: (optional) will plot mat(2:end,2:cutlevel).
%  BASENAME: (optional) base file name that figure will be 
%            saved to.  Figures are saved to .ps, .pdf, 
%            and .png formats.
clf

cutlevel=0;
baseName=0;
if length(varargin)==2
    cutlevel = cell2mat(varargin(1));
    baseName = varargin{2};
elseif length(varargin)==1
    ischar(varargin)
    if ~ischar( varargin{1} )
        cutlevel = cell2mat(varargin(1));
    else
        baseName = varargin{1};
    end
end

if cutlevel==0
    mat = log(trimZeroColumns(mat(2:end,2:end)));    
    %mat = log(mat(2:end,2:end));
else
    mat = log(mat(2:end,2:cutlevel));
end

% padding for NWS sequence:
%[r c] = size(mat);
%mat = [mat zeros(r,471-c);zeros(25-r,471)];

% padding for before percolation:
%[r c] = size(mat);
%mat = [mat zeros(r,79-c);zeros(87-r,79)];

% Create image:
%figure();

%% WHITE BACKGROUND!
cmap = colormap('jet');
cmap(1,:) = [1 1 1];
colormap(cmap)



h = imagesc(mat, [0 max(max(mat))] );

%h = pcolor( mat ); % log scale!
%set(h,'edgecolor','none')
%set(gca,'xscale','log')

box('on');
hold('all');
axis ij
set(gca,'XAxisLocation','top');
%set(gca,'YTick',1:d);
set(gca,'FontSize',24);

%set(gca,'XTickLabel',{'5k','10k','15k','20k','25k'}) % custom labels - movie actor top ten percent
%set(gca,'XTickLabel',{'','10^1','10^2','10^3','10^4'}) % custom labels - movie actor top ten percent
%set(gca,'XTickLabel',[10^0 10^1 10^2 10^3 10^4 ]);
%axes('Position',[.55 .15 .3 .3]);
%imagesc(mat(1:8,1:1500), [0 max(max(mat))])
%set(gca,'XAxisLocation','top');
%set(gca,'FontSize',14);

%set(gca,'XTickLabel',{'50','100','150','200',''}) % custom labels - NSUSair
%set(gca,'XTickLabel',{'500','1000',''}) % custom labels - ave BA


%annotation('arrow',[0.3,0.225],[0.2 0.2], 'LineWidth',3, 'HeadStyle', 'plain')
%annotation('arrow',[0.5,0.425],[0.25 0.25], 'LineWidth',3, 'HeadStyle', 'plain')
%annotation('arrow',[0.695,0.62],[0.3 0.3], 'LineWidth',3, 'HeadStyle', 'plain')
%annotation('arrow',[0.875,0.8],[0.35 0.35], 'LineWidth',3, 'HeadStyle', 'plain')
% save image to files:
if baseName
    colormap(cmap);
    %print('-depsc', [baseName '_noBitc.eps']);
    %print('-dpdf', [baseName '_noBitc.pdf']);
    print('-f1','-dpng', '-r100',[baseName 'c.png']);
    %print('-f1','-dpng', [baseName 'c.png']);
    %unix(['. /Users/bagrowjp/Desktop/Portraits_Of_Complex_Networks/Shell_Distributions/processBmatGraphics.sh ' baseName 'c.png']);
    
    %colormap( flipud(colormap('gray')) ); % reversed gray
    %print('-deps',  [baseName '_noBit.eps']);
    %print('-dpdf', [baseName '_noBit.pdf']);
    %print('-f1','-dpng', '-r100',[baseName '.png']);
    %print('-f1','-dpng', [baseName '.png']);
    %unix(['. /Users/bagrowjp/Desktop/Portraits_Of_Complex_Networks/Shell_Distributions/processBmatGraphics.sh ' baseName '.png']);
    
end