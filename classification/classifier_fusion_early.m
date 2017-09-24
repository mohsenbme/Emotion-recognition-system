clear all;close all;clc;  load myfeatspace;
% Classification based on early (feature) level fusion
sfs_a=[17 68 14 30 8 54 10 29 1 33 28 39];     sfs_v=[67 55 46 8 18 13 58 71 9 11 34]; 

Da(1:51)=0; Da(52:100)=1; Da(101:124)=1; Da(125:143)=0; % 0: low arousal, 1:high arousal
Dv(1:100)=1; Dv(101:143)=0; % 0:negative valence, 1: positive valence
%DD=[Da' Dv'];
Xa=X(:,sfs_a);  
Xv=X(:,sfs_v); 
ind=randperm(143);
for fl=1:50
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
netA4=svmtrain(Xa_trn,Da_trn','Kernel_Function','linear');

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
accV(f)=1-sum(EV)/length(Dv_tst);
YY=[YA' YV'];

end
%CMS((j-1)*4+1:j*4,1:4)=CM./4;
A(:,(fl-1)*4+1:fl*4)=accA;
V(:,(fl-1)*4+1:fl*4)=accV;
end
clear Xa Da Xv Dv netA netV YA YV EA EV
