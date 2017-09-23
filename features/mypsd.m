function out=mypsd(x)
%function [f,p,pt,pa1,pa2,pa,pb1,pb2,pb,pg]=mypsd(x)
%sf=menu('Sampling frequency?',' 1024 Hz ','1 Hz');
clear pt pa1 pa2 pa pb1 pb2 pb pg
sf=1;
if sf==1
    x(2:2:end)=[];
    x(2:2:end)=[];
end
fs=256;
l=length(x);
x=x-mean(x);
ns=floor(l/256)+1;
if mod(l,256)==0
    ns=ns-1;
end
for i=1:ns-1
    s(i,:)=x((i-1)*256+1:i*256);
end
for i=1:ns-1
    s2(i,:)=[s(i,:).*hanning(256)' zeros(1,256)];
end
sns=x((ns-1)*256+1:end);
[rr,cc]=size(sns);
if rr>1
    sns=sns';
end
s2(ns,:)=[sns.*hanning(length(sns))' zeros(1,512-length(sns))];
for i=1:ns
    X(i,:)=fft(s2(i,:));
end
for i=1:ns
    Px(i,:)=X(i,:).*conj(X(i,:));
end
PP=mean(Px);
p=PP(1:256);
f=[0:255]./255.*(fs/2);
pt=0;pa1=0;pa2=0;pb1=0;pb2=0;pg=0;
for i=1:length(f)
    if f(i)>=4 && f(i)<8
        pt=p(i)+pt;
    end
    if f(i)>=8 && f(i)<10
        pa1=p(i)+pa1;
    end
    if f(i)>=10 && f(i)<=13
        pa2=p(i)+pa2;
    end
    if f(i)>13 && f(i)<20
        pb1=p(i)+pb1;
    end
    if f(i)>=20 && f(i)<30
        pb2=p(i)+pb2;
    end
    if f(i)>=30 && f(i)<41
        pg=p(i)+pg;
    end
end
pa=pa1+pa2;
pb=pb1+pb2;
out=[pt pa1 pa2 pa pb1 pb2 pb pg]';
sprintf('out=[pt pa1 pa2 pa pb1 pb2 pb pg]')
plot(f,p,'k'); xlim([0 40]) 
    
