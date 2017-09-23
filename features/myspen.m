function out=myspen(x)
% calculates spectral entropy
%function [f,p,pt,pa1,pa2,pa,pb1,pb2,pb,pg]=mypsd(x)
%sf=menu('Sampling frequency?',' 1024 Hz ','1 Hz');
clear pt pa1 pa2 pa pb1 pb2 pb pg

fs=256;
l=length(x);
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
%pt=0;pa1=0;pa2=0;pb1=0;pb2=0;pg=0;
out=0; N=0; sss=[];
for i=1:length(f)
    if f(i)>4 && f(i)<=35
        %out=out+p(i)*log2(1/p(i));
        sss=[sss p(i)*log2(1/p(i))];
        N=N+1;
    end
    N
    out=sum(sss)/log2(N);
end
plot(f,p,'k'); xlim([0 40]);
plot(sss)
    
