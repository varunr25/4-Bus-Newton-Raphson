function PixVec = Pifn(Ybus, V, phi, N)
    % Pifn computes the active power injections Pi(x) for each bus.
    % Input:
    %   Ybus - N x N bus admittance matrix
    %   V    - N x 1 vector of voltage magnitudes
    %   phi  - N x 1 vector of voltage phase angles (in radians)
    %   N    - Total number of buses
    % Output:
    %   PixVec - (N-1) x 1 vector of active power injections (P2x, P3x, ...)

    % Initialize Pi vector
    PixVec = zeros(1, N-1);
    
    % Compute Pi(x) for each bus (excluding slack bus, index 1)
    for i = 2:N
        for j = 1:N
            PixVec(i-1) = PixVec(i-1) + ...
                V(i) * V(j) * abs(Ybus(i,j)) * cos(phi(i) - phi(j) - angle(Ybus(i,j)));
        end
    end
end