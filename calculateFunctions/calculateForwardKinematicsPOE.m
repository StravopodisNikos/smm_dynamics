function [g_ai,g_pj,Jsp,P_i_i1,gst] = calculateForwardKinematicsPOE(structure,nDoF_string,xi_ai_ref,xi_pj_ref,qa,transformed_anatomy_vector,g_ai_ref,g_pj_ref,gst0)

% Given the extracted(from optimization) structure it computes the forward
% kinematics tfs and Spatial Jacobian of the SMM.

nDoF = size(xi_ai_ref,2);           % determine total number of active joints by number of columns
% nPseudo = size(xi_pj_ref,2);        % determine total number of passive joints by number of columns
nAssemblyParts = size(structure,1);

% preallocate memory
Jsp = zeros(6,nDoF);

% Compute exponentials with current anatomy twist
for i_cnt=1:nDoF
    exp_ai(:,:,i_cnt) = twistexp(xi_ai_ref(:,i_cnt),qa(i_cnt));
end

% Anatomy vector is given structure-specific!(depends to structure/number of pseudos)
% transformed_anatomy_vector = calculate_transformed_anatomy_vector(structure,nDoF_string,qp_xacro_user_given);

for j_cnt=1:size(transformed_anatomy_vector,2)
    exp_pj(:,:,j_cnt) = twistexp(xi_pj_ref(:,j_cnt),transformed_anatomy_vector(j_cnt));
end

% Obtain POE equation by structure string
i_cnt = 0;
j_cnt = 0;
interm_cnt = 0;
exp_pj_interm(:,:,1) = eye(4);
g_pj(:,:,1) = eye(4);
g_ai(:,:,1) = eye(4);

for assembly_part_cnt=1:nAssemblyParts
    
    switch structure(assembly_part_cnt,:)
        case 'x0' % add active exponential
            if interm_cnt==0    %for 1st only
                exp_pj_interm_last = eye(4);
            else
                exp_pj_interm_last = exp_pj_interm(:,:,interm_cnt);
            end

            if i_cnt==0    %for 1st only
                g_ai_last = eye(4);
            else
                g_ai_last = g_ai(:,:,i_cnt) * inv(g_ai_ref(:,:,i_cnt));
            end
            
            i_cnt = i_cnt +1;
            
            % For fwd kin
            g_ai(:,:,i_cnt) = g_ai_last * exp_pj_interm_last * exp_ai(:,:,i_cnt) * g_ai_ref(:,:,i_cnt);
            
            if i_cnt==nDoF % finished last active joint tf
                gst = g_ai_last * exp_pj_interm_last * exp_ai(:,:,i_cnt) * gst0;
            end
                
            % For Spatial Jacobian Jsp
            g_for_sp = g_ai_last * exp_pj_interm_last;
            
            [Jsp(:,i_cnt)] = calculateSpatialJacobianColumns(xi_ai_ref,g_for_sp,i_cnt);
            
            % for Pseudo Exponentials Product Pi
%             A(:,:,i_cnt) = g_ai_ref(:,:,i_cnt) * inv(g_ai(:,:,i_cnt));
            if i_cnt~=1
                P_i_i1(:,:,i_cnt-1) = exp_pj_interm_last;
            end
            
            interm_cnt = 0;             
        case 'x9' % nothing here
%             j_cnt = j_cnt + 1;
            if interm_cnt==0
                exp_pj_interm(:,:,interm_cnt+1) = eye(4); %does nothing
            else
                exp_pj_interm(:,:,interm_cnt) = exp_pj_interm(:,:,interm_cnt) * eye(4); % works only when in 2nd string position of link
            end
                
        case '21' % add passive exponential
            j_cnt = j_cnt + 1;
            if interm_cnt==0    %previous was active
                exp_pj_interm_last = eye(4);
            else
                exp_pj_interm_last = exp_pj_interm(:,:,interm_cnt);
            end
            
            interm_cnt = interm_cnt +1;
            
            exp_pj_interm(:,:,interm_cnt) = exp_pj_interm_last * exp_pj(:,:,j_cnt);
            
            if i_cnt == 1
                g_ai_last = g_ai(:,:,i_cnt);
            else
                g_ai_last = g_ai(:,:,i_cnt) * inv(g_ai_ref(:,:,i_cnt));
            end                
            
            g_pj(:,:,j_cnt) = g_ai_last * exp_pj_interm(:,:,interm_cnt) * g_pj_ref(:,:,j_cnt);
            
        case '31' % add passive exponential
            j_cnt = j_cnt + 1;
            if interm_cnt==0    %previous was active
                exp_pj_interm_last = eye(4);
            else
                exp_pj_interm_last = exp_pj_interm(:,:,interm_cnt);
            end
            
            interm_cnt = interm_cnt +1;
            
            exp_pj_interm(:,:,interm_cnt) = exp_pj_interm_last * exp_pj(:,:,j_cnt);
            
            if i_cnt == 1
                g_ai_last = g_ai(:,:,i_cnt);
            else
                g_ai_last = g_ai(:,:,i_cnt) * inv(g_ai_ref(:,:,i_cnt));
            end                
            
            g_pj(:,:,j_cnt) = g_ai_last * exp_pj_interm(:,:,interm_cnt) * g_pj_ref(:,:,j_cnt);          
    end
end

end