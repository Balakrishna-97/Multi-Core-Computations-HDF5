clear all; % Start fresh, you can comment this if it is too annoying

% Create a parallel pool if none exists
n=feature('numcores');
if isempty(gcp())
parpool('local',n);
end
h5create("data.h5",'/Data',[3 3]);
% n=10;
% Normal computation
tic
for i = 1:n
    Hdf5Operations;
end
tNormal = toc;
a = sprintf("Execution Time for Normal computation is: %f", tNormal);
disp(a)

% Utilize multiple cores to run embarrasingly parallel computations
tic
parfor i = 1:n
    Hdf5Operations;
end
tparallel = toc;

b = sprintf("Execution Time for Embarrasingly parallel computations is: %f", tparallel);
disp(b);

Sp = tNormal / tparallel;
x = sprintf("Speedup is:%f", Sp);
disp(x);
y = sprintf("Average Efficiency is: %f=%d%%", Sp / n, int8((Sp / n) * 100));
disp(y);

delete(gcp('nocreate'));


function Hdf5Operations() 

% Using class notes
matrix = magic(3);
str= '/Data';
h5write("data.h5",str,matrix);
h5disp("data.h5",str);

% Updating 
v = 2*ones(2,1);
h5write("data.h5",str,v,[2 3],[2 1]);
readData = h5read("data.h5",str);
disp(readData);

lastColumn = h5read("data.h5",str,[1 3],[3 1]);
disp(lastColumn);

info = h5info('data.h5');
info.Datasets;

attData = [0 1 2 3];
h5writeatt('data.h5',str,'att1', attData);
att = h5readatt("data.h5",str,'att1');
disp(att);

end

