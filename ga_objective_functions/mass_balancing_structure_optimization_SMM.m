function MB_star = mass_balancing_structure_optimization_SMM(x)
% x: structure definition-parameterization chromosome
% Chromosome x is uilt considering the smm structure building principles
% defined and the parameters given in the corresponding xacro file used for
% visualization
% x1 = 1st meta link's 2nd pseudo assembly type
% x2,3 = 2nd meta link, 2 pseudos assembly type
% x4-6 = 2nd pseudo of 1st metalink parameters
% x7-9 = 1st pseudo of 2nd metalink parameters
% x10-12 = 2nd pseudo of 2nd metalink parameters
% x13 = 1st dxl assembly pitch parameter
% x14 = 2nd dxl assembly pitch parameter

%% I.  Assign structure parameters values
logical wrong_string_structure;
fixed_active_string_notation = 'x0';
passive_under_string_notation = '21';
%  I.1 Assembly sequence definition
structure(1,:) = fixed_active_string_notation;      % ALWAYS ACTIVE
structure(2,:) = passive_under_string_notation;     % FIXED ASSEMBLY FOR 1st pseudo       
structure(3,:) = x(1);
structure(4,:) = fixed_active_string_notation;      % ALWAYS ACTIVE but now a pitch angle is also given for Dxl assembly
structure(5,:) = x(2);
structure(6,:) = x(3);
structure(7,:) = fixed_active_string_notation;      % ALWAYS ACTIVE but now a pitch angle is also given for Dxl assembly
%  I.2 Assembly parameters
assembly_parameters(1,:) = x(4:6);                  % 2nd pseudo of 1st metalink parameters
assembly_parameters(2,:) = x(7:9);                  % 1st pseudo of 2nd metalink parameters
assembly_parameters(3,:) = x(10:12);                % 2nd pseudo of 2nd metalink parameters
assembly_parameters(4,1) = 0;                       % dummy zero since 1st active joint is fixed
assembly_parameters(4,2) = x(13);                   % 1st dxl assembly pitch parameter
assembly_parameters(4,3) = x(14);                   % 2nd dxl assembly pitch parameter    

%% II. Structure assembly
[xi_ai_ref,xi_pj_ref,g_ai_ref,g_pj_ref,gst0,M_s_com_k_i,g_s_com_k_i,wrong_string_structure] = structure_assembly_3dof(structure,assembly_parameters);

%% III. Compute CoMi of metamorphic links

%% IV. MBS  @ Reference Anatomy

%% V. GDCI  @ Reference Anatomy

%% VI. Anatomy Richness

%% V. Final structure score
end