function [criterion_3_axes_satisfied] = check_criterion_3axes(xi1,xi2,xi3,criterion,TOL)
% Input 3 twist vectors 6x1,criterion:"parallelism3","orth_intersect3"

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
% for xi3
[p(:,3), dir(:,3)] = twistaxis(xi3);
twist_line(3,:) = createLine3d(p(1,3), p(2,3), p(3,3), dir(1,3), dir(2,3), dir(3,3));

criterion_3_axes_satisfied = false;

% check only for specified criterion of all 3 axes
switch criterion
    case 'parallelism3'
        if ( isParallel3d(dir(:,1)', dir(:,2)', TOL) && isParallel3d(dir(:,2)', dir(:,3)', TOL) )
            criterion_3_axes_satisfied = true;
        else
            criterion_3_axes_satisfied = false;
        end
    case 'orth_intersect3'
        if ( isIntersecting3d(twist_line(1,:), twist_line(2,:), TOL) && isIntersecting3d(twist_line(2,:), twist_line(3,:), TOL) ) && ( isPerpendicular3d(dir(:,1)', dir(:,2)', TOL) && isPerpendicular3d(dir(:,2)', dir(:,3)', TOL) )
            criterion_3_axes_satisfied = true;
        else
            criterion_3_axes_satisfied = false;
        end        
    otherwise
        warning('[check_criterion_3axes]: Criterion specified NOT valid')
end

end