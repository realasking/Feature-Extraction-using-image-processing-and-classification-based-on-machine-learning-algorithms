%thesis
close all;clc;clear all;
tic
cnt=0;
data_matrix=[];
srcFiles = dir('N:\thesis\noto_data\Box Sync\notochord5dpf\*.jpg');  % the folder in which ur images exists
srcFiles2 = dir('N:\thesis\noto_data\Box Sync\notochord5dpfOriginal\*.jpg');
i=590;
tic
ws=20;
nf=2;
nb=250;
for tp1=1:35
 ws= tp1;
 nf=8*tp1+1;
 nb=30*tp1+1;
 while(i< length(srcFiles)-500)
    i=i+5;
    cnt1=0;
    filename = strcat('N:\thesis\noto_data\Box Sync\notochord5dpf\',srcFiles(i).name);
    filename2 = strcat('N:\thesis\noto_data\Box Sync\notochord5dpfOriginal\',srcFiles2(i).name);
    I1 = imread(filename2);
    I = imread(filename);
    displayimages(I);
    idl=I;
% id = imread('N:\\thesis\\test1.jpg');
% idl = imread('N:\\thesis\\test1_label.jpg');
[ imb,m,n ] = preprocessing( idl );
displayimages(imb);  
[ bbc ] = bbcalc(imb,m,n);
 displayimages(idl,bbc,m,n);
[ idl,m,n ] = preprocessing( idl,'colour' );
[ bbcol ] = bbcalc(idl,bbc);
displayimages(idl,bbcol,m,n);
[retimg ,selected_pixels ] = pixelselector( idl,bbcol );
displayimages(idl,selected_pixels);
[data_matrix_training] = feature_selector(selected_pixels,bbc,I1,ws,nf,nb);
cnt1=numel(find(data_matrix_training(:,end)==1));
cnt=cnt1+cnt;
data_matrix=[data_matrix;data_matrix_training];
% toc
end

[SVMStruct ] = classifier_training(data_matrix);
svm{tp1} = SVMStruct;
[ matf ] = classifier(training_structure,ws);
matfin{tp1} = matf;

end
toc

