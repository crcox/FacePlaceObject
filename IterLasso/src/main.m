addpath('~/src/iterativelasso') % Order matters!!!
addpath('src/')
addpath('IterLasso/src/')

%% Set Home
home = fullfile('IterLasso/test');

%% Find Job dirs
jobdirs = dir(home);
jobdirs = jobdirs([jobdirs.isdir]);
jobdirs = jobdirs(cellfun(@(x) ~isempty(regexp(x,'^[^\.][0-9]+$', 'once')), {jobdirs.name}));

%% Iterate over Job dirs
n = length(jobdirs);
shareddir = fullfile(home,'shared');
addpath(shareddir);
for i=1:n
	jobdir = fullfile(home,jobdirs(i).name);
	addpath(jobdir);
	runIterativeLasso(jobdir);
	rmpath(jobdir);
end
rmpath(shareddir);

rmpath('IterLasso/src/')
rmpath('src/')
rmpath('~/src/iterativelasso') % Order matters!!!		