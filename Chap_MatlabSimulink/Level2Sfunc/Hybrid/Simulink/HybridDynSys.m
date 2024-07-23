function HybridDynSys(block)
setup(block);

function setup(block)
% Register the number of parameters
block.NumDialogPrms = 0;
% Register the number of ports
block.NumInputPorts = 1;
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
block.OutputPort(1).Dimensions = 1;
block.OutputPort(1).DatatypeID = 0; % double
block.OutputPort(1).Complexity = 'Real';
% Set block sample time
block.SampleTimes = [0 0]; % default [0 0] or [1e-3 0] % inherited [-1 0]
% Specify the block simStateCompliance. 
block.SimStateCompliance = 'DefaultSimState';
% Register methods
block.RegBlockMethod('PostPropagationSetup', @DoPostPropSetup);
block.RegBlockMethod('InitializeConditions', @InitializeConditions);
block.RegBlockMethod('Outputs', @Outputs);
block.RegBlockMethod('Derivatives', @Derivatives);
block.RegBlockMethod('Update', @Update);
block.RegBlockMethod('Terminate', @Terminate);

function DoPostPropSetup(block)
% Register the number of continuous states
block.NumContStates = 2;
% Register the number of discrete states
block.NumDworks = 2;
block.Dwork(1).Name = 'xk';
block.Dwork(1).Dimensions = 1;
block.Dwork(1).DatatypeID = 0; % double
block.Dwork(1).Complexity = 'Real';
block.Dwork(1).UsedAsDiscState = true;

block.Dwork(2).Name = 'xk_minus_1';
block.Dwork(2).Dimensions = 1;
block.Dwork(2).DatatypeID = 0; % double
block.Dwork(2).Complexity = 'Real';
block.Dwork(2).UsedAsDiscState = true;

function InitializeConditions(block)
%Initialize continuous states
block.ContStates.Data = [0; 0];
% Initialize discrete states
block.Dwork(1).Data = 1;
block.Dwork(2).Data = 0;

function Outputs(block)
% Output the continuous states
%block.OutputPort(1).Data = block.ContStates(1).Data;
block.OutputPort(1).Data = block.Dwork(1).Data;
  
%endfunction

function Update(block)
xk = block.Dwork(1).Data;
xk_minus_1 = block.Dwork(2).Data;
Ts = 0.1;
k = block.CurrentTime / Ts;
if abs(round(k)-k) < 1e-8
    %Update the discrete states
    new_xk = xk + 0.1 * xk_minus_1 * sin(k * Ts);
    block.Dwork(2).Data = xk;
    block.Dwork(1).Data = new_xk;
else
    block.Dwork.Data=block.Dwork.Data;% This is not a sample hit, so return an empty 
end


function Derivatives(block)
x1 = block.ContStates.Data(1);
x2 = block.ContStates.Data(2);
%xk = block.Dwork(1).Data;
u = block.InputPort(1).Data;
% Define the continuous state derivatives
block.Derivatives.Data(1) = x1;
block.Derivatives.Data(2) = x1*x2 + u;

function Terminate(block)
% No termination needed