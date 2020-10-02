% Include libraries
addpath('/home/nikos/matlab_ws/screw_kinematics_library/screws')
addpath('/home/nikos/matlab_ws/screw_kinematics_library/util')
addpath('/home/nikos/matlab_ws/screw_dynamics')

addpath('/home/nikos/matlab_ws/Kinematic_Model_Assembly_SMM/building_functions')
addpath('/home/nikos/matlab_ws/Kinematic_Model_Assembly_SMM/synthetic_joints_tfs')

clear;
close all;

%% Only visualization for code evaluation
% test robot
robotURDFfile = '/home/nikos/PhD/projects/Parametric_Simulation_Model_SMM/xacros/generated_urdf_from_xacros_here/conditioned_parameterized_SMM_assembly.urdf';

[RefRobot,RefFig,RefConfig,NumDoF] = ImportRobotRefAnatomyModel(robotURDFfile);

%% Define smm structure string (in optimization it is ga generated!)
logical wrong_string_structure;
fixed_active_string_notation = 'x0';
no_passive_string_notation = 'x9';
passive_under_string_notation = '21';
passive_back_string_notation = '31';

structure(1,:) = fixed_active_string_notation;
structure(2,:) = passive_under_string_notation;
structure(3,:) = passive_back_string_notation;
% structure(4,:) = '0';
% structure(5,:) = '0';
% structure(6,:) = '0';
% structure(7,:) = '0';

%% Build structure using the rules specified
wrong_string_structure = false;                     % assumes initial string is correct
if ~(strcmp(structure(1,:),fixed_active_string_notation)) % if 1st string element is NOT active
    wrong_string_structure = true;
    warning('[SMM STRUCTURE ASSEMBLY]: 1st string element is not declared ACTIVE')
else
    %% Structure after 1st active joint is correct
    
    %% START - BUILD base_link
    
    [xi_a1_0,g_s_m_i1_new] = build_base_link();
    figure(RefFig); 
    xi_graph = drawtwist(xi_a1_0); hold on;
    drawframe(g_s_m_i1_new,0.15); hold on;
    %% END - BUILD base_link 
    
    
    %% START - Switch statement for 1st meta link follows-Always 2 sring elements are checked!
    % For 1st meta link, 2 conditions exist:
    switch structure(2,:) % first switch for 1st element
        case no_passive_string_notation % 1st case is that no pseudo exists in 2nd string element
            % nested switch for 2nd element
             switch structure(3,:)
                 case passive_under_string_notation % case 2.1.1 ->  since 1st element is empty then MUST exist pseudo connected with under base
                 
                     [synthetic_tform,g_s_m_i1_new] = add_synthetic_joint_tf('synthetic1',g_s_m_i1_new);
                     [xi_pj_0,g_s_m_i1_new] = build_pseudomodule(g_s_m_i1_new);
                     figure(RefFig); xi_graph = drawtwist(xi_pj_0); hold on; drawframe(g_s_m_i1_new,0.15); hold on;
                 otherwise
                    warning('[SMM STRUCTURE ASSEMBLY]: 3nd string element is not valid')                     
             end
             
        case passive_under_string_notation % 2nd case is that pseudo exists but only bolted in under base connectivity surface
            
             [synthetic_tform,g_s_m_i1_new] = add_synthetic_joint_tf('synthetic1',g_s_m_i1_new);
             figure(RefFig); drawframe(g_s_m_i1_new,0.15); hold on;
             [xi_pj_0,g_s_m_i1_new] = build_pseudomodule(g_s_m_i1_new);
             figure(RefFig); xi_graph = drawtwist(xi_pj_0); hold on; drawframe(g_s_m_i1_new,0.15); hold on;
             
            % nested switch for 2nd element
            switch structure(3,:)
                 case  no_passive_string_notation % case 2.2.1 -> this case leads to 2.1.1
                     % nothing to add!
                        
                 case passive_under_string_notation % case 2.2.2 -> pseudo_moving->pseudo_static with syntetic 4
                     
                     [synthetic_tform,g_s_m_i1_new] = add_synthetic_joint_tf('synthetic4',g_s_m_i1_new);
                     figure(RefFig);
                     drawframe(g_s_m_i1_new,0.15); hold on;                     
                     [xi_pj_0,g_s_m_i1_new] = build_pseudomodule(g_s_m_i1_new);
                     figure(RefFig); xi_graph = drawtwist(xi_pj_0); hold on; drawframe(g_s_m_i1_new,0.15); hold on;
                     
                 case passive_back_string_notation % case 2.2.3 ->  pseudo_moving->pseudo_static with syntetic 2

                     [synthetic_tform,g_s_m_i1_new] = add_synthetic_joint_tf('synthetic2',g_s_m_i1_new);
                     figure(RefFig);
                     drawframe(g_s_m_i1_new,0.15); hold on;
                     [xi_pj_0,g_s_m_i1_new] = build_pseudomodule(g_s_m_i1_new);
                     figure(RefFig); xi_graph = drawtwist(xi_pj_0); hold on; drawframe(g_s_m_i1_new,0.15); hold on;
                                          
                otherwise
                    warning('[SMM STRUCTURE ASSEMBLY]: 3rd string element is not valid')                     
             end
        otherwise
            warning('[SMM STRUCTURE ASSEMBLY]: 2nd string element is not valid')
    end
    %% END - Switch statement for 1st meta link

    %% START - Add active DXL
    
     [synthetic_tform,g_s_m_i1_new] = add_synthetic_joint_tf('active_assembly',g_s_m_i1_new);
     figure(RefFig);
     drawframe(g_s_m_i1_new,0.15); hold on;
     [xi_ai_0,g_s_m_i1_new] = build_activemodule(g_s_m_i1_new);
     figure(RefFig); xi_graph = drawtwist(xi_ai_0); hold on; drawframe(g_s_m_i1_new,0.15); hold on;
                        
    %% END - Add active DXL
    
    %% START - Switch statement for 2nd meta link follows-Always 2 sring elements are checked!
    % For 2nd meta link, 2 conditions exist:
    
    
    
    %% END - Switch statement for 2nd meta link
end
    