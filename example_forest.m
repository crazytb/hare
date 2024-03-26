clear all
clc

MDPtoolbox_path = pwd;
addpath(MDPtoolbox_path)

P(:,:,1) = [0.1 0.9 0;
            0.1 0 0.9;
            0.1 0 0.9];
P(:,:,2) = [1 0 0; 1 0 0; 1 0 0];
R(:,1) = [0; 0; 4];
R(:,2) = [0; 1; 2];

mdp_check(P, R);

discount = 0.95;
