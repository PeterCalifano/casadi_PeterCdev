function outConverted = ConvertToCasadiTypes(inInputVar, charCasadiSymType)
arguments
    inInputVar        {mustBeA(inInputVar, ["struct", "char", "string", "cell", "double", "single", "float"])}
    charCasadiSymType {mustBeMember(charCasadiSymType, ["SX", "MX"])} = "MX"
end


if isstruct(inInputVar)

    outConverted = struct();
    cellFieldNames = fieldnames(inInputVar);

    for idF = 1:length(cellFieldNames)
        charFieldName = cellFieldNames{idF};
        fieldValue = inInputVar.(charFieldName);

        if isnumeric(fieldValue)
            % Convert numeric field to casadi.DM.
            outConverted.(charFieldName) = casadi.DM(fieldValue);

        elseif (ischar(fieldValue) || isstring(fieldValue)) && ...
                (lower(charFieldName(1)) == 'd' || lower(charFieldName(1)) == 'f')
            % Convert string symbolic specification using the local function.
            outConverted.(charFieldName) = CastCasadiVar(fieldValue, charCasadiSymType);

        elseif iscell(fieldValue) && ...
                (lower(charFieldName(1)) == 'd' || lower(charFieldName(1)) == 'f')
            % Convert cell symbolic specification using the local function.
            outConverted.(charFieldName) = CastCasadiVar(fieldValue, charCasadiSymType);

        else
            % Leave the field unchanged.
            outConverted.(charFieldName) = fieldValue;
        end
    end

else
    % For non-struct input, use the element conversion function.
    outConverted = CastCasadiVar(inInputVar, charCasadiSymType);
end

end
