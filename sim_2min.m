function sim_2min(data,xd,yd,fi,angle,filename)


%��10-00�ĺ���߶���ݽ���SAR����
%dc��ʾx���εĺ����糣��
%������Ϊ60������Ƿֱ�Ϊ90,45,0��-45��-90


%��������
dc = 59.61-34.37*1j;

%�ֱ������ã�xd��ydΪ�ֱ��ʣ�disΪÿ������֮��ľ���,xNum��yNumΪÿ��ѡ����еĵ�ĸ���xrcs��yrcsΪѡȡ������
% xd = 1;            
% yd = 1;
% xd = xd / cosd(angle);
% yd = yd / cosd(angle);
dis = 165/2048;
xNum = ceil(xd/dis);
yNum = ceil(yd/dis);

%ɨ�跽��
switch(fi)
    case 90
        s = [0,1,-tand(angle)];
    case 45
        s = [1,1,-sqrt(2)*tand(angle)];
    case 0
        s = [1,0,-tand(angle)];
    case -45
        s = [-1,-1,-sqrt(2)*tand(angle)];
    case -90
        s = [0,-1,-tand(angle)];
% s90 = [0,1,-sqrt(3)]; s = s90;
% s45 = [1,1,-sqrt(6)]; s = s45;
% s0 = [0,1,-sqrt(3)]; s = s0;
% sf45 = [-1,-1,-sqrt(6)]; s = sf45;
% sf90 = [0,-1,-sqrt(3)]; s = sf90;
end

%�������
% data = load('seawave/10-05.shp');
xlen = size(data,1);
ylen = size(data,2);
M = floor(xlen / xNum);
N = floor(ylen / yNum);

A = zeros(xNum*yNum,3);
b = zeros(xNum*yNum,1);
g = zeros(M,N);
g2 = zeros(M,N);

%���thita,
for ii=1:M
    for jj = 1:N
        A1 =  data(((ii-1)*xNum + 1):(ii*xNum),((jj-1)*yNum + 1):(jj*yNum));
        b = -reshape(A1,xNum*yNum,1);
        
        xx = ((ii-1)*xNum + 1):(ii*xNum);
        yy = ((jj-1)*yNum + 1):(jj*yNum);
        
        for jjj = 1:yNum
            for iii = 1:xNum
            A((iii+jjj),:) = [xx(iii)*dis,yy(jjj)*dis,1];
            end
        end
        C = A' * A;
        if det(C) == 0
            D = [0,0,1,0];
        else
            D = inv(C) * A' * b;
            D(3) = 1;
        end
        
        thita=abs(s(1)*D(1)+s(2)*D(2)+s(3)*D(3))/(sqrt((s(1))^2+(s(2))^2+(s(3))^2)*sqrt((D(1))^2+(D(2))^2+(D(3))^2));   %�˴�thitaΪsinֵ
%         rthita = asind(thita);
        % generate 4096 
        
        cthita=cosd(asind(thita));
        g(ii,jj)=(dc-1)*(dc*(1+thita^2)-thita^2)/((dc*cthita+sqrt(dc-thita^2))^2);  %vertical transmission-vertical reception
        rcs(ii,jj)=(abs(g(ii,jj)))^2;
%         g2(ii,jj)=(dc-1)/(cthita+sqrt(dc-thita^2))^2;   %horizontal transmission-horizontal reception
%         rcs2(ii,jj)=(abs(g2(ii,jj)))^2;
    end
end

%����
% rcs = (abs(g)).^2;
sarimage = 1/sqrt(2)*(randn(M,N)+1j*randn(M,N));
image1 = sarimage.*sqrt(rcs);
% image2 = sarimage.*sqrt(rcs2);

%��ӻ���ƽ��
% row = 7;
% col = 7;
% image_filter = zeros(M-row+1, N-col+1);
% for ii = 1:(M-row+1)
    % for jj = 1:(N-col+1)
        % for iii = ii:row+ii-1
            % for jjj = jj : col + jj -1
                % image_filter(ii,jj) = image1(iii,jjj)+image_filter(ii,jj);
            % end
        % end
        % image_filter(ii,jj) = image_filter(ii,jj)/(row*col);
        
    % end
% end
% figure;
% x = -82.5:165/2057:82.5;
% y = -82.5:165/2057:82.5;
% imagesc(x,y,data);
% xlabel('x/m');
% ylabel('y/m');
% colormap(gray)
%

% hrcs = (abs(g2)).^2;
% image2 = sarimage.*sqrt(hrcs);

% figure;
% subplot(3,2,1);
% imagesc(abs(data));
% title('original data');
% 
% subplot(3,2,3)
% imagesc((abs(g)));
% title('vertical transmission-vertical reception');
% 
% subplot(3,2,4);
% imagesc((abs(g2)));
% title('horizontal transmission-horizontal reception');
% 
% subplot(3,2,5);
figure;
x = -82.5:0.0806:82.5;
y = -82.5:0.0806:82.5;
imagesc(x,y,abs(image1));
title('SAR image');
xlabel('x/m');
ylabel('y/m');
colormap(gray);
saveas(gcf,['result/',filename,'/',num2str(xd),'_sar.jpg'])

figure;
x = -82.5:0.0806:82.5;
y = -82.5:0.0806:82.5;
imagesc(x,y,abs(g));
title('$$\sqrt{\sigma}$$','Interpreter','latex');
xlabel('x/m');
ylabel('y/m');
colormap(gray);
saveas(gcf,['result/',filename,'/',num2str(xd),'_sigma.jpg'])


% figure;
% x = -82.5:0.0806:82.5;
% y = -82.5:0.0806:82.5;
% imagesc(x,y,abs(g2));
% title('$$\sqrt{\sigma}$$','Interpreter','latex');
% xlabel('x/m');
% ylabel('y/m');
% colormap(gray);
% saveas(gcf,['result/',filename,'/ghh_sigma.jpg'])

% figure;
% x = -82.5:0.0806:82.5;
% y = -82.5:0.0806:82.5;
% imagesc(x,y,abs(image2));
% title('$$\sqrt{\sigma}$$','Interpreter','latex');
% xlabel('x/m');
% ylabel('y/m');
% colormap(gray);
% saveas(gcf,['result/',filename,'/ghh_sar.jpg'])

% subplot(3,2,6);
% imagesc(abs(image2));colormap(gray);
% title('horizontal image')
% figure;
% x = -82.5:0.0806:82.5;
% y = -82.5:0.0806:82.5;
% imagesc(x,y,abs(g));
% title('$$\sqrt{\sigma}');
% xlabel('x/m');
% ylabel('y/m');
% colormap(gray);

end

