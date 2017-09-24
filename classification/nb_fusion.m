function [YY,DD,lam]=nb_fusion(indtrn,indtst,Xaf,Xah,Xvf,Xvh,Da,Dv)
% naive-bayes decision-level fusion
% indtrn and indtst: index for training and test data
% Xaf: features from EEG for arousal classification
% Xah: features from heart rate for arousal classification
% Xvf: features from EEG for valence classification
% Xvh: features from heart rate for valence classification
% Da: arousal level label
% Dv: valence level label
fbs_lm_tr=[1 0 0 0;0 0.973 0 0;0 0 1 0;0 0.0207 0 1];
fbs_lm_ts=[0.7550 0.0513 0.0031 0.0055;0.1612 0.8645 0.0132 0.0287;...
    0.0594 0.0102 0.9230 0.0339;0.0244 0.0740 0.0607 0.9319];
hr_lm_tr=[0.8926 0.0293 0.0024 0;0.0024 0.9663 0 0.0305;...
    0.1050 0.0005 0.9976 0.0298;0 0.0039 0 0.9397];
hr_lm_ts=[0.7377 0.0510 0.0290 0.0211;0.0670 0.8383 0.0787 0.1223;...
    0.1395 0.0171 0.7995 0.0748;0.0557 0.0937 0.0929 0.7819];

Xa_trnf=Xaf(indtrn,:); Xa_trnh=Xah(indtrn,:);Da_trn=Da(indtrn);
    Xa_tstf=Xaf(indtst,:); Xa_tsth=Xah(indtst,:);Da_tst=Da(indtst);
    Xv_trnf=Xvf(indtrn,:); Xv_trnh=Xvh(indtrn,:);Dv_trn=Dv(indtrn); 
    Xv_tstf=Xvf(indtst,:); Xv_tsth=Xvh(indtst,:);Dv_tst=Dv(indtst);
    DD=[Da_tst' Dv_tst'];   
    
netAf=svmtrain(Xa_trnf,Da_trn','Kernel_Function','polynomial');
    YAf=svmclassify(netAf,Xa_tstf);
    netAh=svmtrain(Xa_trnh,Da_trn','Kernel_Function','polynomial');
    YAh=svmclassify(netAh,Xa_tsth);
    
    netVf=svmtrain(Xv_trnf,Dv_trn','Kernel_Function','polynomial');
    YVf=svmclassify(netVf,Xv_tstf);
    netVh=svmtrain(Xv_trnh,Dv_trn','Kernel_Function','polynomial');
    YVh=svmclassify(netVh,Xv_tsth);
    
    YYf=[YAf YVf];
    YYh=[YAh YVh];
    yfo=bin2dec(num2str(YYf))+ones(length(YYh),1);
    yho=bin2dec(num2str(YYh))+ones(length(YYh),1);
    for i=1:length(yfo)
        for j=1:4
            lambda(i,j)=fbs_lm_ts(j,yfo(i))*hr_lm_ts(j,yho(i));
        end
    end
    for i=1:length(yfo)
        [mm,kk]=max(lambda(i,:));
        lam(i)=mm;
        if kk==1
            YY(i,:)=[0 0];
        end
        if kk==2
            YY(i,:)=[0 1];
        end
        if kk==3
            YY(i,:)=[1 0];
        end
        if kk==4
            YY(i,:)=[1 1];
        end
        
    end
        
    
    YA=YY(:,1);
    YV=YY(:,2);
end