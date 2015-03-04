function val = iff(bool, valIfTrue, valIfFalse, evalFuncFlag)
%{
 This function allows you to reduce code clutter by compressing 5 lines into 1:
  * Instead of: 
         if TF
            x = a;
         else
            x = b;
         end
   You can just write:
         x = iff(TF, a, b);                % [format #1]
 
   see also the "switchh" function which allows a similar shorthand for
   'switch' cases

 * You can only use the  format #1 (above) if both "a" and "b" are both defined
   irrespective of whether the boolean is true or false. If that is not true,
   (ie a is only defined if TF == true, or b is only defined if TF == false,
   then you need to use format #2:

        x = iff(TF, @()a, @()b, 1);         % [format #2]

    In format #2, there are two changes: (1) you pass two function handles
    to the function, instead of the original values. Each function handle
    should accept no input arguments, and return the desired values (a or b) 
    when called. This gets around needing to evaluate both arguments if one
    of them is not defined. (2) You need to pass a (non-empty) 4th argument, 
    as a "flag" to indicate that you want to evaluate the appropriate 
    function handle (otherwise, the algorithm will just return the function 
    handle, not its output.

    % (slightly contrived) example (of second format)
    v = randi(2); % = either 1 or 2.
    varname = char(96+v); % either 'a', or 'b';
    eval([varname ' = 1;']); % either a = 1, or b = 1;
    
    X = iff(v==1, @()a, @()b, 1); 

%}
    if (nargin < 3)
        if isnumeric(valIfTrue)
            valIfFalse = 0;
        elseif ischar(valIfTrue)
            valIfFalse = '';
        else 
            valIfFalse = [];
        end
    end            

    if bool
        val = valIfTrue;
    else
        val = valIfFalse;
    end
    
    if (nargin == 4) && ~isempty(evalFuncFlag)
        if ~isa(val, 'function_handle')
            error('You passed an "evaluate" (4th-argument) flag, but the inputs were not function handles');
        end
        val = val();            
    end
    
end

