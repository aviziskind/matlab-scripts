function symmetricaxes
    v = axis;
    XYmax = max(abs(v));
    axis([-XYmax, XYmax, -XYmax, XYmax]);
end