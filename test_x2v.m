%% Initialization
clear; clc;
x = [0 0 0 1.0 1.0];            % [phi2, phi3, phi4, V3, V4]
Vk = [1; 1.02];                  % Known voltage magnitudes (V1, V2)
Vg = Vk;                        % Known generator voltage magnitudes
Ng = 2;                         % Number of generator buses
N = 4;                          % Total number of buses
V_expected = [1 1.02 1.0 1.0];  % Expected voltage magnitudes
    
%% Code
V = x2V(x, Vg, Ng, N);

%% Comparison
if isequal(V, V_expected)
    disp('x2V test passed!');
    disp(V);
    disp(V_expected);
else
    disp('x2V test failed!');
    disp(V);
    disp(V_expected);
end