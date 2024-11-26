%% Initialization
clear; clc;
x = [0 0 0 1.0 1.0];            % [phi2, phi3, phi4, V3, V4]
Vk = [1 1.02];                  % Known voltage magnitudes (V1, V2)
Vg = Vk;                        % Known generator voltage magnitudes
Ng = 2;                         % Number of generator buses
N = 4;                          % Total number of buses
phi_expected = [0 0 0 0];    % Expected phase angles

%% Code
phi = x2phi(x, Ng, N);

%% Comparison
if isequal(phi, phi_expected)
    disp('x2phi test passed!');
    disp(phi);
    disp(phi_expected);
else
    disp('x2phi test failed!');
    disp(phi);
    disp(phi_expected);
end