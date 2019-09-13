function x = NaN_0( x )
    for n = 1:length(x)
        if isnan(x(n))
            x(n)=0;
        elseif isinf(x(n))
            x(n)=0;
        end
    end
end

