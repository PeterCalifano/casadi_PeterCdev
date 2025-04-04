% TEST SETUP
strInput.dNum = 42;
strInput.dSymVar = 'x, 3, 2';           % symbolic variable specification in string form
strInput.fParam = { 'y', 4, 1 };      % symbolic variable specification in cell form

%% test_Struct2Casadi
% Convert using SX symbolic type:
strConvertedStruct0 = ConvertToCasadiTypes(strInput, 'SX');

% Add assertions to check the conversion
assert(isa(strConvertedStruct0.dNum, 'casadi.DM'), 'Field a should be converted to casadi.DM type');
assert(isa(strConvertedStruct0.dSymVar, 'casadi.SX'), 'Field should be converted to casadi.SX type');
assert(isa(strConvertedStruct0.fParam, 'casadi.SX'), 'Field should be converted to casadi.SX type');

% Convert using MX symbolic type:
strConvertedStruct1 = ConvertToCasadiTypes(strInput, 'MX');

% Add assertions to check the conversion
assert(isa(strConvertedStruct1.dNum, 'casadi.DM'), 'Field should be converted to casadi.DM type');
assert(isa(strConvertedStruct1.dSymVar, 'casadi.MX'), 'Field should be converted to casadi.MX type');
assert(isa(strConvertedStruct1.fParam, 'casadi.MX'), 'Field should be converted to casadi.MX type');


%% test_values2Casadi
% Test conversion of double, char, and cell inputs to CasADi types
dInputDouble = 3.14;
charInputChar = 'z,1,1';
cellInputCell = {'a', 2, 3};
dInputVector = zeros(3,1);

% Convert using SX symbolic type
convertedDoubleDM   = ConvertToCasadiTypes(dInputDouble, 'SX');
convertedCharSX     = ConvertToCasadiTypes(charInputChar, 'SX');
convertedCellSX     = ConvertToCasadiTypes(cellInputCell, 'SX');

% Add assertions to check the conversion
assert(isa(convertedDoubleDM, 'casadi.DM'), 'Double should be converted to casadi.DM type');
assert(isa(convertedCharSX, 'casadi.SX'), 'Char should be converted to casadi.SX type');
assert(isa(convertedCellSX, 'casadi.SX'), 'Cell should be converted to casadi.SX type');

% Convert using MX symbolic type
convertedDoubleDM = ConvertToCasadiTypes(dInputDouble, 'MX');
convertedCharMX = ConvertToCasadiTypes(charInputChar, 'MX');
convertedCellMX = ConvertToCasadiTypes(cellInputCell, 'MX');

% Add assertions to check the conversion
assert(isa(convertedDoubleDM, 'casadi.DM'), 'Double should be converted to casadi.DM type');
assert(isa(convertedCharMX, 'casadi.MX'), 'Char should be converted to casadi.MX type');
assert(isa(convertedCellMX, 'casadi.MX'), 'Cell should be converted to casadi.MX type');

% Convert vector to symbolic
dTestShape = zeros(5,4);

convertedSymbolicVecDM = CastCasadiVar(dTestShape);
convertedSymbolicVecSX = CastCasadiVar(dTestShape, 'SX', "symVar");
convertedSymbolicVecMX = CastCasadiVar(dTestShape, 'MX', "symVar");

assert(isa(convertedSymbolicVecDM, 'casadi.DM'), 'Vector should be converted to casadi.DM type');
assert(isa(convertedSymbolicVecSX, 'casadi.SX'), 'Vector should be converted to casadi.SX type');
assert(isa(convertedSymbolicVecMX, 'casadi.MX'), 'Vector should be converted to casadi.MX type');



