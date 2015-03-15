% This function depends on all coordinates being in the same common space.
function withinROI = SelectROI(data, roi)
% data - a matrix or cell array of matrices containing the coordinates
%        to be subsetted.
% roi  - a matrix or cell array coordinates that are the basis for subsetting
%        `data`. Use a cell array if the ROI is being built up out of several
%        parts.
  if ~iscell(data)
    data = {data};
  end
  if ~iscell(roi)
    roi = {roi};
	end

  allCoords = [data,roi]';
  w=warning('off','all');
  [dxyz,mxyz] = defineCommonGrid(allCoords);
  warning(w);

  M = length(data);
  N = length(roi);
  withinROI = cell(M,N);
  for i = 1:M
    dijk = bsxfun(@minus,data{i},mxyz);
    dijk = roundto(dijk,dxyz);
    dijk = bsxfun(@rdivide,dijk,dxyz)+1;

    for j = 1:N
      rijk = bsxfun(@minus,roi{j},mxyz);
      rijk = roundto(rijk,dxyz);
      rijk = bsxfun(@rdivide,rijk,dxyz)+1;

      maxijk = max([dijk;rijk]);
      dind = sub2ind(maxijk, dijk(:,1), dijk(:,2), dijk(:,3));
      rind = sub2ind(maxijk, rijk(:,1), rijk(:,2), rijk(:,3));

      z = ismember(dind, rind);
      withinROI{i,j} = z;
    end
  end

end
