function [criterion_adjacent_axes_satisfied] = check_criterion_adjacent_axes(xi1,xi2,criterion,TOL)

% Obtain "matlab_ws" folder path on the pc
current_path = cd; % pc-grafeio
root_path = string(split(current_path,'matlab_ws/'));
root_path = strcat(root_path(1),'matlab_ws/');

% Add libraries relative to "matlab_ws" folder
geom3d_path_relative_to_matlab_ws = fullfile('geom3d_library','geom3d',filesep); geom3d_library_path = strcat(root_path,geom3d_path_relative_to_matlab_ws); addpath(geom3d_library_path);

% for xi1
[p(:,1), dir(:,1)] = twistaxis(xi1);
twist_line(1,:) = createLine3d(p(1,1), p(2,1), p(3,1), dir(1,1), dir(2,1), dir(3,1));
% for xi2
[p(:,2), dir(:,2)] = twistaxis(xi2);
twist_line(2,:) = createLine3d(p(1,2), p(2,2), p(3,2), dir(1,2), dir(2,2), dir(3,2));

criterion_adjacent_axes_satisfied = false;

% check only for specified criterion of all 3 axes
switch criterion
    case 'parallelism3'
        if ( isParallel3d(dir(:,1)', dir(:,2)', TOL) ) 
            criterion_adjacent_axes_satisfied = true;
        else
            criterion_adjacent_axes_satisfied = false;
        end
    case 'orth_intersect3'
        if ( isIntersecting3d(twist_line(1,:), twist_line(2,:), TOL) ) && ( isPerpendicular3d(dir(:,1)', dir(:,2)', TOL)  )
            criterion_adjacent_axes_satisfied = true;
        else
            criterion_adjacent_axes_satisfied = false;
        end        
    otherwise
        warning('[check_criterion_adjacent_axes]: Criterion specified NOT valid')
end

end