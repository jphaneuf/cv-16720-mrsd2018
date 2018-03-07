function [ dsigma_out ] = dsigma ( x )
  dsigma_out = sigmoid ( x ) * ( 1 - sigmoid ( x ) );
end

function [ x ] = sigmoid ( x )
  x =  1 ./ ( 1 + exp ( - x ) );
end

