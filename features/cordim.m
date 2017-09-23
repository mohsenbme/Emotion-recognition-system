function out=cordim(x)
x=(x-min(x))./(max(x)-min(x));
N=length(x);
R=10.^[-5:0.125:0];
for r=1:length(R)
    for i=1:N
        cnt=0;
        for j=1:N
            if abs(x(i)-x(j))<=R(r)
                cnt=cnt+1;
            end
        end
        cnt=cnt-1;
        p(r,i)=cnt/(N-1);
    end
    C(r)=sum(p(r,1:N));
end
plot(log10(R),log10(C),'.')
xlabel('logR');
ylabel('log C(R)');