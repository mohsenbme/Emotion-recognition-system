function out=myane(x)
% average nonlinear energy
ne=x;
for i=2:length(x)-1
    ne(i)=x(i)^2-(x(i+1)*x(i-1));
end
new=ne.*hanning(length(ne))';
out=mean(new);
