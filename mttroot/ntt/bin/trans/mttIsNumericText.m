function boolean = mttIsNumericText(text)

    if any(abs(text)==39)
    % MATLAB doesn't like apostrophes in text
        boolean = 0 ;
    elseif strcmp(text,'flow')
    % MATLAB invokes built-in function "flow" rather than treating it as text in str2num(text) !!!
        boolean = 0 ;
    elseif strcmp(text,'error')
    % MATLAB invokes built-in function "error" rather than treating it as text in str2num(text) !!!
        boolean = 0 ;
    else
        num = str2num(text) ;
        if isempty(num)
            boolean = 0 ;
            % ... contains non-numeric characters other than stand-alone "i" or "j"
        else
            boolean = isreal(num) ;
            % ... doesn't contain stand-alone "i" or "j"
        end
    end
    
