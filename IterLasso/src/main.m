%% Add locations to matlab path
% This is my local copy of the iterativelasso repository for GitHub.
addpath('~/src/iterativelasso')
% This is project specific code, that is not specifically iterative lasso
% related (i.e., I might also use it for SOS Lasso analysis).
addpath('src/') 
% This is where I put files like runIterativeLasso.m that is project
% specific. It's important to add this to the path LAST---otherwise Matlab
% will find the version of runIterativeLasso that is currently in
% ~/src/iterativelasso first.
addpath('IterLasso/src/')

%% Set Home
% What I am calling the home directory is where you will specify jobs. Each
% job will get a folder, and each folder will contain (at least) a
% params.json.
home = fullfile('IterLasso/test');
% The shared directory is where you should put any information that all
% jobs will need. So, if all jobs are going to reference the same data, you
% can just put it here, once, and all jobs will see it.
shareddir = fullfile(home,'shared');

%% Find Job dirs
% This bit looks in the home directory (specified above) to find all
% folders that are named as numbers. This means a job directory is a folder
% in the home directory that is named something like 021 or 21 or 1.
jobdirs = dir(home);
jobdirs = jobdirs([jobdirs.isdir]);
jobdirs = jobdirs(cellfun(@(x) ~isempty(regexp(x,'^[^\.][0-9]+$', 'once')), {jobdirs.name}));

%% Iterate over Job dirs
% Now we have everything we need to iterate over the jobs in a loop.
% Essentially, this is simulating how jobs would be run on a distributed
% cluster.
% Important Note!! In this version of runIterativeLasso, I changed how data
% will be written out. But the way it was before remains in the comments.
% The relevant bits are at the very bottom of runIterativeLasso.
n = length(jobdirs);
addpath(shareddir);
for i=1:n
	jobdir = fullfile(home,jobdirs(i).name);
	addpath(jobdir);
	runIterativeLasso(jobdir);
	rmpath(jobdir);
end

%% Cleanup
% Once done, we can clean up the matlab path.
rmpath(shareddir);
rmpath('IterLasso/src/')
rmpath('src/')
rmpath('~/src/iterativelasso')	