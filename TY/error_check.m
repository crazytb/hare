
a_o = 91;
b_o = 9;
tech = zeros (a_o,b_o);
for i = 1: a_o
    for j = 1:b_o
        tech(i,j) = sum(trans_PR(i,:,j));
    end
end