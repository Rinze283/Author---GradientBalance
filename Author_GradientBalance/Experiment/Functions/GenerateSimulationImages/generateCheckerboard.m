function [pt_init,pt_true]=generateCheckerboard(halfEdgeSize)

I_origin=zeros(2*halfEdgeSize,2*halfEdgeSize);
I_origin(1:halfEdgeSize,1:halfEdgeSize)=1;
I_origin(halfEdgeSize+1:end,halfEdgeSize+1:end)=1;

pt_init = [halfEdgeSize halfEdgeSize;   halfEdgeSize+1 halfEdgeSize;
    halfEdgeSize halfEdgeSize+1; halfEdgeSize+1 halfEdgeSize+1];
pt_true=[halfEdgeSize+0.5,halfEdgeSize+0.5];

blur = 0.0:0.5:5;
noise = eps:0.005:0.05+eps;
zen = eps:5:60+eps;
azi = 0:360;
fixedBlur=1;
fixedNoise=0.01;
num_trials = 100;

currPath = fileparts(mfilename('fullpath'));
fsep = filesep;
pathArray = strfind(currPath,fsep);
rootPath = currPath(1:pathArray(length(pathArray)-2)-1);
%% blur
filePath=strcat(rootPath,'\Data\SimulationImages\I_cb_blur.mat');
if(~exist(filePath,'file'))
    I_cb_blur=cell(length(blur),num_trials);
    for k=1:length(blur)
        for num = 1 : num_trials
            fprintf('genetate blur checkerboard[%d]: %d/%d\r',k, num, num_trials);
            
            t= (rand(1)*(zen(end)-zen(1))+zen(1))/180*pi;
            p= (rand(1)*(azi(end)-azi(1))+azi(1))/180*pi;
            n=fixedNoise;
            b=blur(k);
            
            I=imProcessing(I_origin,p,t,n,b,0);
            I_cb_blur{k,num}=I;
        end
    end
    save(filePath,'I_cb_blur');
end
%% test noise
filePath=strcat(rootPath,'\Data\SimulationImages\I_cb_noise.mat');
if(~exist(filePath,'file'))
    I_cb_noise=cell(length(noise),num_trials);
    for k=1:length(noise)
        for num = 1 : num_trials
            fprintf('genetate noise checkerboard[%d]: %d/%d\r',k, num, num_trials);
            
            t= (rand(1)*(zen(end)-zen(1))+zen(1))/180*pi;
            p= (rand(1)*(azi(end)-azi(1))+azi(1))/180*pi;
            n=noise(k);
            b=fixedBlur;
            
            I=imProcessing(I_origin,p,t,n,b,0);
            I_cb_noise{k,num}=I;
        end
    end
    save(filePath,'I_cb_noise');
end
%% test perspective
filePath=strcat(rootPath,'\Data\SimulationImages\I_cb_perspective.mat');
if(~exist(filePath,'file'))
    I_cb_perspective=cell(length(zen),num_trials);
    for k=1:length(zen)
        for num = 1 : num_trials
            fprintf('genetate perspective checkerboard[%d]: %d/%d\r',k, num, num_trials);
            
            t= zen(k);
            p=(rand(1)*(azi(end)-azi(1))+azi(1))/180*pi;
            n=fixedNoise;
            b=fixedBlur;
            
            I=imProcessing(I_origin,p,t,n,b,0);
            I_cb_perspective{k,num}=I;
        end
    end
    save(filePath,'I_cb_perspective');
end

end