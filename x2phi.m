% ECE 31032 - F24 Final Project
% Author: Varun Rajesh
% x2phi.m - Function to convert voltage unknowns to voltage phase angles

function phi = x2phi(x, Ng, N)
    % Input:
    % x    - Voltage unknowns [phi2, phi3, ..., V3, V4, ...]
    % Ng   - Scalar, number of generator buses
    % N    - Scalar, total number of buses
    % Output:
    % phi  - N x 1 vector of voltage phase angles for all buses

    % Initialize phase angles vector
    phi = zeros(1, N);
    
    % Fill in the unknown phase angles for the remaining buses
    phi(2:Ng) = x(1:Ng-1); % For generator buses
    phi(Ng+1:end) = x(Ng:(N-1)); % For load buses
end