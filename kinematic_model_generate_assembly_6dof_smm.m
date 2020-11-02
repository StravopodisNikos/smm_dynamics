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
structure(3,:) = passive_back_string_notation;
structure(4,:) = fixed_active_string_notation;  % default
structure(5,:) = passive_back_string_notation;
structure(6,:) = passive_under_string_notation;
structure(7,:) = fixed_active_string_notation;  % default
structure(8,:) = passive_back_string_notation;
structure(9,:) = passive_back_string_notation;
structure(10,:) = fixed_active_string_notation; % default
structure(11,:) = passive_under_string_notation;
structure(12,:) = passive_back_string_notation;
structure(13,:) = fixed_active_string_notation; % default
structure(14,:) = passive_back_string_notation;
structure(15,:) = passive_under_string_notation;
structure(16,:) = fixed_active_string_notation; % default 
assembly_parameters(1,:) = [0,-0.03,1.5708]';                  
assembly_parameters(2,:) = [-0.035,0,1.5708]';                  
assembly_parameters(3,:) = [0,0,-1.5708]';                
assembly_parameters(4,:) = [-0.0058,0,0]';               
assembly_parameters(5,:) = [0,0,-1.5708]';               
assembly_parameters(6,:) = [0,0.02,0.7854]';               
assembly_parameters(7,:) = [0,0,-1.5708]';                
assembly_parameters(8,:) = [0.05,0,-1.5708]';                
assembly_parameters(9,:) = [0,0.005,-0.7854]';                
assembly_parameters(10,1) = 0;                   % dummy zero since 1st active joint is fixed
assembly_parameters(10,2) = 1.5708;                   % 1st dxl assembly pitch parameter
assembly_parameters(10,3) = 0;                   % 2nd dxl assembly pitch parameter
assembly_parameters(11,1) = 1.5708;                   % 3rd dxl assembly pitch parameter
assembly_parameters(11,2) = 0;                   % 4th dxl assembly pitch parameter
assembly_parameters(11,3) = 1.5708;                   % 5th dxl assembly pitch parameter
% 6dof structure assembly
[xi_ai_ref,xi_pj_ref,g_ai_ref,g_pj_ref,gst0,M_s_com_k_i,g_s_com_k_i,wrong_string_structure] = structure_assembly_6dof(structure,assembly_parameters,RefFig);

% 1.POE FORWARD KINEMATICS(works fine)
% SET configuration and anatomy of assembled structure => must agree with
% xacro file that built urdf
qa = [0 0 0 0 0 0]'; qp = [1.5708 0 0 0 0 0 0 0 0 0]';
figure(TestFig); show(TestRobot,qa); hold on;
%[TestFig] = visualize_robot_urdf(robotURDFfile,qa);
[g_ai,g_pj,Jsp,Pi,gst] = calculateForwardKinematicsPOE(structure,xi_ai_ref,xi_pj_ref,qa,qp,g_ai_ref,g_pj_ref,gst0);
figure(TestFig); drawframe(g_ai(:,:,1),0.15); hold on; drawframe(g_ai(:,:,2),0.15); hold on; drawframe(g_ai(:,:,3),0.15); drawframe(gst,0.15); hold on; hold on; xi_a2_graph = drawtwist(Jsp(:,2)); hold on; xi_a3_graph = drawtwist(Jsp(:,3)); hold on;
figure(TestFig); drawframe(g_pj(:,:,1),0.15); hold on; drawframe(g_pj(:,:,2),0.15); hold on;  drawframe(g_pj(:,:,3),0.15); hold on; drawframe(g_pj(:,:,4),0.15); hold on;
