%g calculate
%ε=εr*ε0
%dielectric εr=59.61-34.37i
dielectric = 59.61-34.37i
theta = 0:0.1:90;
refrection = 1.34;
ref = asind(sind(theta)/refrection);
gvv = zeros(1,901);
ghh = zeros(1,901);
for ii = 1 : 901
    rv = sind(theta(ii) - ref(ii)) / sind(theta(ii) + ref(ii));
    rh = tand(theta(ii) - ref(ii)) / tand(theta(ii) + ref(ii));
    tv = 1 + rv;
    gvv(ii) = rv * (sind(theta(ii)))^2 + 0.5 * tv^2 * (1 - 1/dielectric)...
        * cosd(theta(ii))^2;
    ghh(ii) = -rh * sind(theta(ii))^2;
end
loggvv = abs(gvv).^2;
logghh = abs(ghh).^2;
figure;

plot(theta, loggvv, 'b', theta, logghh, 'r');
title('粗糙海面散射随入射角的变化情况');
axis([0 90 -0.2 1])
text(60,loggvv(601),'|g_v_v|^2');
text(30,logghh(301),'|g_h_h|^2');
xlabel('\theta')
% plot(theta, logghh);