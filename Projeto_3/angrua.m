function ang = angrua(ve1,ve2,angr)
    for i=1:size(angr,1)
        if (angr(i,1)==ve1 && angr(i,2)==ve2) || (angr(i,1)==ve2 && angr(i,2)==ve1)
           ang = angr(i,3); 
           break;
        else
            ang = NaN;
        end
    end
end