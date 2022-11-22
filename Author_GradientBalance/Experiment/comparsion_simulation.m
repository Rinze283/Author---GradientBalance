
clearvars -except I_cb_blur I_cb_noise I_cb_perspective I_gr_blur I_gr_noise I_gr_perspective
close all

%% generate and load the generated simulation images
[p_cb_init,p_cb_true]=generateCheckerboard(100);
[p_gr_init,p_gr_true]=generateGrid(100);
currPath = fileparts(mfilename('fullpath'));
fsep = filesep;
pathArray = strfind(currPath,fsep);
rootPath = currPath(1:pathArray(length(pathArray))-1);
load(strcat(rootPath,'\Data\SimulationImages\I_cb_blur'));
load(strcat(rootPath,'\Data\SimulationImages\I_cb_noise'));
load(strcat(rootPath,'\Data\SimulationImages\I_cb_perspective'));
load(strcat(rootPath,'\Data\SimulationImages\I_gr_blur'));
load(strcat(rootPath,'\Data\SimulationImages\I_gr_noise'));
load(strcat(rootPath,'\Data\SimulationImages\I_gr_perspective'));

%% set the necessary parameters
num_iters = 5;
sigma=3.5;
r=2;
blur = 0.0:0.5:5;
noise = eps:0.005:0.05+eps;
zenith = eps:5:60+eps;

%% run simulation [OpenCV Matlab GradientBalance]
refine_1=@refine_OpenCV; 
refine_2=@refine_Matlab;
refine_3=@refine_GradientBalance;
refine_4=@refine_Hessian;

error_cb_blur=runSimulationTest('blur checkerboard',...
    I_cb_blur,p_cb_init,p_cb_true,num_iters,sigma,r,refine_1,refine_2,refine_3);

error_cb_noise=runSimulationTest('noise checkerboard',...
    I_cb_noise,p_cb_init,p_cb_true,num_iters,sigma,r,refine_1,refine_2,refine_3);

error_cb_perspective=runSimulationTest('perspective checkerboard',...
    I_cb_perspective,p_cb_init,p_cb_true,num_iters,sigma,r,refine_1,refine_2,refine_3);

error_gr_blur=runSimulationTest('blur checkerboard',...
    I_gr_blur,p_gr_init,p_gr_true,num_iters,sigma,r,refine_1,refine_4,refine_3);

error_gr_noise=runSimulationTest('noise checkerboard',...
    I_gr_noise,p_gr_init,p_gr_true,num_iters,sigma,r,refine_1,refine_4,refine_3);

error_gr_perspective=runSimulationTest('perspective checkerboard',...
    I_gr_perspective,p_gr_init,p_gr_true,num_iters,sigma,r,refine_1,refine_4,refine_3);

%% show results
showResults(blur,noise,zenith,...
    error_cb_blur,error_cb_noise,error_cb_perspective,...
    error_gr_blur,error_gr_noise,error_gr_perspective);










%% read simulated image and compute the errors using different methods
function finalError=runSimulationTest(testName,I_cell,p_init,p_true,num_iters,sigma,r,refine_1,refine_2,refine_3)
num_levels=size(I_cell,1);
num_repeats=size(I_cell,2);
error=zeros(num_levels,num_repeats,3);

for lvl=1:num_levels
    for rep = 1 : num_repeats
        fprintf('%s error [%d]: %d/%d\r',testName, lvl, rep, num_repeats);
        
        I=I_cell{lvl,rep};
        
        p_refined = refine_1(I,p_init,r,num_iters,sigma);
        error(lvl,rep,1) = getError(p_refined,p_true);
        p_refined = refine_2(I,p_init,r,num_iters,sigma);
        error(lvl,rep,2)  = getError(p_refined,p_true);
        p_refined = refine_3(I,p_init,r,num_iters,sigma);
        error(lvl,rep,3)  = getError(p_refined,p_true);
    end
    close
    figure('Name',strcat(testName,': ',num2str(lvl)))
    imshow(I,[]);
end

finalError=getResult(error);
end

%% show final results
function showResults(blur,noise,zenith,error_cb_blur,error_cb_noise,error_cb_perspective,...
    error_gr_blur,error_gr_noise,error_gr_perspective)

legend_data = {'OpenCV', 'Matlab', 'GB'};
lineStr={ 'bs-', 'rs-', 'gs-'};

%blur test: checkerboard
x_variable=blur;
y_max=1;
xlabelStr={'Gaussian Blur \sigma ','\sigma = 1','\sigma = 3','\sigma = 5'};
drawResult(error_cb_blur,x_variable,y_max,xlabelStr,lineStr,legend_data);

%noise test: checkerboard
x_variable=noise;
y_max=0.15;
xlabelStr={'Gaussian Noise \sigma_n','\sigma_n = 0.01','\sigma_n = 0.03','\sigma_n = 0.05'};
lineStr={ 'bs-', 'rs-', 'gs-'};
drawResult(error_cb_noise,x_variable,y_max,xlabelStr,lineStr,legend_data);

%perspective test: checkerboard
x_variable=zenith;
y_max=0.06;
xlabelStr={'Zenith Angle \phi','\phi = 0^\circ','\phi = 30^\circ','\phi = 60^\circ'};
lineStr={ 'bs-', 'rs-', 'gs-'};
drawResult(error_cb_perspective,x_variable,y_max,xlabelStr,lineStr,legend_data);


legend_data = {'OpenCV', 'Chen et al', 'GB'};
lineStr={ 'bx-', 'mx-', 'gx-'};

%blur test: grid
x_variable=blur;
y_max=4;
xlabelStr={'Gaussian Blur \sigma ','\sigma = 1','\sigma = 3','\sigma = 5'};

drawResult(error_gr_blur,x_variable,y_max,xlabelStr,lineStr,legend_data);

%noise test: grid
x_variable=noise;
y_max=1;
xlabelStr={'Gaussian Noise \sigma_n','\sigma_n = 0.01','\sigma_n = 0.03','\sigma_n = 0.05'};

drawResult(error_gr_noise,x_variable,y_max,xlabelStr,lineStr,legend_data);

%perspective test: grid
x_variable=zenith;
y_max=1;
xlabelStr={'Zenith Angle \phi','\phi = 0^\circ','\phi = 30^\circ','\phi = 60^\circ'};

drawResult(error_gr_perspective,x_variable,y_max,xlabelStr,lineStr,legend_data);
end
%% draw line chart
function drawResult(errorData,x_variable,y_max,xlabelStr,lineStr,legend_data)
figure
%draw line chart, using the xlabelStr{1} and lineStr
plot(x_variable, errorData(:,1), lineStr{1},'MarkerSize',10, 'LineWidth', 1.5);  hold on;
plot(x_variable, errorData(:,2), lineStr{2},'MarkerSize',10, 'LineWidth', 1.5);
plot(x_variable, errorData(:,3), lineStr{3},'MarkerSize',10, 'LineWidth', 1.5);
axis([0 x_variable(end) 0.0 y_max]);
xlabel(xlabelStr{1});
ylabel('Mean Localization Error');
set(gca, 'color', 'w'); set(gcf, 'color', 'w');
legend(legend_data{:}, 'Location', 'northwest');
set(gca, 'FontSize', 20);
grid on
grid minor;
end