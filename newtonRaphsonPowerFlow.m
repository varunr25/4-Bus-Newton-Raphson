function [x, iter] = newtonRaphsonPowerFlow(Ybus, Pknown, Qknown, Vg, Ng, N, tol, maxIter)
    x = [zeros(N-1, 1); ones(N-Ng, 1)]; % Initial guess [phi2...phiN, V(Ng+1)...VN]
    iter = 0; % Iteration counter
    converged = false;
    
    while (~converged && iter < maxIter)
        iter = iter + 1;
        
        % Step 1: Compute V and phi
        V = x2V(x, Vg, Ng, N);
        phi = x2phi(x, Ng, N);
        
        % Step 2: Compute P_i(x) and Q_i(x)
        PixVec = Pifn(Ybus, V, phi, N);
        QixVec = Qifn(Ybus, V, phi, N);
        
        % Step 3: Compute mismatch vector f(x)
        f = pqmismatch(x, Pknown, Qknown, PixVec, QixVec);
        disp('f');
        disp(f');
        
        % Step 4: Compute Jacobian matrix J(x)
        J = pfJacobian(Ybus, V, phi, PixVec, QixVec);
        disp('J');
        disp(J);
        
        % Step 5: Update x
        x = x - J \ f;
        
        % Check convergence
        if norm(f, inf) < tol
            converged = true;
        end
    end
    
    if ~converged
        error('Newton-Raphson did not converge within the maximum number of iterations.');
    end
end