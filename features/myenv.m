function [UE,LE]=myenv(x)
% extracts upper and lower envelopes
l=length(x);
g=[];
for i=2:l-1
    if x(i)>x(i-1) && x(i)>x(i+1)
    g=[g i];
    end
end
if x(1)>x(2)
    g=[1 g];
end
if x(l)>x(l-1)
    g=[g l];
end
q=[];
for i=2:l-1
    if x(i)<x(i-1) && x(i)<x(i+1)
    q=[q i];
    end
end
if x(1)<x(2)
    q=[1 q];
end
if x(l)<x(l-1)
    q=[q l];
end
UE=csapi(g,x(g),1:l);
LE=csapi(q,x(q),1:l);
