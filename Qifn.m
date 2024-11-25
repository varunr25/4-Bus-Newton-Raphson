function QixVec = Qifn(Ybus, V, phi, N)
    % Qifn computes the reactive power injections Qi(x) for each bus.
    % Input:
    %   Ybus - N x N bus admittance matrix
    %   V    - N x 1 vector of voltage magnitudes
    %   phi  - N x 1 vector of voltage phase angles (in radians)
    %   N    - Total number of buses
    % Output:
    %   QixVec - (N-1) x 1 vector of reactive power injections (Q2x, Q3x, ...)

    % Initialize Qi vector
    QixVec = zeros(1, N-1);
    
    % Compute Qi(x) for each bus (excluding slack bus, index 1)
    for i = 2:N
        for j = 1:N
            QixVec(i-1) = QixVec(i-1) + ...
                V(i) * V(j) * abs(Ybus(i,j)) * sin(phi(i) - phi(j) - angle(Ybus(i,j)));
        end
    end
end