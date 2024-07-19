function TestSys(block)
setup(block);

function setup(block)
% Register the number of parameters
block.NumDialogPrms = 0;
% Register number of input and output ports
block.NumInputPorts  = 1;
block.NumOutputPorts = 1;
% Setup port properties to be dynamic
block.SetPreCompInpPortInfoToDynamic;
block.SetPreCompOutPortInfoToDynamic; 
% Override input port properties
block.InputPort(1).Dimensions = 1;
block.InputPort(1).DatatypeID = 0; % double
block.InputPort(1).Complexity = 'Real';
block.InputPort(1).DirectFeedthrough = true;
% Override output port properties
block.OutputPort(1).Dimensions = 4;
block.OutputPort(1).DatatypeID = 0; % double
block.OutputPort(1).Complexity = 'Real'; 
% Register sample times (continuous)
block.SampleTimes = [0 0];   
% Specify the block simStateCompliance
block.SimStateCompliance = 'DefaultSimState';    
% Register the methods
block.RegBlockMethod('PostPropagationSetup', @DoPostPropSetup);
block.RegBlockMethod('InitializeConditions', @InitializeConditions);
block.RegBlockMethod('Outputs', @Outputs);
block.RegBlockMethod('Derivatives', @Derivatives);
%block.RegBlockMethod('Update', @Update);
%end

function DoPostPropSetup(block)
% Number of continuous states
block.NumContStates = 2;
% Number of discrete states and other DWork vectors
block.NumDworks = 3;
block.Dwork(1).Name = 'x_k';
block.Dwork(1).Dimensions = 1;
block.Dwork(1).DatatypeID = 0;  % double
block.Dwork(1).Complexity = 'Real';
block.Dwork(1).UsedAsDiscState = true;

block.Dwork(2).Name = 'x_k_minus_1';
block.Dwork(2).Dimensions = 1;
block.Dwork(2).DatatypeID = 0;  % double
block.Dwork(2).Complexity = 'Real';
block.Dwork(2).UsedAsDiscState = true;

block.Dwork(3).Name = 'timeCounter';
block.Dwork(3).Dimensions = 1;
block.Dwork(3).DatatypeID = 0;  % double
block.Dwork(3).Complexity = 'Real';    

function InitializeConditions(block)
% Initialize continuous states
block.ContStates.Data = [0; 0];  
% Initialize discrete states
block.Dwork(1).Data = 0;
block.Dwork(2).Data = 0;
block.Dwork(3).Data = 0; % Initialize time counter

function Outputs(block)
% Output the states
block.OutputPort(1).Data = [block.ContStates.Data; block.Dwork(1).Data; block.Dwork(2).Data];

function Derivatives(block)
% Get states and input
x1 = block.ContStates.Data(1);
x2 = block.ContStates.Data(2);
x_k = block.Dwork(1).Data;
u = block.InputPort(1).Data;   
% Compute the derivatives
dx1 = x2;
dx2 = -100*x1 - 14*x2 - x1*x2 + sin(block.CurrentTime)*x_k + u;
% Set the derivatives
block.Derivatives.Data = [dx1; dx2];

function Update(block)
    % Update the discrete state only if 0.1 seconds have passed
    if block.Dwork(3).Data >= 0.1
        x_k = block.Dwork(1).Data;
        x_k_minus_1 = block.Dwork(2).Data;
        block.Dwork(2).Data = x_k;
        block.Dwork(1).Data = x_k + 0.1 * x_k_minus_1 * sin(block.CurrentTime);
        block.Dwork(3).Data = 0; % Reset the time counter
    else
        block.Dwork(3).Data = block.Dwork(3).Data + block.SampleTimes(1);
    end
%end
