function dx = HCART(t, x, p)
    dx = zeros(3,1);

    dx(1) = p(1) * x(1) - p(2) * x(1) + p(4) * x(3) * x(2) - p(5) * x(3) * x(1);
    dx(2) = p(3) * x(1) - p(4) * x(3) * x(2) - p(6) * x(2);
    dx(3) = p(7) * x(3) * (1 - p(8) * x(3)) - p(9) * x(1) * x(3);

end