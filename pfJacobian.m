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

% function J = pfJacobian(Ybus, V, phi, PixVec, QixVec)
%     % Inputs:
%     %   Ybus: N x N complex bus admittance matrix
%     %   V: N x 1 vector of voltage magnitudes
%     %   phi: N x 1 vector of voltage phase angles (in radians)
%     %   PixVec: vector of active power mismatches (P2x, P3x, P4x)
%     %   QixVec: vector of reactive power mismatches (Q3x, Q4x)
%     
%     N = length(V);  % Total number of buses
%     Ng = 2;         % Number of generator buses (including slack)
%     Npq = N - Ng;   % Number of PQ buses
%     
%     G = real(Ybus);
%     B = imag(Ybus);
%     
%     % Initialize Jacobian with correct dimensions
%     J = zeros(2*N-Ng-1, 2*N-Ng-1);
% 
%     % Helper function to calculate individual Jacobian elements
%     function val = computeElement(i, j, type)
%         % Computes a single element based on type:
%         % type = 'H' for ∂P/∂θ, 'N' for ∂P/∂V, 'M' for ∂Q/∂θ, 'L' for ∂Q/∂V
%         if i == j
%             switch type
%                 case 'H' % ∂P/∂θ diagonal
%                     val = -QixVec(i-1) - V(i)^2 * B(i, i);
%                 case 'N' % ∂P/∂V diagonal
%                     val = PixVec(i-1)/V(i) + V(i)*G(i, i);
%                 case 'M' % ∂Q/∂θ diagonal
%                     val = PixVec(i-1) - V(i)^2 * G(i, i);
%                 case 'L' % ∂Q/∂V diagonal
%                     val = QixVec(i-1)/V(i) - V(i)*B(i, i);
%             end
%         else
%             switch type
%                 case 'H' % ∂P/∂θ off-diagonal
%                     val = V(i)*V(j)*(G(i, j)*sin(phi(i)-phi(j)) - B(i, j)*cos(phi(i)-phi(j)));
%                 case 'N' % ∂P/∂V off-diagonal
%                     val = V(i)*(G(i, j)*cos(phi(i)-phi(j)) + B(i, j)*sin(phi(i)-phi(j)));
%                 case 'M' % ∂Q/∂θ off-diagonal
%                     val = -V(i)*V(j)*(G(i, j)*cos(phi(i)-phi(j)) + B(i, j)*sin(phi(i)-phi(j)));
%                 case 'L' % ∂Q/∂V off-diagonal
%                     val = V(i)*(G(i, j)*sin(phi(i)-phi(j)) - B(i, j)*cos(phi(i)-phi(j)));
%             end
%         end
%     end
% 
%     % Fill H (∂P/∂θ) and N (∂P/∂V)
%     for i = 2:N
%         for j = 2:N
%             J(i-1, j-1) = computeElement(i, j, 'H'); % H submatrix
%         end
%         for j = (Ng+1):N
%             J(i-1, N-1+j-Ng) = computeElement(i, j, 'N'); % N submatrix
%         end
%     end
% 
%     % Fill M (∂Q/∂θ) and L (∂Q/∂V)
%     for i = (Ng+1):N
%         for j = 2:N
%             J(N-1+i-Ng, j-1) = computeElement(i, j, 'M'); % M submatrix
%         end
%         for j = (Ng+1):N
%             J(N-1+i-Ng, N-1+j-Ng) = computeElement(i, j, 'L'); % L submatrix
%         end
%     end
% end
