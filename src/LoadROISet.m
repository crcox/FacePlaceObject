function ROI = LoadROISet(setname)
  if nargin < 1 || ~any(strcmp(setname,{'face','place','object'}))
    error('Valid set names: face, place, object');
  end
  view = 'tlrc';
  dtype = 'afni';
  res='funcres';

  roidir = fullfile('roi',setname,dtype,view,res,'coords');
  allfiles = dir(roidir);
  files = allfiles(~[allfiles.isdir]);
  z = cellfun(@(x) isempty(regexp(x,'[a-zA-Z]+.xyz')), {files.name});
  files(z) = [];

  n = length(files);
  ROI(1,n) = struct();
  for i = 1:n
    tmp = strsplit(files(i).name,'.');
    name = tmp{1};
    ext = tmp{2};

    xyz = load(fullfile(roidir, files(i).name));
    ROI(i).name = name;
    ROI(i).space = ext;
    ROI(i).coords= xyz(:,1:3);
  end
end
