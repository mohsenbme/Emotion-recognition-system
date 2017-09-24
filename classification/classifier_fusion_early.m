clear all;close all;clc;  load myfeatspace;
sfs_a=[17 68 14 30 8 54 10 29 1 33 28 39];     sfs_v=[67 55 46 8 18 13 58 71 9 11 34]; 
% feature-level (early) fusion
tic
Da(1:51)=0; Da(52:100)=1; Da(101:124)=1; Da(125:143)=0; % 0: low arousal, 1:high arousal
Dv(1:100)=1; Dv(101:143)=0; % 0:negative valence, 1: positive valence
%DD=[Da' Dv'];
Xa=X(:,sfs_a);  
Xv=X(:,sfs_v); 
r1_cms=[];r2_cms=[];r3_cms=[];r4_cms=[];
for fl=1:100
    ind=randperm(143);
    fl
CM=zeros(4,4);
for f=1:4
    indtrn=ind;
    indtst=ind((f-1)*35+1:f*35);
    indtrn(indtst)=[];
    Xa_trn=Xa(indtrn,:); Da_trn=Da(indtrn); 
    Xa_tst=Xa(indtst,:); Da_tst=Da(indtst);
    Xv_trn=Xv(indtrn,:); Dv_trn=Dv(indtrn);
    Xv_tst=Xv(indtst,:); Dv_tst=Dv(indtst);
    DD=[Da_tst' Dv_tst'];   %%%%%%
netA1=svmtrain(Xa_trn,Da_trn','Kernel_Function','rbf');
netA2=svmtrain(Xa_trn,Da_trn','Kernel_Function','quadratic');
netA3=svmtrain(Xa_trn,Da_trn','Kernel_Function','polynomial');
netA4=svmtrain(Xa_trn,Da_trn','Kernel_Function','linear'); % four classifiers for decision-level fusion

YA1=svmclassify(netA1,Xa_tst); YA1=round(YA1);
YA2=svmclassify(netA2,Xa_tst); YA2=round(YA2);
YA3=svmclassify(netA3,Xa_tst); YA3=round(YA3);
YA4=svmclassify(netA4,Xa_tst); YA4=round(YA4);

YAA=[YA1 YA2 YA3 YA4]; [ry,cy]=size(YAA);
for i=1:ry
    if sum(YAA(i,:))>2
        YA(i)=1;
    else
        YA(i)=0;
    end
    if sum(YAA(i,:))==2
        YA(i)=YA1(i);
    end
end
EA=abs(Da_tst-YA);
accA(f)=1-sum(EA)/length(Da_tst);

netV1=svmtrain(Xv_trn,Dv_trn','Kernel_Function','rbf');
netV2=svmtrain(Xv_trn,Dv_trn','Kernel_Function','quadratic');
netV3=svmtrain(Xv_trn,Dv_trn','Kernel_Function','polynomial');
netV4=svmtrain(Xv_trn,Dv_trn','Kernel_Function','linear');

YV1=svmclassify(netV1,Xv_tst); YV1=round(YV1);
YV2=svmclassify(netV2,Xv_tst); YV2=round(YV2);
YV3=svmclassify(netV3,Xv_tst); YV3=round(YV3);
YV4=svmclassify(netV4,Xv_tst); YV4=round(YV4);

YVV=[YV1 YV2 YV3 YV4]; [ry,cy]=size(YVV);
for i=1:ry
    if sum(YVV(i,:))>2
        YV(i)=1;
    else
        YV(i)=0;
    end
    if sum(YVV(i,:))==2
        YV(i)=YV1(i);
    end
end

EV=abs(Dv_tst-YV);
accV(f)=1-sum(EV)/length(Dv_tst); % valence classification accuracy
YY=[YA' YV'];

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
elseif DD(g,1)==0 && DD(g,2)==1 %low arousal positive valence
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
elseif DD(g,1)==1 && DD(g,2)==0 %high arousal negative valence
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
elseif DD(g,1)==1 && DD(g,2)==1 %high arousal positive valence
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
cm(1,:)=cm(1,:)./bb; cm(2,:)=cm(2,:)./ss;
cm(3,:)=cm(3,:)./nn; cm(4,:)=cm(4,:)./dd;
CM=CM+cm;
clear cm bb nn ss dd
end
CMS((fl-1)*4+1:fl*4,:)=CM./4; % Confusion matrix
r1_cms=[r1_cms;CM(1,:)./4]; r2_cms=[r2_cms;CM(2,:)./4];
r3_cms=[r3_cms;CM(3,:)./4]; r4_cms=[r4_cms;CM(4,:)./4];
A(:,(fl-1)*4+1:fl*4)=accA;
V(:,(fl-1)*4+1:fl*4)=accV;

%CMS((j-1)*4+1:j*4,1:4)=CM./4;  
A(:,(fl-1)*4+1:fl*4)=accA;
V(:,(fl-1)*4+1:fl*4)=accV;
end
lr1=[];lr2=[];lr3=[];lr4=[];
for i=1:100
    if sum(isnan(r1_cms(i,:)))~=0
        lr1=[lr1 i];
    end
    if sum(isnan(r2_cms(i,:)))~=0
        lr2=[lr2 i];
    end
    if sum(isnan(r3_cms(i,:)))~=0
        lr3=[lr3 i];
    end
    if sum(isnan(r4_cms(i,:)))~=0
        lr4=[lr4 i];
    end
end
r1_cms(lr1,:)=[]; r2_cms(lr2,:)=[]; r3_cms(lr3,:)=[]; r4_cms(lr4,:)=[]; 
mean_cm=[mean(r1_cms);mean(r2_cms);mean(r3_cms);mean(r4_cms)];
std_cm=[std(r1_cms);std(r2_cms);std(r3_cms);std(r4_cms)];
toc
clear Xa Da Xv Dv netA netV YA YV EA EV
