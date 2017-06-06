clc ;
clear all;
close all;
framedir =dir('*.jpg');
row = size(framedir);
rows = row(1) ;
step_angle = .4645;
%step_angle = 1.389;
% step_angle = 0.805 ;
% step_angle = 0.03222 ; % degrees
step_angles =degtorad(step_angle);
init = [0,0,0];
save('test.asc','init','-ASCII');
j=1;
limit1=35;
limit2=39;


for step = 1:rows   % Read image
RGB = imread(framedir(step).name);   % Rotate it to search for the maximum along the columns
% RGB = rgb2gray(RGB);

RGB = imrotate(RGB,90) ;
%  imshow(RGB)
% Transform the integers in single precision float values
rgb = single(RGB);
% I determine size image
a = size(rgb);
steps =1; % 0.25;
%  produce 10x vector elements than there are rgb columns
ends = a(1)-steps;
short = 0:1:ends;
columnindex = 1:1:a(2);
time = 0:(steps):(ends);
ts = size(time);
cut = 10; % cutoff value of the black10
dist = 1:a(2);
%{
if(step>180)
    j=2;
end;
%}
%{
if(step>270)
j=3;
end
%}
% loop to create the interpolation on the column
% And find the position of maximum 
% tst1 =single(rgb(:,:,3));
% imshow(tst1)

for i=1:a(2)
column =single(rgb(:,i,3));
% create a tenth of a pixel interpolation
yos = interp1(short,column,time,'spline');
%a=[1:100];
%{
[r1,c1]=size(yos);
max1=limit1;
  r2=1;
  c2=1;          
for loop1=1:c1
    if((yos(r1,loop1)>limit1)&& (yos(r1,loop1)<limit2))
        if(max1<yos(r1,loop1)) 
            max1=yos(r1,loop1);
            r2=r1;
            c2=loop1;
        end
    end
end
c=max1;
pos=c2;
%}
[c,pos] =max(yos);

% I rotate the position of the zero
poss =-pos+ts(2);
% If the intensity of the maximum is lower than the cut -> in vett dist
% NaN or put the position

if(c<cut)
    dist(i)=0;
else
    dist(i)=poss;
end;
end;
%{
 parameter=.01;
smooth=csaps(columnindex,dist,parameter,columnindex);
for i=1:a(2)
    if(smooth(i)<0)
        smooth(i)=0;
    else if(smooth(i)>slun(2))
            smooth(i)=slun(2);
        end;
    end;
    if(i>2)
if(abs(smooth(i)-smooth(i-1))>5)
smooth(i-1) = 0;
end;
end;
if dist(i)>0
else
smooth(i) =0;
end;
end; 
%}

%centering = 0.5/steps ;
% l = 100 ;
l = 150 ;% mm
% h = 250;
h = 250;% mm
%shift =45;
%focal = 50;% mm
phik = atand(h/l);
%phiu =90-phik;
%thetau=0;
%sensor_width = 15.6 ; % sensor width , after the possible rotation
%sensor_height= 23.5 ; % sensor height , after the possible rotation
re = ts(2)/2; % position of the half sensor height 
ce = a(2)/2; % position half sensor width  
%dpm_hor = sensor_width /a(2); % width pixels hor
%dpm_vert = sensor_height/slun(2); % width pixels vert
%angle =double(zeros(2,1));
%angola =double(zeros(2,1));
loopcnt =1;
validp =1;

for i =1:a(2) % duty cycle for the number of columns
if dist(i)>0 % account valid points , different from zero
validp=validp+1;
end;
end;




%ZETA =zeros(nonzero,3); % initialize vector distances
ZETAcart =zeros(validp,3); 
for i=1:a(2) % duty cycle for the number of columns
if dist(i)>0 % only valid for points
df =re-dist(i);
%
if(df>0)  
x =df/cos(phik);
%hn=h+x;
else
x =df/cos(phik);
    % hn=h-x;
end;
%x = slun(2)-x;
%thetau=atand(hn/l);


%{
if(df>0)
    hn =h+x;
    xn =step-dist(i);
else

    hn=h-x;
    xn=step+dist(i);
end;
thetau=atand(hn/l);
rd =l*cos(thetau);
%}

% h =(h2-dist(i))/a(2); %transformed mm in height relative to the center
% beta =atand(h) ; % beta calculation
% l=(l2-i)/slun(2); % transform width in mm
% sigma =atand(l); % sigma calculation
% zeta =(H/sind(alpha))/cosd(sigma); % calculation zeta

%angle(1,1) =phik;
%angle(2,1) =thetau;
%angola =phitheta2azel(angle)/360*2*pi; % transform coordinates azimuth elevation
% trasformed into cartesian coordinate
step_total = step*step_angles;
ZETAcart(loopcnt,1)= x*cos(step_total);
ZETAcart(loopcnt,2)=i;
ZETAcart(loopcnt,3)=x*sin(step_total);
loopcnt =loopcnt+1;
end;
%end; % move reference system



%nonzeri =nonzeri+1;
%end;
end;


% create rotation matrix
 % add the step angle rotation

%z(step,i)=x;
%y(step,i)= x*i*sin(step_total);
%X(step,i) =step*x*cos(step_total);
%ZETA(t,:) =(rotate1*(ZETA(t,:))')';
% rd(t,:) =(rotate1*(rd(t,:))')';
%ZETAcart =[X(step,i),y(step,i),z(step,i)];
ZETA = ZETAcart ;
ZETA(:,1) = ZETAcart(:,1);
%{
rotate1 = angle2dcm(0,0,step_total);

for t =1:nonzeri
ZETA(t,:) =(rotate1*(ZETA(t,:))')';
end;
%}

save('test.asc','ZETA','-append','-ASCII');
% save('test.asc','ZETA','-append','-ASCII');

end;
