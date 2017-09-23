function out=myhrf(x,tl,t)
x=60./x; %convert to RR (s)
out(1)=mean(x);
out(2)=std(x);
out(3)=mean(x(2:end)-x(1:end-1));
out(4)=std(x(2:end)-x(1:end-1));
out(5)=myrms(x(2:end)-x(1:end-1));
SD=eig(cov([x(2:end)' x(1:end-1)'])); 
out(6)=SD(1)/SD(2); % SD1/SD2
A=[[1:length(x)]' ones(length(x),1)];
hr=60./x;
linp=inv(A'*A)*A'*hr';
out(7)=linp(1);
s0x=hr-linp(1).*[1:length(hr)]-linp(2);
out(8)=myzc(s0x,0)/(2*tl); % zero crossing across the trend line
out(9)=mywl(x)/tl;
out(10)=mysampen(x,2,0.15*std(x)); % sample entropy
out(11)=mysampen(x,3,0.15*std(x));
out(12)=mysampen(x,4,0.15*std(x));
out(13)=mysampen(x,5,0.15*std(x));
cnt=0;
for i=1:length(x)
    if x(i)>0.05
        cnt=cnt+1;
    end
end
%out(14)=cnt/length(x); %pNN50
[mA,~]=min(x); xA=mA; yA=abs(mean(x)-xA); % triangular features
[mC,~]=max(x); xC=mC;  yC=abs(mean(x)-xC);
[mB,kB]=min(abs(mean(x)-x)); xB=x(kB); yB=mB;
a=sqrt((xB-xC)^2+(yB-yC)^2); b=sqrt((xA-xC)^2+(yA-yC)^2);
c=sqrt((xB-xA)^2+(yB-yA)^2);
out(14)=acosd((b^2+c^2-a^2)/(2*b*c)); % A angle
out(15)=a+b+c; %Periferal
out(16)=0.5*abs((xA-xC)*(yB-yA)-(xA-xB)*(yC-yA)); %area
%out(17)=(yB-yA)/(xB-xA); %mC
out(17)=4*sqrt(3)*out(16)/(a^2+b^2+c^2); %q
xups=myhrvresamp(x,t);
[UE,LE]=myenv(xups);     
yy=xups(1,:)-(LE+UE)./2;
[num,den]=butter(4,0.3/2,'high'); 
y=filter(num,den,yy);
out(18)=sum(y.^2)/(length(y)^1); %HF power estimation after detrending by average of envelopes
sucdis=abs(x(2:end)-x(1:end-1)); avd=mean(sucdis);
L=sum(sucdis); dia=max(abs(x-x(1)));
out(19)=log10(L/avd)/log10(dia/avd); %Dkatz dimension
out(20)=kurtosis(x);
