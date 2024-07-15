function cFIT = compute_cFIT( feature, X, Y, hY, hZ)
% This function contains the core routine to compute conditional FIT (FIT) 
% from a sender region X to a receiver region Y, given the activity of a third region Z. 
% The function takes as an input the discrete feature value (F), 
% and the discrete values of X past, Y present, Y past and Z past measured across trials. 
% Then, it builds the five-dimensional probability distribution p(F,X,Y,hY,Z) by
% counting the number of joint occurrences of each possible combination of the
% five variables across trials. Lastly, it uses the PID I_min measure to compute
% the two information atoms appearing in cFIT definition.

% input: 
% feature = discrete feature value (1 x trials)
% X = discrete past activity of the sender X_past (1 x trials)
% Y = discrete present activity of the receiver Y_pres (1 x trials)
% hY = discrete past activity of the receiver Y_past (1 x trials)
% hZ = discrete past activity of the third region Z_past (1 x trials)

% output:
% cFIT = conditioned Feature-specific Information Transfer value (from X to Y about S, given Z)

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

% Build the two five-variables probability distributions needed to compute cFIT
pXYhYhZS = probabilityDist5(X, Y, hY, hZ, feature); % probability distribution for the PID with (Xp, Yp, Zp, Yt) as sources and S as target
pXShYhZY = permute(pXYhYhZS, [1 5 3 4 2]); % probability distribution for the PID with (Xp, Yp, Zp, S) as sources and Yt as target

% Build the two four-variables probability distributions needed to compute FIT
pXYhYS = probabilityDist(X, Y, hY, feature); % probability distribution for the PID with (Xp, Yp, Yt) as sources and S as target
pXShYY = permute(pXYhYS, [1 4 3 2]); % probability distribution for the PID with (Xp, Yp, S) as sources and Yt as target

% Compute FIT
SUI_S = compute_SUI(pXYhYS); % atom 1 in FIT definition
SUI_Y = compute_SUI(pXShYY); % atom 2 in FIT definition
FIT = min([SUI_S, SUI_Y]);
% Compute cFIT
FIT_sharedZ_S = computeFIT_sharedZ(pXYhYhZS); % candidate atom 1 to be subtracted from FIT
FIT_sharedZ_Y = computeFIT_sharedZ(pXShYhZY); % candidate atom 2 to be subtracted from FIT
cFIT = FIT - min([FIT_sharedZ_S, FIT_sharedZ_Y]);

end

