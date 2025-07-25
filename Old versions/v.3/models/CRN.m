function dx = CRN(t, x, p, u2)
    dx = zeros(6,1);
        dx(1) = -p(1) * x(1) * x(2) + p(2) * x(4) + p(4) * x(6) + u2;
        dx(2) = -p(1) * x(1) * x(2) + p(2) * x(4) + p(3) * x(4);
        dx(3) = p(3) * x(4) + p(5) * x(6) - p(6) * x(3) * x(5);
        dx(4) = p(1) * x(1) * x(2) - p(2) * x(4) - p(3) * x(4);
        dx(5) = p(4) * x(6) + p(5) * x(6) - p(6) * x(3) * x(5);
        dx(6) = -p(4) * x(6) - p(5) * x(6) + p(6) * x(3) * x(5);
end
