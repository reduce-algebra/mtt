%% Reduce comands to simplify output (mimo_sim.r)
m_r   := rho*v_r;
%mttx1 := c_a*v_r;
%mttx2 := c_b*v_r;

% THIS MUST BE CHANGED - probs with cp and FMRs
%c_p := 1;

%let mttx3/c_p = t;

let  e^(q_1/(mttx3/c_p)) = 1/epsilon_1;
let  e^(q_2/(mttx3/c_p)) = 1/epsilon_2;
let  e^(q_3/(mttx3/c_p)) = 1/epsilon_3;

let  e^(q_1/t_s) = 1/epsilon_1;
let  e^(q_2/t_s) = 1/epsilon_2;
let  e^(q_3/t_s) = 1/epsilon_3;

FACTOR mttx1,mttx2;

END;
