function [F_i_rich] = calculateExhaustiveAnatomies_for_MBS(MBS_ref,xi_ai_ref,xi_pj_ref,g_s_link_as_ref,g_ai_ref,g_pj_ref,gst0,M_s_link_as_ref)
% Calculates all possible anatomies given the total number of pseudos and
% the known pseudo step angle. Evaluates the richness of a structure, w.r.t the Mass Balancing Score

% Thanks to Jos (10584) for allcomb.m code.
% Downloaded from MAthWorks File Exchange @ : https://www.mathworks.com/matlabcentral/fileexchange/10064-allcomb-varargin

pseudo_step_angle = deg2rad(15);
pseudo_limit_angle = pi/2;
nPseudo = size(xi_pj_ref,2);
% OLA LATHOS

%% Build anatomies in a (n x nPseudo) array, where n is the product of the elements of the pseudojoint angle  vectors(Cartesian Product)
for pseudo_cnt=1:nPseudo
    pseudo_angle_cnt = 0; % for each pseudojoint, the counter must count all possible angles, so before for must initialize to 0
    for pseudo_angle = -pseudo_limit_angle:pseudo_step_angle:pseudo_limit_angle
            pseudo_angle_cnt = pseudo_angle_cnt +1;
            % Give all possible values to each pseudo
            qp(pseudo_angle_cnt,pseudo_cnt) = pseudo_angle;  
    end
end

all_possible_anatomies = allcomb(qp(:,1),qp(:,2),qp(:,3));  % each row of the array is a possible anatomy
total_possible_anatomies = size(all_possible_anatomies,1);  

%% Evaluate each anatomy
RELATIVE_RICHNESS = 0;      % This is measure for the structure evaluated, so must be initialized before exhaustive evaluation

for anatomy_cnt=1:total_possible_anatomies
    
        evaluated_anatomy = all_possible_anatomies(anatomy_cnt,:); % pick the row of array
        
        MBS_i(anatomy_cnt) = calculateMBS_no_graph(structure,xi_ai_ref,xi_pj_ref,g_s_link_as_ref,g_ai_ref,g_pj_ref,gst0,M_s_link_as_ref,evaluated_anatomy);
        
        if MBS_i(anatomy_cnt) < MBS_ref
            RELATIVE_RICHNESS = RELATIVE_RICHNESS + 1;
        end

end

%% Compute metric
F_i_rich = RELATIVE_RICHNESS / total_possible_anatomies;

end