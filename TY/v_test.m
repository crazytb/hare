v_result = 0;
e_result = 0;
for i = 1: size(mu,2)
    v_result = v_result + mu(i)*state(i).velocity;
end
for i = 1: size(mu,2)
    v_result = v_result + mu(i)*state(i).velocity;
end


v_result
    