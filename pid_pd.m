a = arduino('com4' , 'uno' , 'Libraries' , 'Servo' );
sx = servo(a , 9, 'MinPulseDuration', 544*10^-6, 'MaxPulseDuration', 2400*10^-6); %default 544, 2400
sy = servo(a , 10, 'MinPulseDuration', 544*10^-6, 'MaxPulseDuration', 2400*10^-6); %default 544, 2400
cam = webcam('USB Video Device');
%%
writePosition(sx,48.0/180.0);
writePosition(sy,98.0/180.0);
fprintf('arduino and servo\n');
%%
iter=500;

ct_x=zeros([1 2]);
ct_y=zeros([1 2]);
ct_y=[2.929633514845982e+02,4.335697603309106e+02];
ct_x=[58.528695908894754,2.837177305155370e+02];
ct=[285.0,284.0];	
pics=cell(1,iter);
rgb=cell(1,iter);
centre_final=zeros([iter 2]);
i_cap = [ct_x(1,1)-ct(1,1) ct_x(1,2)-ct(1,2)];
i_cap = i_cap/norm(i_cap);
j_cap = [ct_y(1,1)-ct(1,1) ct_y(1,2)-ct(1,2)];
j_cap = j_cap/norm(j_cap);
fprintf('cam and variables\n');
%%
dx=0;
dy=0;
ix=0;
iy=0;
posx = zeros([iter,1]);
posy = zeros([iter,1]);
px = zeros([iter,1]);
py = zeros([iter,1]);

g%%
preview(cam)

%%
dx=0;
dy=0;
for i = 1.0:1.0:iter
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

%py(i) = (centre_final(i,1)-ct(1,1))*(ct_y(1,1)-ct(1,1))+(centre_final(i,2)-ct(1,2))*(ct_y(1,2)-ct(1,2));
py(i) = sum([centre_final(i,1)-ct(1,1) , centre_final(i,2) - ct(1,2) ].*j_cap);

if i~=1
ds = [centre_final(i,1)-centre_final(i-1,1) centre_final(i,2)-centre_final(i-1,2)];
dx = sum(ds.*i_cap);
dy = sum(ds.*j_cap);

end


%px(i) = (centre_final(i,1)-ct(1,1))*(ct_x(1,1)-ct(1,1))+(centre_final(i,2)-ct(1,2))*(ct_x(1,2)-ct(1,2));
px(i) = sum([centre_final(i,1)-ct(1,1) , centre_final(i,2)-ct(1,2)].*i_cap);
kdx = -0.0000037*246.0973;
kdy = 0.0000034*147.8311;
kpx= -0.0000005*246.0973;
kpy= 0.00000111*147.8311;
%kix= -0.0000000005;
%kiy=  0.0000000010;
ix=ix+px(i);
iy=iy+py(i);
posx(i) = 48 /180 + kpx*px(i) + kdx*dx   ; 
posy(i) = 98/180 + kpy*py(i) + kdy*dy    ;
writePosition(sx,posx(i));
writePosition(sy,posy(i));


%posy

end
%%
writePosition(sx,48.0/180.0);
writePosition(sy,98.0/180.0);
fprintf('arduino and servo\n');

fprintf('DONE');