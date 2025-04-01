function solution = sensitivityMain1(x0, p, d, tspan, odeFunction, solver, rel_tol, abs_tol)
    % sensitivityMain: Computes sensitivities of a system using complex-step
    %
    % Inputs:
    %   x0          - Initial state vector
    %   p           - Parameter vector
    %   d           - Small complex perturbation
    %   tspan       - Time vector
    %   odeFunction - Function handle for ODE system
    %   solver      - Function handle for solver (@ode45, @ode23s, etc.)
    %   rel_tol     - Relative tolerance
    %   abs_tol     - Absolute tolerance
    %
    % Output:
    %   solution - Cell array: each cell = [original_solution, sensitivities]

    if nargin < 8
        error('Esta función debe llamarse con 8 argumentos. Usa desde un script principal.');
    end

    if ~isvector(x0) || ~isnumeric(x0)
        error('x0 debe ser un vector numérico.');
    end
    if ~isvector(p) || ~isnumeric(p)
        error('p debe ser un vector numérico.');
    end
    if ~isscalar(d) || d <= 0
        error('d debe ser un escalar positivo.');
    end
    if ~isvector(tspan) || tspan(1) >= tspan(end)
        error('tspan debe ser un vector de tiempo válido.');
    end
    if ~isa(odeFunction, 'function_handle')
        error('odeFunction debe ser un handle de función.');
    end

    solver_handle = str2func(func2str(solver));
    options = odeset('RelTol', rel_tol, 'AbsTol', abs_tol, 'Refine', 1);

    [~, x] = solver_handle(@(t,y)odeFunction(t, y, p), tspan, x0, options);

    lp = length(p);
    lx = length(x0);
    ls = size(x, 1);

    solution = cell(1, lx);
    for i = 1:lx
        solution{i} = zeros(ls, lp + 1);
        solution{i}(:, 1) = x(:, i);
    end

    for j = 1:lp
        p(j) = p(j) + d * 1i;
        [~, xPert] = solver_handle(@(t,y)odeFunction(t, y, p), tspan, x0, options);
        p(j) = real(p(j));

        xSens = imag(xPert) ./ d;

        for k = 1:lx
            solution{k}(:, j + 1) = xSens(:, k);
        end
    end
end