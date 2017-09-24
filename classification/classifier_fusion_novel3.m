clear all;close all;clc;  load myfeatspace;
At=[]; Vt=[]; Act=[];
for th=0.65:0.05:0.8
    
accA=[];accV=[]; lam=[]; E=[];

for fl=1:100
    fl
    th
sfs_af=[10 52 15 2 8 51 54 26];     sfs_vf=[57 15 34 18 9 13 10 50 51];
sfs_ah=[1 14 3 11 10 19];     sfs_vh=[19 2 17 8 14 18];  
sfs_a=[17 68 14 30 8 54 10 29 1 33];
sfs_v=[57 67 46 8 69 19 58 30 13];
Xaf=XEEG(:,sfs_af); Xah=XHR(:,sfs_ah); 
Xvf=XEEG(:,sfs_vf); Xvh=XHR(:,sfs_vh); 
Xa1=X(:,sfs_a);                        
Xv1=X(:,sfs_v);                        
Da(1:51)=0; Da(52:100)=1; Da(101:124)=1; Da(125:143)=0; % 0: low arousal, 1:high arousal
Dv(1:100)=1; Dv(101:143)=0; % 0:negative valence, 1: positive valence

ind=randperm(143);
for f=1:4
    indtrn=ind;
    indtst=ind((f-1)*35+1:f*35);
    indtrn(indtst)=[];
    
    %*****
    [YY_nb,DD,lam]=nb_fusion(indtrn,indtst,Xaf,Xah,Xvf,Xvh,Da,Dv);
    %YY_svm=svm_fusion(indtrn,indtst,Xa1,Xv1,Da,Dv); % th: 0.45, 0.55
    YY_fbs=fbs_classifier(indtrn,indtst,Xaf,Xvf,Da,Dv); %0.6 0.8good arousal
    %YY_ei=early_fusion(indtrn,indtst,Xa1,Xv1,Da,Dv);
    for i=1:length(YY_nb)
        if (YY_nb(i,1)==0 && YY_nb(i,2)==1) && lam(i)>=th
            YY(i,:)=YY_nb(i,:);
        elseif (YY_nb(i,1)==0 && YY_nb(i,2)==1) && lam(i)<th
            YY(i,:)=YY_fbs(i,:);
        elseif (YY_nb(i,1)==1 && YY_nb(i,2)==0) && lam(i)>=th
            YY(i,:)=YY_nb(i,:);
        elseif (YY_nb(i,1)==1 && YY_nb(i,2)==0) && lam(i)<th
            YY(i,:)=YY_fbs(i,:);
        elseif YY_nb(i,1)==0 && YY_nb(i,1)==0
            YY(i,:)=YY_fbs(i,:);
        elseif YY_nb(i,1)==1 && YY_nb(i,1)==1
            YY(i,:)=YY_fbs(i,:);
        end
    end
Da_trn=Da(indtrn);
Da_tst=Da(indtst);
Dv_trn=Dv(indtrn); 
Dv_tst=Dv(indtst); 
    EA=abs(Da_tst'-YY(:,1));
    accA=[accA 1-sum(EA)/length(Da_tst)];
    EV=abs(Dv_tst'-YY(:,2));
    accV=[accV 1-sum(EV)/length(Dv_tst)];
    
    bb=0;ss=0;nn=0;dd=0; cm=zeros(4,4);
    for g=1:length(DD)
       if DD(g,1)==0 && DD(g,2)==0 %low arousal negative valence
        bb=bb+1;
        if YY(g,1)==0 && YY(g,2)==0
        cm(1,1)=cm(1,1)+1;
        elseif YY(g,1)==0 && YY(g,2)==1
        cm(1,2)=cm(1,2)+1;
        elseif YY(g,1)==1 && YY(g,2)==0
        cm(1,3)=cm(1,3)+1;
        elseif YY(g,1)==1 && YY(g,2)==1
        cm(1,4)=cm(1,4)+1;
        end
       end
       if DD(g,1)==0 && DD(g,2)==1 %low arousal positive valence
    ss=ss+1;
   if YY(g,1)==0 && YY(g,2)==0
        cm(2,1)=cm(2,1)+1;
    elseif YY(g,1)==0 && YY(g,2)==1
        cm(2,2)=cm(2,2)+1;
    elseif YY(g,1)==1 && YY(g,2)==0
        cm(2,3)=cm(2,3)+1;
    elseif YY(g,1)==1 && YY(g,2)==1
        cm(2,4)=cm(2,4)+1;
   end
       end
if DD(g,1)==1 && DD(g,2)==0 %high arousal negative valence
    nn=nn+1;
    if YY(g,1)==0 && YY(g,2)==0
        cm(3,1)=cm(3,1)+1;
    elseif YY(g,1)==0 && YY(g,2)==1
        cm(3,2)=cm(3,2)+1;
    elseif YY(g,1)==1 && YY(g,2)==0
        cm(3,3)=cm(3,3)+1;
    elseif YY(g,1)==1 && YY(g,2)==1
        cm(3,4)=cm(3,4)+1;
    end
end
if DD(g,1)==1 && DD(g,2)==1 %high arousal positive valence
    dd=dd+1;
    if YY(g,1)==0 && YY(g,2)==0
        cm(4,1)=cm(4,1)+1;
    elseif YY(g,1)==0 && YY(g,2)==1
        cm(4,2)=cm(4,2)+1;
    elseif YY(g,1)==1 && YY(g,2)==0
        cm(4,3)=cm(4,3)+1;
    elseif YY(g,1)==1 && YY(g,2)==1
        cm(4,4)=cm(4,4)+1;
    end
end
end

cm(1,:)=cm(1,:)./bb;
cm(2,:)=cm(2,:)./ss;
cm(3,:)=cm(3,:)./nn;
cm(4,:)=cm(4,:)./dd;
end
allcms1((fl-1)*4+f,:)=cm(1,:);
allcms2((fl-1)*4+f,:)=cm(2,:);
allcms3((fl-1)*4+f,:)=cm(3,:);
allcms4((fl-1)*4+f,:)=cm(4,:);
end
bcm=[];scm=[]; ncm=[]; dcm=[];
for i=1:length(allcms1)
    if sum(allcms1(i,:))~=0
        bcm=[bcm;allcms1(i,:)];
    end
end
for i=1:length(allcms2)
    if sum(allcms2(i,:))~=0
        scm=[scm;allcms2(i,:)];
    end
end
for i=1:length(allcms3)
    if sum(allcms3(i,:))~=0
        ncm=[ncm;allcms3(i,:)];
    end
end
for i=1:length(allcms4)
    if sum(allcms4(i,:))~=0
        dcm=[dcm;allcms4(i,:)];
    end
end
%lam=max(lambda')';
mean_cm=[mean(bcm);mean(scm);mean(ncm);mean(dcm)];
At=[At mean(accA)]; Vt=[Vt mean(accV)]; Act=[Act mean(accA.*accV)];
end
