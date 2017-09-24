function YY=fbs_classifier(indtrn,indtst,Xaf,Xvf,Da,Dv)
Xa_trnf=Xaf(indtrn,:); Da_trn=Da(indtrn);
Xa_tstf=Xaf(indtst,:); Da_tst=Da(indtst);
Xv_trnf=Xvf(indtrn,:);Dv_trn=Dv(indtrn);
Xv_tstf=Xvf(indtst,:); Dv_tst=Dv(indtst);
DD=[Da_tst' Dv_tst'];   
    
netAf=svmtrain(Xa_trnf,Da_trn','Kernel_Function','polynomial');
    YAf=svmclassify(netAf,Xa_tstf);
netVf=svmtrain(Xv_trnf,Dv_trn','Kernel_Function','polynomial');
    YVf=svmclassify(netVf,Xv_tstf);
YY=[YAf YVf];