function [xi_ai_0,g_s_m_i1] = build_activemodule(g_s_m_i)
% Adds an  active Dynamixel module in the serial metamorphic chain
% Input: 1. the previously last frame attached to serial chain

% g_k_ai_0 =    [ 1.0000    0.0000         0    0.0000;... for pitch 1.5708
%                 0.0000    1.0000   -0.0000    0.0320;...
%                      0   -0.0000    1.0000   -0.0000;...
%                      0         0         0    1.0000];
g_k_ai_0 =    [ -0.0000         0    1.0000         0;...
                      0    1.0000         0    0.0320;...
                -1.0000         0   -0.0000   -0.0000;...
                      0         0         0    1.0000];
% local_rot_axis = rotparam(g_k_ai_0(1:3,1:3)); % [0 1 0]' always
% default_local_active_rot_axis = [1 0 0]';

% Extract g_s_ai_0: the tf of dxl moving with respect to spatial {S}
% frame
g_s_ai_0 = g_s_m_i * g_k_ai_0 ;

% g_s_ai_0_s = g_s_m_i * g_k_ai_0 / g_s_m_i; % g_s_m_i * g_k_ai_0 * inv(g_s_m_i)

% Extract point in the pseudo twist axis
p_ai_0 = g_s_ai_0(1:3,4);

% Extract wmega of active twist axis
% R_s_m_i = g_s_m_i(1:3,1:3);
% R_s_ai_0_s = g_s_ai_0_s(1:3,1:3);

% [w_s_0,~] = rotparam(R_s_ai_0_s); %rotparam(R_s_pj_0*inv(rotz(pi/2)*inv(rotx(pi/2)))) helped me understand i needed local tf

% w_s_ai_0 = -cross(default_local_active_rot_axis,w_s_0); % if 0 pitch
% w_active_final = -cross(w_s_ai_0,w_s_0);
w_s_ai_0 = g_s_ai_0(1:3,1); % always take the x-dir of dxl moving frame

% Extract reference twist
xi_ai_0 = createtwist(w_s_ai_0,p_ai_0); 

% New last frame
g_s_m_i1 = g_s_ai_0;
end