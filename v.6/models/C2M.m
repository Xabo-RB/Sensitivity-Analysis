function dx = C2M(t, x, p, tspan, u1)

    dx = zeros(2, 1);

    u = inputSignal(t, tspan, u1);

    dx(1) = -(p(1)+p(2))*x(1) + p(3)*x(2) + p(4)*u;  % x1
    dx(2) = p(2)*x(1) - p(3)*x(2); % x2
    
end