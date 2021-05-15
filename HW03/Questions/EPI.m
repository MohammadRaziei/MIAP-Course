function epi = EPI(ref_img, dis_img)
% input image is highpass filtered with laplacian filter
H = fspecial('laplacian',0.2) ;
% preparing the components of EPI
deltas=imfilter(ref_img,H);
meandeltas=mean2(deltas);
deltascap=imfilter(dis_img,H);
meandeltascap=mean2(deltascap);
p1=deltas-meandeltas;
p2=deltascap-meandeltascap;
num=sum(sum(p1.*p2));
den=(sum(sum(p1.^2))).*(sum(sum(p2.^2)));
epi=mean(num./sqrt(den))
end