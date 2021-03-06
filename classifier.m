function [ matf ] = classifier(training_structure,ms)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% load('data3.mat');
cnt=0;
% ms=35;
srcFiles1 = dir('N:\thesis\noto_data\Box Sync\notochord5dpf\*.jpg'); % the folder in which ur images exists
srcFiles2 = dir('N:\thesis\noto_data\Box Sync\notochord5dpfOriginal\*.jpg');
z=150;
tp=0;
tn=0;
fp=0;
fn=0;
matf=[];
lf=1500; %last file
while(z< lf)
z=z+5;
cnt1=0;
filename1 = strcat('N:\thesis\noto_data\Box Sync\notochord5dpf\',srcFiles1(z).name);
filename2 = strcat('N:\thesis\noto_data\Box Sync\notochord5dpfOriginal\',srcFiles2(z).name);
I = imread(filename1);
I1 = imread(filename2);
displayimages(I);
displayimages(I1);
idl=I;
[ imb,m,n ] = preprocessing( idl );
displayimages(imb);
[ bbc ] = bbcalc(imb,m,n);
displayimages(idl,bbc,m,n);
[ idl,m,n ] = preprocessing( idl,'colour' );
[ bbcol ] = bbcalc(idl,bbc);
displayimages(idl,bbcol,m,n);
[retimg ,selected_pixels ] = pixelselector( idl,bbcol );
if(numel(selected_pixels)~=0)
    mincbx= min(selected_pixels(1,:));
    maxcbx= max(selected_pixels(1,:));
    mincby= min(selected_pixels(2,:));
    maxcby= max(selected_pixels(2,:));
end
i=bbc(1);
j=bbc(3);
while(i<bbc(2))
    j=bbc(3);
    i=i+3;
    while(j < bbc(4) && i<bbc(2))
        j=j+5;
        maskc= I1(i-ms:i+ms,j-ms:j+ms,:);
        mask = rgb2gray(maskc);
        data_point=double(reshape(mask,[1,(2*ms+1)^2]));
        p= svmclassify(training_structure,data_point);
        if(numel(selected_pixels)~=0)
            temp=((i-selected_pixels(1,:)).^2)+((j-selected_pixels(2,:)).^2);
        else
            temp= 50; %random number not equal to 0
        end
        if (numel(find(temp==0))~=0)
            if(p>=0)
                tp=tp+1;
            else
                fp=fp+1;
            end
        else
            if(p<=0)
                tn=tn+1;
            else
                fn=fn+1;
            end
        end
        if(numel(selected_pixels)~=0)
            if((mincbx-i)>10)
                i=i+round((mincbx-i)/2)+10;
            end
            if((i-maxcbx)>10)
                i=i+ round((i-maxcbx)/2)+10;
            end
            if((mincby-j)>10)
                j=j+round((mincby-j)/2)+10;
            end
            if((j-maxcby)>10)
                j=j + round((j-maxcby)/2)+10 ;
            end
        else
            i=i+10;
            j=j+25;
           
        end
        
    end
    
end
%
%     z=z+5000;
mat = [tp tn fp fn];

matf=[mat;matf];
end

end

