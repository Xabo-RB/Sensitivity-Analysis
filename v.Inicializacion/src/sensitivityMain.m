 function solution = sensitivityMain(x0, p, d, tspan, odeFunction)
    % sensitivityMain: Computes the sensitivities of a dynamic system 
    % with respect to its parameters.
    %
    % Input:
    %   x0          - Initial vector of initial conditions (initial state).
    %   p           - Parameter vector of the model.
    %   d           - Small scalar for complex perturbation.
    %   tspan       - Integration interval [t_initial, t_final].
    %   odeFunction - Handle or name of the ODE system function.
    %
    % Output:
    %   solution - Cell array where each element contains:
    %       - First column: Solution of the system without perturbation.
    %       - Subsequent columns: Sensitivities with respect to each parameter.
    

    if ~isvector(x0) || ~isnumeric(x0)
        error('x0 must be a numeric vector.');
    end
    if ~isvector(p) || ~isnumeric(p)
        error('p must be a numeric vector.');
    end
    if ~isscalar(d) || d <= 0
        error('d must be a positive scalar.');
    end
    if ~isvector(tspan) || tspan(1) >= tspan(2)
        error('tspan must be defined differently.');
    end
    if ~isa(odeFunction, 'function_handle')
        error('odeFunction must be a function handle.');
    end


    solver_handle = str2func(func2str(solver));
    options = odeset('RelTol', rel_tol, 'AbsTol', abs_tol, 'Refine', 1);
    [~, x] = solver_handle(@(t,y)odeFunction(t, y, p), tspan, x0, options);

    % neg = @(t,y)odeFunction(t, y, p);
    % options = odeset('RelTol',1e-9,'AbsTol',1e-12, 'Refine', 1); %1e-6,1e-9
    % [t,x] = ode23s(neg, tspan, x0, options);

    
    lp = length(p); ls = size(x, 1); lx = length(x0);
    solution = cell(1, lx);
    for i = 1:lx
        solution{i} = zeros(ls, lp + 1);
    end

    for j = 1:lx
        solution{j}(:, 1) = x(:, j);
    end

    for j = 1:lp

        p(j) = p(j) + d * 1i;
        
        neg = @(t, y) odeFunction(t, y, p);
        [~, x] = solver_handle(neg, tspan, x0, options); 
        
        % neg = @(t,y)odeFunction(t, y, p);
        % [t,x] = ode23s(neg, tspan, x0, options);
        
        p(j) = complex(real(p(j)), 0);
        xSens = imag(x) ./ d;
        
        for k = 1:lx
            solution{k}(:, j + 1) = xSens(:, k);
        end


    end

end  