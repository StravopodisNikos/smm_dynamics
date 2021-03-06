function [xi_a1_0,g_s_m_i1] = build_base_link()
% Reads referemce data of base_link and generates twist

% g_s_a1_0 = loaded from mat file
g_s_a1_0 = eye(4);

p_a1_0 = g_s_a1_0(1:3,4);
w_a1_0 = [0 0 1]';
xi_a1_0 = createtwist(w_a1_0,p_a1_0); % ξa1

g_s_m_i1 = g_s_a1_0;
end