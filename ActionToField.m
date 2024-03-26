function integer = ActionToField(actionArray, action)

ids = false(size(action,2),1);
for ii = 1:size(action,2)
    ids(ii) = isequal(state(ii).harqaction, [actionArray(1) actionArray(2)]) ...
        && isequal(state(ii).mcsaction, stateArray(3));
end
integer = find(ids);