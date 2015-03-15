function runIterativeLasso(jobdir)
	if nargin == 0
		params = loadjson('params.json')
		jobdir = params.expdir;
	else
		params = loadjson(fullfile(jobdir,'params.json'));
	end

	%% Load the data
	[~,basename] = fileparts(params.data);
	subjnum = sscanf(basename,'jlp%d');
	load(params.data, 'X');
	load(params.metadata);
	xyz_tlrc = {metadata.xyz_tlrc};
	metadata = metadata(subjnum);
	target = params.target;
	nMRIrun = size(metadata.mriRuns,2);

  %% Subset data by TR
  if isfield(params,'TR')
    assert(params.TR <= 5)
    assert(params.TR >= 0)
    if params.TR > 0
      TRs = params.TR:5:size(X,1);
    else
      TRs = 1:size(X,1);
    end
    X = X(TRs,:);
  end

	disp(metadata)
	y = double(metadata.(target));
	ncv = size(metadata.CVBLOCKS,2);
	CVB = metadata.CVBLOCKS;

	% zscore by run
	Xc = mat2cell(X,repmat(nMRIrun,size(X,1)/nMRIrun,1),size(X,2));
	X = cell2mat(cellfun(@zscore,Xc,'unif',0));

% 	X = X(filter,:);
% 	y = y(filter);
% 	CVB = CVB(filter,:);

	%% Handle ROIs
	if isfield(params,'ROI')
		ROIs = LoadROISet(params.ROI);
		withinROI = SelectROI(xyz_tlrc,{ROIs.coords});
		[nsubj,nroi] = size(withinROI);
		ROISelection = any(cell2mat(withinROI(subjnum,:)),2);
	%	SubjByROI(nsubj,nroi) = struct();
	%	for i=1:nsubj
	%		for j=1:nroi
	%			SubjByROI(i,j).subject = i;
	%			SubjByROI(i,j).name = ROIs(j).name;
	%			SubjByROI(i,j).withinROI = withinROI{i,j};
	%		end
	%	end
		if isfield(params,'invertROI') && params.invertROI
			X = X(:,~ROISelection);
		else
			X = X(:, ROISelection);
		end
	end

	% Remove outliers
	size(X)
	[X, retain] = removeOutliers(X);
	size(X)

	if ~all(retain.stimuli)
		y = y(retain.stimuli);
		CVB = CVB(retain.stimuli,:);
	end

	if ~all(retain.voxels)
		ijk = ijk(retain.voxels,:);
	end

	%% Run Iterative Lasso
	[finalModel,iterModels,finalTune,iterTune] = iterativelasso(X,y,CVB,'ExpDir',jobdir);

	%% Save Results to Disk
	save('VoxelAndItemSelection.mat','ROISelection','retain');
	if ~isempty(fieldnames(finalModel))
    save('finalModel.mat','finalModel');
    save('finalTune.mat','finalTune');
		%write_results(fullfile(jobdir,'final'),finalModel,finalTune);
	end
  save('iterModels.mat','iterModels');
  save('iterTune.mat','iterTune');
	%write_results(fullfile(jobdir,'iterations'),iterModels,iterTune);
end
