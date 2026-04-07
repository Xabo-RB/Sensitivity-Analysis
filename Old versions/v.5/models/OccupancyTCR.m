function dx = OccupancyTCR(t, x, p)
    dx = zeros(3, 1);
    dx(1) = p(1) * x(2) * x(3) - p(2) * x(1);  % C0
    dx(2) = -p(1) * x(2) * x(3) + p(2) * x(1); % P
    dx(3) = -p(1) * x(3) * x(3) + p(2) * x(1); % T
end