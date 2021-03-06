function out=myhoc(x)
% calculates higher order crossings
x=x-mean(x);
F1=x; 
F2=F1(2:end)-F1(1:end-1); 
F3=F2(2:end)-F2(1:end-1);
F4=F3(2:end)-F3(1:end-1);
F5=F4(2:end)-F4(1:end-1);
F6=F5(2:end)-F5(1:end-1);
F7=F6(2:end)-F6(1:end-1);
F8=F7(2:end)-F7(1:end-1);
out=[myzc(F1,0) myzc(F2,0) myzc(F3,0) myzc(F4,0) myzc(F5,0) myzc(F6,0) myzc(F7,0) myzc(F8,0)]./(length(x)/256);
