% ECE 31032 - F24 Final Project
% Author: Varun Rajesh
% x2V.m - Function to convert voltage unknowns to voltage RMS

function V = x2V(x, Vg, Ng, N)
    % Input:
    % x  - Voltage unknowns [phi2, phi3, ..., V3, V4, ...]
    % Vg - Ng x 1 vector of known voltage magnitudes for slack and generator buses
    % Ng - Scalar, number of generator buses
    % N  - Scalar, total number of buses
    % Output:
    % V  - N x 1 vector of voltage magnitudes for all buses

    % Initialize V with zeros
    V = zeros(1, N);
    
    % Insert known generator voltages
    V(1:Ng) = Vg;
    
    % Extract remaining voltage magnitudes from x
    V(Ng+1:N) = x(N+1:end); % Correct index for voltage magnitudes
end