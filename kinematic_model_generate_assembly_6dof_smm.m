% This code...

% HOW TO EXECUTE


% Include libraries
addpath('/home/nikos/matlab_ws/screw_kinematics_library/screws')
addpath('/home/nikos/matlab_ws/screw_kinematics_library/util')
addpath('/home/nikos/matlab_ws/screw_dynamics')

addpath('/home/nikos/matlab_ws/Kinematic_Model_Assembly_SMM/building_functions')
addpath('/home/nikos/matlab_ws/Kinematic_Model_Assembly_SMM/synthetic_joints_tfs')
addpath('/home/nikos/matlab_ws/Kinematic_Model_Assembly_SMM/calculateFunctions')
addpath('/home/nikos/matlab_ws/Kinematic_Model_Assembly_SMM/ga_objective_functions/subroutines_executed_in_objective_fn')

clear;
close all;

%% Only visualization for code evaluation
% Ref structure robot - All data must be calculated for reference structure
robotURDFfile_ref_anat = '/home/nikos/PhD/projects/Parametric_Simulation_Model_SMM/xacros/generated_urdf_from_xacros_here/test_6dof_ref_anat.urdf';
% Test robot structure
[RefRobot,RefFig,RefConfig,NumDoF] = ImportRobotRefAnatomyModel(robotURDFfile_ref_anat);

robotURDFfile_test_anat = '/home/nikos/PhD/projects/Parametric_Simulation_Model_SMM/xacros/generated_urdf_from_xacros_here/test_6dof_test_anat.urdf';

[TestRobot,TestFig,TestConfig,~] = ImportRobotRefAnatomyModel(robotURDFfile_test_anat);
% NEXT ARE ONLY FOR CODE VERIFICATION: WILL BE IMPLEMENTED IN SEPARATE
% FUNCTIONS!

% 6dof structure and assembly parameters assignment - these will be given
% by ga
logical wrong_string_structure;
fixed_active_string_notation = 'x0';
no_passive_string_notation = 'x9';    % -> in ga Int Value:1
passive_under_string_notation = '21'; % -> in ga Int Value:2
passive_back_string_notation = '31';  % -> in ga Int Value:3

structure(1,:) = fixed_active_string_notation;  % default
structure(2,:) = passive_under_string_notation; % default
structure(3,:) = no_passive_string_notation;
structure(4,:) = fixed_active_string_notation;  % default
structure(5,:) = passive_under_string_notation;
structure(6,:) = no_passive_string_notation;
structure(7,:) = fixed_active_string_notation;  % default
structure(8,:) = passive_back_string_notation;
structure(9,:) = passive_back_string_notation;
structure(10,:) = fixed_active_string_notation; % default
structure(11,:) = passive_under_string_notation;
structure(12,:) = passive_back_string_notation;
structure(13,:) = fixed_active_string_notation; % default
structure(14,:) = passive_under_string_notation;
structure(15,:) = passive_back_string_notation;
structure(16,:) = fixed_active_string_notation; % default 
assembly_parameters(1,:) = [0,0,1.5708]';                  
assembly_parameters(2,:) = [-0.035,0.005,1.5708]';                  
assembly_parameters(3,:) = [0.0025,0,-1.5708]';                
assembly_parameters(4,:) = [0.0058,0,0.7854]';               
assembly_parameters(5,:) = [0,0,-1.5708]';               
assembly_parameters(6,:) = [0,0.02,0.7854]';               
assembly_parameters(7,:) = [0,0,-1.5708]';                
assembly_parameters(8,:) = [-0.05,0,1.5708]';                
assembly_parameters(9,:) = [0,0,0.7854]';                
assembly_parameters(10,1) = 0;                   % dummy zero since 1st active joint is fixed
assembly_parameters(10,2) = 1.5708;                   % 1st dxl assembly pitch parameter
assembly_parameters(10,3) = 0;                   % 2nd dxl assembly pitch parameter
assembly_parameters(11,1) = 0;                   % 3rd dxl assembly pitch parameter
assembly_parameters(11,2) = 1.5708;                   % 4th dxl assembly pitch parameter
assembly_parameters(11,3) = 0;                   % 5th dxl assembly pitch parameter
% 6dof structure assembly
[xi_ai_ref,xi_pj_ref,g_ai_ref,g_pj_ref,gst0,M_s_com_k_i,g_s_com_k_i,wrong_string_structure] = structure_assembly_6dof(structure,assembly_parameters);
figure(RefFig); xi_a2_graph = drawtwist(xi_ai_ref(:,2)); hold on; xi_a3_graph = drawtwist(xi_ai_ref(:,3)); hold on; xi_a4_graph = drawtwist(xi_ai_ref(:,4)); hold on; xi_a5_graph = drawtwist(xi_ai_ref(:,5)); hold on; xi_a6_graph = drawtwist(xi_ai_ref(:,6)); hold on;
figure(RefFig); 
for j_cnt=1:size(xi_pj_ref,2) 
    xi_pj_graph = drawtwist(xi_pj_ref(:,j_cnt)); hold on; 
end

% 1.POE FORWARD KINEMATICS(works fine)
% SET configuration and anatomy of assembled structure => must agree with
% xacro file that built urdf
qa = [0 0 0 0 0 0]';
qp_xacro_user_given = [-1.5708 -0.5 0.7854 -1 -0.7854 1.15 0.85 1.5708 -0.45 -1.5708]';
qp_structure_dependent = calculate_transformed_anatomy_vector(structure,'6dof',qp_xacro_user_given);

figure(TestFig); show(TestRobot,qa); hold on;

%[TestFig] = visualize_robot_urdf(robotURDFfile,qa);
[g_ai,g_pj,xi_ai_anat,Pi,gst] = calculateForwardKinematicsPOE(structure,'6dof',xi_ai_ref,xi_pj_ref,qa,qp_structure_dependent,g_ai_ref,g_pj_ref,gst0);
figure(TestFig); drawframe(g_ai(:,:,1),0.15); hold on; drawframe(g_ai(:,:,2),0.15); hold on; drawframe(g_ai(:,:,3),0.15);  hold on; hold on; xi_a2_graph = drawtwist(xi_ai_anat(:,2)); hold on; xi_a3_graph = drawtwist(xi_ai_anat(:,3)); hold on;
figure(TestFig); drawframe(g_ai(:,:,4),0.15); hold on; drawframe(g_ai(:,:,5),0.15); hold on; drawframe(g_ai(:,:,6),0.15); drawframe(gst,0.15); hold on; hold on; xi_a4_graph = drawtwist(xi_ai_anat(:,4)); hold on; xi_a5_graph = drawtwist(xi_ai_anat(:,5)); hold on; xi_a6_graph = drawtwist(xi_ai_anat(:,6)); hold on;
figure(TestFig); drawframe(g_pj(:,:,1),0.15); hold on; drawframe(g_pj(:,:,2),0.15); hold on;  drawframe(g_pj(:,:,3),0.15); hold on; drawframe(g_pj(:,:,4),0.15); hold on;

% 2. EXTRACT INERTIAS FOR GIVEN STRUCTURE & ANATOMY
[gst_anat,xi_ai_anat,M_s_com_k_i_anat,g_s_com_k_i_anat] = calculateCoM_ki_s_structure_anatomy_6dof(structure,assembly_parameters,qp_structure_dependent,xi_pj_ref,TestFig);
[g_s_link_as_anat,M_s_link_as_anat] = calculateCoMmetalinks(M_s_com_k_i_anat,g_s_com_k_i_anat);

% 3. CALCULATE MBS FOR 6DOF STRUCTURE & ANATOMY
[MBS] = calculateMBS_6dof(structure,assembly_parameters,xi_ai_ref,xi_pj_ref,qp_structure_dependent,TestFig);

% 4. Now that metalinks COM were found the Metalink Inertia Matrix|Body
% frame is found
[M_b_link_as2] = calculateMetalinkInertiaMatrixBody(g_s_link_as_anat,M_s_link_as_anat); % this is the good one

% 5.CONSTRUCT LINK BODY JACOBIANS ANG GENERALIZED INERTIA MATRIX
[J_b_sli2] = calculateCoM_BodyJacobians_for_anat_6dof(xi_ai_anat, qa, g_s_link_as_anat );  % this is the good one
[M_b2] = calculateGIM(J_b_sli2,M_b_link_as2);  % this is the good one
M_b_matlab = massMatrix(TestRobot,qa);