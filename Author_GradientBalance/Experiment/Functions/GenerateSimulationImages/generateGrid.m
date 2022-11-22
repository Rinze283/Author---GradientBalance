function [pt_init,pt_true]=generateGridCrosses(halfEdgeSize)

I_origin=zeros(8*halfEdgeSize,8*halfEdgeSize);
I_origin(4*halfEdgeSize-1:4*halfEdgeSize+2,:)=1;
I_origin(:,4*halfEdgeSize-1:4*halfEdgeSize+2)=1;

pt_init = [halfEdgeSize halfEdgeSize;   halfEdgeSize+1 halfEdgeSize;
          halfEdgeSize halfEdgeSize+1; halfEdgeSize+1 halfEdgeSize+1];
pt_true=[halfEdgeSize+0.5,halfEdgeSize+0.5];

blur = 0.0:0.5:5;
noise = eps:0.005:0.05+eps;
theta = eps:5:60+eps;
phi = 0:360;
fixedBlur=1;
fixedNoise=0.01;
num_trials = 100;

currPath = fileparts(mfilename('fullpath'));
fsep = filesep;
pathArray = strfind(currPath,fsep);
rootPath = currPath(1:pathArray(length(pathArray)-2)-1);
%% blur
filePath=strcat(rootPath,'\Data\SimulationImages\I_gr_blur.mat');
if(~exist(filePath,'file'))
    I_gr_blur=cell(length(blur),num_trials);
    for k=1:length(blur)
        for num = 1 : num_trials
            fprintf('genetate blur grid[%d]: %d/%d\r',k, num, num_trials);
            
            t= (rand(1)*(theta(end)-theta(1))+theta(1))/180*pi;
            p= (rand(1)*(phi(end)-phi(1))+phi(1))/180*pi;
            n=fixedNoise;
            b=blur(k);
            
            I=imProcessing(I_origin,p,t,n,b,1);
            I_gr_blur{k,num}=I;
        end
    end
    save(filePath,'I_gr_blur');
end
%% test noise
filePath=strcat(rootPath,'\Data\SimulationImages\I_gr_noise.mat');
if(~exist(filePath,'file'))
    I_gr_noise=cell(length(noise),num_trials);
    for k=1:length(noise)
        for num = 1 : num_trials
            fprintf('genetate noise grid[%d]: %d/%d\r',k, num, num_trials);
            
            t= (rand(1)*(theta(end)-theta(1))+theta(1))/180*pi;
            p= (rand(1)*(phi(end)-phi(1))+phi(1))/180*pi;
            n=noise(k);
            b=fixedBlur;
            
            I=imProcessing(I_origin,p,t,n,b,1);
            I_gr_noise{k,num}=I;
        end
    end
    save(filePath,'I_gr_noise');
end
%% test perspective
filePath=strcat(rootPath,'\Data\SimulationImages\I_gr_perspective.mat');
if(~exist(filePath,'file'))
    I_gr_perspective=cell(length(theta),num_trials);
    for k=1:length(theta)
        for num = 1 : num_trials
            fprintf('genetate perspective grid[%d]: %d/%d\r',k, num, num_trials);
            
            t= theta(k);
            p=(rand(1)*(phi(end)-phi(1))+phi(1))/180*pi;
            n=fixedNoise;
            b=fixedBlur;
            
            I=imProcessing(I_origin,p,t,n,b,1);
            I_gr_perspective{k,num}=I;
        end
    end
    save(filePath,'I_gr_perspective');
end

end