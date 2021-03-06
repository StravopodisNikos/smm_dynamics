function GlobalKinematicIsotropicIndex = calculateKinematicIsotropicIndex_3DoF(xi_ai_struct_ref, Pi, gst0)
% Function that returns Kinermatic Isotropic Index of manipulator as
% presented in Eq.43 of Patel-Sobh paper

% xi_ai_struct_anat -> active twists are recalculated for each anatomy!
% This is done because inertia of the links must be recomputed for each new
% anatomy and not computed by the POE!
% xi_ai_struct_ref -> these are the REFERENCE ANATOMY twists of the
% assembled structure. Can be used for POE formula calculations with Pi's!

%% Ovidius robot properties
active_angle_limit(1) = 2.8; % [rad]
active_angle_limit(2) = 2; % [rad]
active_angle_limit(3) = 3.4; % [rad]
step_a2 = 0.20;
step_a3 = 0.20;
%% I.a. Definition of Configuration Space of first 3DoF
Cspace_count = 0;

for ta2=-active_angle_limit(2):step_a2:active_angle_limit(2)
        for ta3=-active_angle_limit(3):step_a3:active_angle_limit(3)
            
            % Vector for current Cspace point
            qa = [0.1 ta2 ta3];
            Cspace_count = Cspace_count + 1;
 
            %%  I.b Compute Spatial Jacobian Matrix @ current configuration
            [Jsp, ~, gst] = calculateJacobians_for_assembled_structure('3dof', xi_ai_struct_ref, qa, Pi, gst0) ;
            Jtool = calculateToolJacobian_3dof(Jsp,gst(1:3,4));
            
            %%  I.d Compute kinematic manipulability index
%             W = abs(det(Jtool));
             
%             Wo = nthroot(W,3); % order-independent index
            
            %% Produce the eigenvalues of the square matrix Jtool
%             idiothmes = eig(Jtool); %bgazw migadikes idiothmes
             
%             psi = mean(idiothmes);
            sigma_i = svd(Jtool);
            
            KinematicIsotropicIndex(Cspace_count) = min(sigma_i) / max(sigma_i);
            
            %% I.e Calculate Isotropic Index
            
%             psi_volume(Cspace_count) = Wo / psi;
        end
end

%
GlobalKinematicIsotropicIndex = 1/max(KinematicIsotropicIndex);
end