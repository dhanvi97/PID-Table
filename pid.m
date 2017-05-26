a = arduino('com4' , 'uno' , 'Libraries' , 'Servo' );
sx = servo(a , 9, 'MinPulseDuration', 544*10^-6, 'MaxPulseDuration', 2400*10^-6); %default 544, 2400
sy = servo(a , 10, 'MinPulseDuration', 544*10^-6, 'MaxPulseDuration', 2400*10^-6); %default 544, 2400
cam = webcam('USB Video Device');
%%
writePosition(sx,38.0/180.0);
writePosition(sy,105.0/180.0);
fprintf('arduino and servo\n');
%%

ct_x=zeros([1 2]);
ct_y=zeros([1 2]);
ct_y=[307.4808 436.3636];
ct_x=[101.1660 , 274.4162];
ct=[314.7243 285.3043];	
pics=cell(1,100);
rgb=cell(1,100);
centre_final=zeros([100 2]);
fprintf('cam and variables\n');
%%
posx = zeros([100,1]);
posy = zeros([100,1]);
px = zeros([100,1]);
py = zeros([100,1]);
%%
cam = webcam('USB2.0 Camera');
%%
preview(cam)

%%

for i = 1.0:1.0:100.0
%preview(cam);

img = snapshot(cam);
%rgb{i}=img;
img = im2bw(img,0.26);
pics{i}=img;
%imshow(img);
[centers,radii] = imfindcircles(pics{i},[20 50], ...
  'ObjectPolarity','dark','Sensitivity',0.85,'EdgeThreshold',0.3);
%screening function
 
centre_final(i,1)=centers(1,1);
centre_final(i,2)=centers(1,2);
%elapsed = etime(clock, iTime); 

py(i) = (centre_final(i,1)-ct(1,1))*(ct_y(1,1)-ct(1,1))+(centre_final(i,2)-ct(1,2))*(ct_y(1,2)-ct(1,2));
%dx = (centre_final(i,1) - centre_final(i-1,1)) /time 

px(i) = (centre_final(i,1)-ct(1,1))*(ct_x(1,1)-ct(1,1))+(centre_final(i,2)-ct(1,2))*(ct_x(1,2)-ct(1,2));
%dy = (centre_final(i,1) - centre_final(i-1,2) /time 
kpx=-0.0000005;
kpy= 0.0000012;
posx(i) = 38 /180 + kpx*px(i); 
posy(i) = 105/180 + kpy*py(i) ;

writePosition(sx,posx(i));
writePosition(sy,posy(i));


%posy

end

writePosition(sx,38.0/180.0);
writePosition(sy,105.0/180.0);
fprintf('arduino and servo\n');

fprintf('DONE');
%Dhanvi
%Added
%Again
