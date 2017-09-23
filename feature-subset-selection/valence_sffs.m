clear all;close all;clc
% sequential forward floating selection to find features for arousal level discrimination
% x1 and x4: low arousal classes
% x2 and x3: high arousal classes
load confirmed_labels_rates

X=[x1;x2;x3;x4];
[rw,c]=size(X);
for i=1:c
    X(:,i)=(X(:,i)-min(X(:,i)))./(max(X(:,i))-min(X(:,i)));
end
[r1,c1]=size(x1);[r2,c2]=size(x2);[r3,c3]=size(x3);[r4,c4]=size(x4);
v=[r1+r2 r3+r4];
k=0.6; % k=0.2
    
afi=1:57; % all feature indexes
sfi=[]; %selected feature indexes
l=0; fg=0; stp=0;
while stp==0;
    l
    clear BD; clear gama;
for i=1:length(afi)
    gama(i)=mygama(X(:,[sfi afi(i)]),v,k);
   
end
[mm,kk]=max(gama);
if mm>fg
sfi=[sfi afi(kk)];
fg=mygama(X(:,sfi),v,k);
ff=afi(kk);
afi(kk)=[];
l=l+1;
if l>2
    for i=1:length(sfi)
        sff=sfi;sff(i)=[];
        gam(i)=mygama(X(:,sff),v,k);
    end
    [mmm,kkk]=max(gam);
    if mmm>mm
        afi=[afi sfi(kkk)];
        sfi(kkk)=[];
    end
    clear gam;
end
else
    stp=1;
end
end

for i=1:length(sfi)
    plot(i,mygama(X(:,sfi(1:i)),v,k),'*');hold on;
end

    
