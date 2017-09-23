function out=mygama(X,v,k)
% This feature evaluation criterion adopted from: Hu Q, Xie Z, Yu D. Hybrid
% attribute reduction based on a novel fuzzy-rough model and information 
% granulation. Pattern Recogn. 2007;40:3509–21.
% X:data matrix,features in columns
% v: a vector indicating feature indices (concatenated together) for evaluation
% k: a threshold (refer to teh paper for more info)
[rw,c]=size(X);

for i=1:rw
    for j=1:rw
        d(i,j)=sum((X(i,:)-X(j,:)).^2);  % "d" is the square matrix of distances
    end
end
r=1-4*d;
vv=[0 v];
BD=zeros(1,length(v));
for j=1:length(v)
    for i=sum(vv(1:j))+1:vv(j+1)
        if sum(r(i,sum(vv(1:j))+1:vv(j+1)))/sum(r(i,:))>k
        BD(j)=BD(j)+1;
        end
    end
end
out=sum(BD)/rw;
