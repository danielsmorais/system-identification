function [normalisedWeight] = WeighAndNormalise(rawData, trueVal)

variance = std(rawData)^2;

mulConst = 1./(sqrt(2*pi*variance));

weight = exp(1).^((-(rawData-trueVal).^2)/(2*variance))* mulConst;

normalisedWeight = weight./sum(weight);

end
