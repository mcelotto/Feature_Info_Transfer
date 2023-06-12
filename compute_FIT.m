function FIT = compute_FIT(feature, X, Y, hY)
% This function computes the Feature-specific Information Transfer (FIT)

% input: 
% feature = discrete feature value (1 x trials)
% X = discrete past activity of the sender X_past (1 x trials)
% Y = discrete present activity of the receiver Y_pres (1 x trials)
% hY = discrete past activity of the receiver Y_past (1 x trials)

% output:
% FIT = Feature-specific Information Transfer value (from X to Y about S)

% License:
% MIT License
% 
% Copyright (c) 2023 M. Celotto, J. Bím, A. Tlaie, V. De Feo, S. Lemke, D. Chicharro, 
% H. Nili, M. Bieler, I.L. Hanganu-Opatz, T.H. Donner, A. Brovelli, and S. Panzeri
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.

% Build the two four-variables probability distributions needed to compute FIT
pXYhYS = probabilityDist(X, Y, hY, feature); % probability distribution for the PID with (Xp, Yp, Yt) as sources and S as target
pXShYY = probabilityDist(X, feature, hY, Y); % probability distribution for the PID with (Xp, Yp, S) as sources and Yt as target

% Compute the two FIT atoms
SUI_S = compute_SUI(pXYhYS);
SUI_Y = compute_SUI(pXShYY);

FIT = min(SUI_S,SUI_Y);

end



