%Returns distance from P2 (vector of x and y) 
%to P1 (single x y element)

function [dist] = Distance2D(fromPosn, ofPosn)

%old code...............

p2 = ofPosn;

p1 = fromPosn;

dist = sqrt((p1(1)-p2(:,1)).^2 + (p1(2)-p2(:,2)).^2);

%old code ends here

%p2 = ofPosn;

%p1 = fromPosn .* ones(size(p2));

%dist = sqrt(sum((p1-p2).^2,2));

end
