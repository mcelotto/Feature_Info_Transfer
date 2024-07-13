=====================================================
Feature-specific Information Transfer (FIT)
=====================================================

MATLAB implementation of Feature-specific Information Transfer (FIT) and conditional FIT (cFIT) measures associated to the paper
Celotto et al. `An information-theoretic quantification of the content of communication between brain regions <https://papers.nips.cc/paper_files/paper/2023/file/ca9eaef07eca2a50fc626cb929617b1c-Paper-Conference.pdf>`_, Advances in Neural Information Processing (NeurIPS) 36, pp.64213-64265, 2023.

.. image:: https://github.com/mcelotto/Feature_Info_Transfer/blob/main/images/FIT_conceptual.png
   :height: 300px
   :alt: Schematic Pipeline Approach
   :align: center

FIT quantifies the amount of information transmitted from a sender brain region X to a receiver brain region Y about a specific external feature S. This approach goes beyond classic methodologies to study causal communication, such as Transfer Entropy (TE), which quantify the overall activity propagated from the sender to the receiver region. By isolating the feature-specific information flowing from one region to another, FIT sheds light on the actual content of the communication.

The \\src directory contains the main scripts to compute FIT, cFIT and Transfer Entropy (TE) from discrete data (called compute_FIT.m, compute_cFIT.m, and compute_TE.m, respectively). These scripts take as an input a set of discrete arrays, representing neural responses at specific time points (i.e. the past/present activity of the sender and receiver regions) and external features of interest sampled across experimental trials.

The \\test directory contains test scripts, showing an example application of the methods on simulated data. Further simulations and real data applications, are available from the full paper supplemental material: `Download full paper material <https://openreview.net/attachment?id=lD8xaUWw24&name=supplementary_material>`_ .  

The software has been tested with MATLAB version R2021a, no further dependencies are required. The software is released under the MIT license.
