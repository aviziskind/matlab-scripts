A = rand(3,1);
B = rand(3,1);

figure(1); clf; 
plot3([0 A(1)], [0 A(2)], [0 A(3)], 'ro-'); 
hold on;
plot3([0 B(1)], [0 B(2)], [0 B(3)], 'bo-', 'linewidth', 2); 

for th = linspace(0,pi, 50)
    R = rotationMatrix3D(th, A);
    Bi = R*B;
    plot3([0 Bi(1)], [0 Bi(2)], [0 Bi(3)], 'go:'); 
end
axis equal
grid on
xlabel('x'); ylabel('y'); zlabel('z')