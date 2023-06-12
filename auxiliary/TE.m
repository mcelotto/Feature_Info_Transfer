function di = TE( pxyhys )
% Computes Transfer Entropy from X to Y, defined as in (Schreiber T. (2000) Phys Rev Letters)
%
% The probability distribution has to have following dimensions in the
% particular order:
% 1: past of X
% 2: present of Y
% 3: past of Y
% 4: stimulus

phy = squeeze(sum(sum(sum(pxyhys,1),2),4));
pxhy = squeeze(sum(sum(pxyhys,2),4));
pyhy = squeeze(sum(sum(pxyhys,1),4));
pxyhy = squeeze(sum(pxyhys,4));

hhy = -dot(nonzeros(phy), log2(nonzeros(phy) + eps));
hxhy = -dot(nonzeros(pxhy), log2(nonzeros(pxhy) + eps));
hyhy = -dot(nonzeros(pyhy), log2(nonzeros(pyhy) + eps));
hxyhy = -dot(nonzeros(pxyhy), log2(nonzeros(pxyhy) + eps));

di = hyhy - hhy - hxyhy + hxhy;

end

