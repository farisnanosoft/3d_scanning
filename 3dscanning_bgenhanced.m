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
limit1=35;
limit2=39;
for step = 1:rows
RGB = imread(framedir(step).name);
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
column =single(rgb(:,i,3));
yos = interp1(short,column,time,'spline');
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
end end
end
c=max1;
pos=c2;
poss =-pos+ts(2);
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