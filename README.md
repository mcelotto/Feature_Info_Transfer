MATLAB implementation of Feature-specific Information Transfer (FIT) and conditional FIT (cFIT) measures associated to the paper
["An information-theoretic quantification of the content of communication between brain regions"](https://www.biorxiv.org/content/10.1101/2023.06.14.544903v1.full.pdf) from M. Celotto, J. Bím, A. Tlaie, V. De Feo, S.M. Lemke, D. Chicharro, H. Nili, M. Bieler, I.L. Hanganu-Opatz, T.H. Donner, A. Brovelli and S. Panzeri (2023).

FIT quantifies the amount of information transmitted from a sender brain region X to a receiver brain region Y about a specific external feature S. In doing so, FIT goes beyond classic methodologies to study causal communication (such as Transfer Entropy; TE) that quantify the overall activity propagated from the sender to the receiver region, shading light on the content of communication by isolating the feature-specific information flowing from one region to another.

The main scripts to compute FIT, cFIT and Transfer Entropy (TE) from discrete data are compute_FIT.m, compute_cFIT.m, and compute_TE.m, respectively.
These scripts take as an input a set of discrete arrays, representing neural responses at specific time points (i.e. the past/present activity of the sender and receiver regions) and external features of interest sampled across experimental trials.

The example_FIT_TE.m script shows an example application of compute_FIT and compute_TE.

The software has been tested with MATLAB version R2021a, no further dependencies are required. The software is released under the MIT license.
