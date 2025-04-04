function objCasadiVar = CastCasadiVar(inInputVar, charCasadiSymType, charSymVarName)
arguments
    inInputVar        {mustBeA(inInputVar, ["double", "single", "char", "cell", "string"])}
    charCasadiSymType {mustBeMember(charCasadiSymType, ["DM", "SX", "MX"])} = "MX"
    charSymVarName     char {mustBeA(charSymVarName, ["char", "string"])} = []
end

if isnumeric(inInputVar)

    if isempty(charSymVarName)
        % All numeric inputs are converted to casadi.DM.
        objCasadiVar = casadi.DM(inInputVar);
    else
        % Use numeric input as a sample vector to specify the size for the symbolic variable.
        sampleSize = size(inInputVar);
        % Create a symbolic variable with a default name 'symVar' and the sample size.
        if charCasadiSymType == "SX"
            objCasadiVar = casadi.SX.sym(charSymVarName, sampleSize(1), sampleSize(2));
        elseif charCasadiSymType == "MX"
            objCasadiVar = casadi.MX.sym(charSymVarName, sampleSize(1), sampleSize(2));
        end
    end

elseif ischar(inInputVar) || isstring(inInputVar)
    % For char/string inputs, ensure that symbolic conversion is requested.
    if charCasadiSymType == "DM"
        error('Cannot convert a symbolic string to DM type. Please choose SX or MX for symbolic conversion.');
    end

    % Expecting format: "name, size1, size2"
    charValueStr = char(inInputVar);
    if count(charValueStr, ',') ~= 2
        error('String input does not match the expected format: "name, size1, size2".');
    end

    charParsedParts = strsplit(charValueStr, ',');
    if numel(charParsedParts) ~= 3
        error('String input format invalid. Expected "name, size1, size2".');
    end

    charVarName = strtrim(charParsedParts{1});
    % Parse sizes
    ui32Size1 = str2double(strtrim(charParsedParts{2}));
    ui32Size2 = str2double(strtrim(charParsedParts{3}));

    if isnan(ui32Size1) || isnan(ui32Size2)
        error('Invalid dimensions in string input. Dimensions must be numeric.');
    end

    % Cast variable
    if charCasadiSymType == "SX"
        objCasadiVar = casadi.SX.sym(charVarName, ui32Size1, ui32Size2);

    elseif charCasadiSymType == "MX"
        objCasadiVar = casadi.MX.sym(charVarName, ui32Size1, ui32Size2);
    end

elseif iscell(inInputVar)

    % For cell inputs, expect a cell of the form {name, size1, size2}.
    if charCasadiSymType == "DM"
        error('Cannot convert a symbolic cell to DM type. Please choose SX or MX for symbolic conversion.');
    end

    if numel(inInputVar) ~= 3
        error('Cell input format invalid. Expected {name, size1, size2}.');
    end

    charVarName = inInputVar{1};
    ui32Size1 = inInputVar{2};
    ui32Size2 = inInputVar{3};

    if ~(ischar(charVarName) || isstring(charVarName))
        error('First element of cell must be a string (variable name).');
    end
    if ~(isnumeric(ui32Size1) && isnumeric(ui32Size2))
        error('Dimensions in cell input must be numeric.');
    end

    if charCasadiSymType == "SX"
        objCasadiVar = casadi.SX.sym(charVarName, ui32Size1, ui32Size2);
    elseif charCasadiSymType == "MX"
        objCasadiVar = casadi.MX.sym(charVarName, ui32Size1, ui32Size2);
    end

else
    error('Input type not supported for conversion.');
end

end
