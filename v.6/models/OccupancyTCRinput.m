function dx = OccupancyTCRinput(t, x, p, tspan, u1)
    dx = zeros(3, 1);

    u = inputSignal(t, tspan, u1);

    dx(1) = p(1) * x(2) * x(3) - p(2) * x(1) * u;  % C0
    dx(2) = -p(1) * x(2) * x(3) + p(2) * x(1); % P
    dx(3) = -p(1) * x(3) * x(3) + p(2) * x(1); % T
    
end