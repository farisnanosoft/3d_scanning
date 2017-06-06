clc ;
clear all;
close all;
framedir =dir('*.jpg');
row = size(framedir);
rows = row(1) ;
step_angle = 0.279;
step_angles =degtorad(step_angle);
init = [0,0,0];
save('test.asc','init','-ASCII');
for step = 1:rows
RGB = imread(framedir(step).name);
RGB = rgb2gray(RGB);
RGB = imrotate(RGB,90) ;
rgb = single(RGB);
a = size(rgb);
steps =1;
ends = a(1)-steps;
short = 0:1:ends;
columnindex = 1:1:a(2);
time = 0:(steps):(ends);
ts = size(time);
cut = 10;
dist = 1:a(2);
for i=1:a(2)
column =single(rgb(:,i));
yos = interp1(short,column,time,'spline');
[c,pos] =max(yos);
poss = ts(2)-pos;
if(c<cut)
    dist(i)=0;
else
    dist(i)=poss;
end;
end;
l = 200 ;
h = 400;
phik = atand(h/l);
re = ts(2)/2;
ce = a(2)/2;
loopcnt =1;
validp =1;
for i =1:a(2)
if dist(i)>0
validp=validp+1;
end;
end;
ZETAcart =zeros(validp,3);
for i=1:a(2)
if dist(i)>0
df =re-dist(i);
if(df>0)
x =-df/cos(phik);
else
x =df/cos(phik);
end;
step_total = step*step_angles;
ZETAcart(loopcnt,1)= x*cos(step_total);
ZETAcart(loopcnt,2)=i;
ZETAcart(loopcnt,3)=x*sin(step_total);
loopcnt =loopcnt+1;
end;
end;
ZETA = ZETAcart ;
ZETA(:,1) = ZETAcart(:,1);
save('test.asc','ZETA','-append','-ASCII');
end;