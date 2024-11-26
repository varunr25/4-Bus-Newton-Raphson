function J = pfJacobian(Ybus, V, phi, PixVec, QixVec)
    % Inputs:
    %   Ybus: N x N complex bus admittance matrix
    %   V: N x 1 vector of voltage magnitudes
    %   phi: N x 1 vector of voltage phase angles (in radians)
    %   PixVec: vector of active power mismatches (P2x, P3x, P4x)
    %   QixVec: vector of reactive power mismatches (Q3x, Q4x)
    
    N = length(V);  % Total number of buses
    Ng = 2;         % Number of generator buses (including slack)
    Npq = N - Ng;   % Number of PQ buses
    
    % Initialize matrices for different parts of the Jacobian
    % J = [H N; M L] where:
    % H: (N-1)x(N-1) for ∂P/∂θ
    % N: (N-1)x(Npq) for ∂P/∂V
    % M: (Npq)x(N-1) for ∂Q/∂θ
    % L: (Npq)x(Npq) for ∂Q/∂V
    
    G = real(Ybus);
    B = imag(Ybus);
    
    % Initialize Jacobian with correct dimensions: 5x5 for this system
    J = zeros(2*N-Ng-1, 2*N-Ng-1);
    
    % Fill H submatrix (∂P/∂θ)
    for i = 2:N
        for j = 2:N
            row = i-1;
            col = j-1;
            if i == j
                % Diagonal elements
                J(row,col) = -QixVec(i-1) - V(i)^2 * B(i,i);
            else
                % Off-diagonal elements
                J(row,col) = V(i)*V(j)*(G(i,j)*sin(phi(i)-phi(j)) - B(i,j)*cos(phi(i)-phi(j)));
            end
        end
    end
    
    % Fill N submatrix (∂P/∂V)
    for i = 2:N
        for j = (Ng+1):N
            row = i-1;
            col = N-1+j-Ng;
            if i == j
                J(row,col) = PixVec(i-1)/V(i) + V(i)*G(i,i);
            else
                J(row,col) = V(i)*(G(i,j)*cos(phi(i)-phi(j)) + B(i,j)*sin(phi(i)-phi(j)));
            end
        end
    end
    
    % Fill M submatrix (∂Q/∂θ)
    for i = (Ng+1):N
        for j = 2:N
            row = N-1+i-Ng;
            col = j-1;
            if i == j
                J(row,col) = PixVec(i-1) - V(i)^2*G(i,i);
            else
                J(row,col) = -V(i)*V(j)*(G(i,j)*cos(phi(i)-phi(j)) + B(i,j)*sin(phi(i)-phi(j)));
            end
        end
    end
    
    % Fill L submatrix (∂Q/∂V)
    for i = (Ng+1):N
        for j = (Ng+1):N
            row = N-1+i-Ng;
            col = N-1+j-Ng;
            if i == j
                J(row,col) = QixVec(i-1)/V(i) - V(i)*B(i,i);
            else
                J(row,col) = V(i)*(G(i,j)*sin(phi(i)-phi(j)) - B(i,j)*cos(phi(i)-phi(j)));
            end
        end
    end
end