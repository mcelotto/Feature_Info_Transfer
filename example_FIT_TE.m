%% Test script to compute FIT and TE between two regions X and Y about a feature S
%
% This is a simplified and faster version of the script used to compute
% Fig.2A in the paper M. Celotto et al. An information-theoretic quantification 
% of the content of communication between brain regions. biorXiv, 2023
% 
% The script simulates two time series signals X and Y. Over time, X
% transmits both stimulus and noise to Y. X is a bidimensional signal, one
% dimension (X_sig) encodes the stimulus, another dimension (X_noise) is
% pure gaussian noise. Y reads out both X_sig and X_noise with a lag
% \delta:
% 
%  Y(t) = w_sig*X_sig(t-\delta) + w_noise*X_noise(t-\delta) + N(0,sigma)
%
% where N(0,sigma) is Gaussian noise.
%
% In the script we compute how TE and FIT depend on the two parameters
% w_sig (stimulus transfer) and w_noise (noise transfer) for a fixed value 
% of the other parameter (0.5).
%
% The script plots the trend of FIT and TE with signal and noise
% transmission at the first time point of info transfer, showing that TE 
% grows with both w_sig and w_noise while FIT increases with w_sig and 
% decreases with w_noise.

clear all; %close all;

rng(1) % For reproducibility

% Simulation parameters
nTrials_per_stim = 500;
simReps = 10; % repetitions of the simulation

w_xy_sig = 0:0.1:1; % range of w_signal parameter 
w_xy_noise = w_xy_sig; % range of w_noise parameter
noise_magn_Y = 2; noise_magn_X = 2; % standard deviation of gaussian noise in X_noise and Y (noise magnitude)

% Global params
tparams.simLen = 60; % simulation time, in units of 10ms
tparams.stimWin = [30 35]; % X stimulus encoding window, in units of 10ms
tparams.delay = 5; % communication delays, in units of 10ms
tparams.delayMax = 10; % maximum computed delay, in units of 10ms

% Define information options
opts = [];
opts.verbose = false;
opts.method = "dr";
opts.bias = 'naive';
opts.btsp = 0;
opts.n_binsX = 3; % X has 2 dimensions and each will be discretized in opts.n_binsX bins --> X will have opts.n_binsX^2 possible outcomes
opts.n_binsY = 3; 
opts.n_binsS = 4; % Number of stimulus values

% Initialize structures
fit_sig = nan(simReps,numel(w_xy_sig)); te_sig = fit_sig; 
fit_noise = nan(simReps,numel(w_xy_noise)); te_noise = fit_noise; 

%% Run simulation

for repIdx = 1:simReps
    disp(['Repetition number ',num2str(repIdx)]);
    for idx = 1:numel(w_xy_sig)
        nTrials = nTrials_per_stim*opts.n_binsS; % Compute number of trials

        % Draw the stimulus value for each trial
        S = randi(opts.n_binsS,1,nTrials);

        % First time point at which Y receives stim info from X
        t = tparams.stimWin(1)+tparams.delay; % first emitting time point (t = 200ms) + delay
        d = tparams.delay;
        
        % simulate neural activity (X noise)
        X_noise = noise_magn_X*randn(tparams.simLen,nTrials); % X noise time series

        % simulate X signal
        X_sig = eps*noise_magn_X*randn(tparams.simLen,nTrials); % X signal time series (infinitesimal noise to avoid issues with binning zeros aftwewards)
        X_sig(tparams.stimWin(1):tparams.stimWin(2),:) = repmat(S,numel(tparams.stimWin(1):tparams.stimWin(2)),1);

        %%% Trends with signal
        
        % Time lagged single-trial inputs from the 2 dimensions of X to Y
        X2Ysig = [eps*noise_magn_X*randn(tparams.delay,nTrials); w_xy_sig(idx)*X_sig(1:end-tparams.delay,:)];
        X2Ynoise = [w_xy_noise(idx)*noise_magn_X*randn(tparams.delay,nTrials); w_xy_noise(idx)*X_noise(1:end-tparams.delay,:)];

        % Compute Y
        Y = X2Ysig + X2Ynoise + noise_magn_Y*randn(tparams.simLen,nTrials); % Y is the sum of X signal and noise dimension plus an internal noise

        % Discretize neural activity
        bX_noise = eqpop_binning(X_noise(t-d,:), opts.n_binsX);
        bX_sig = eqpop_binning(X_sig(t-d,:), opts.n_binsX);

        bYt = eqpop_binning(Y(t,:), opts.n_binsY);
        bYpast = eqpop_binning(Y(t-d,:), opts.n_binsY);

        % Combine the two dimensions of X into a single variable
        bX = (bX_sig - 1) .* opts.n_binsX + bX_noise;

        [te_sig(repIdx,idx)]=...
            compute_TE(S, bX', bYt', bYpast');

        [fit_sig(repIdx,idx)]=...
            compute_FIT(S, bX', bYt', bYpast');
        
        %%% Trends with noise
        
        % Time lagged single-trial inputs from the 2 dimensions of X to Y
        X2Ysig = [eps*noise_magn_X*randn(tparams.delay,nTrials); 0.5*X_sig(1:end-tparams.delay,:)];
        X2Ynoise = [w_xy_noise(idx)*noise_magn_X*randn(tparams.delay,nTrials); w_xy_noise(idx)*X_noise(1:end-tparams.delay,:)];

        % Compute Y
        Y = X2Ysig + X2Ynoise + noise_magn_Y*randn(tparams.simLen,nTrials); % Y is the sum of X signal and noise dimension plus an internal noise

        bX_noise = eqpop_binning(X_noise(t-d,:), opts.n_binsX);
        bX_sig = eqpop_binning(X_sig(t-d,:), opts.n_binsX);

        bYt = eqpop_binning(Y(t,:), opts.n_binsY);
        bYpast = eqpop_binning(Y(t-d,:), opts.n_binsY);

        % Combine the two dimensions of X into a single variable
        bX = (bX_sig - 1) .* opts.n_binsX + bX_noise;

        [te_noise(repIdx,idx)]=...
            compute_TE(S, bX', bYt', bYpast');

        [fit_noise(repIdx,idx)]=...
            compute_FIT(S, bX', bYt', bYpast');
    end
end

%%  Plot trands of TE and FIT with signal and noise transmissions
% Errorbars are standard errors from the mean computed across repetitions
% of the simulation

fig=figure('Position',[1,237,1270,312]);
subplot(2,2,1);
hold on
plot(w_xy_sig,squeeze(mean(fit_sig,1)))
errorbar(w_xy_sig,squeeze(mean(fit_sig,1)),squeeze(std(fit_sig,[],1))/sqrt(simReps))
xlabel('Signal transf.')
ylabel('info [bits]')
title('FIT with signal transfer (fixed noise transfer)')

subplot(2,2,2);
hold on
plot(w_xy_sig,squeeze(mean(fit_noise,1)))
errorbar(w_xy_sig,squeeze(mean(fit_noise,1)),squeeze(std(fit_noise,[],1))/sqrt(simReps))
xlabel('Noise transf.')
ylabel('info [bits]')
title('FIT with noise transfer (fixed sig. transfer)')

subplot(2,2,3);
hold on
plot(w_xy_sig,squeeze(mean(te_sig,1)))
errorbar(w_xy_sig,squeeze(mean(te_sig,1)),squeeze(std(te_sig,[],1))/sqrt(simReps))
xlabel('Signal transf.')
ylabel('info [bits]')
title('TE with signal transfer (fixed noise transfer)')

subplot(2,2,4);
hold on
plot(w_xy_sig,squeeze(mean(te_noise,1)))
errorbar(w_xy_sig,squeeze(mean(te_noise,1)),squeeze(std(te_noise,[],1))/sqrt(simReps))
xlabel('Noise transf.')
ylabel('info [bits]')
title('TE with noise transfer')

sgtitle('FIT, TE dependence on signal and noise transmission')

