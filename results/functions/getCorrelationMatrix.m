function correlations = getCorrelationMatrix(correlationCellMatrix,method)

correlations = [];

if strcmp(method,'max')
    correlations = correlationCellMatrix.maxCorrelation;
else 
    correlations = correlationCellMatrix.centerCorrelation;
end

isEm = cellfun( @isempty, correlations ) ;
correlations(isEm) = {NaN} ;

correlations = abs(cell2mat(correlations));
% correlations = (cell2mat(correlations));

end