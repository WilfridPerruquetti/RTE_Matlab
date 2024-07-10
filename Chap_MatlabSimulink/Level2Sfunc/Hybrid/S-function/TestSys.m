function TestSys(block)
setup(block);
 
function setup(block)
% Register the parameters.
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
block.OutputPort(1).Dimensions = 2;
block.OutputPort(1).DatatypeID = 0; % double
block.OutputPort(1).Complexity = 'Real';
% Set block sample time
block.SampleTimes = [-1 0]; % default [0 0] or [1e-3 0] % inherited [-1 0]
% Specify the block simStateCompliance. 
block.SimStateCompliance = 'DefaultSimState';
% Specify the block's operating point compliance. 
block.OperatingPointCompliance = 'Default';
% Register the number of continuous states
block.NumContStates = 2;

% Register methods
block.RegBlockMethod('SetInputPortSamplingMode', @SetInpPortFrameData);
block.RegBlockMethod('SetOutputPortDimensions', @SetOutPortDims);
block.RegBlockMethod('SetInputPortDataType', @SetInpPortDataType);
block.RegBlockMethod('SetOutputPortDataType', @SetOutPortDataType);
block.RegBlockMethod('PostPropagationSetup', @DoPostPropSetup);
block.RegBlockMethod('ProcessParameters', @ProcessPrms);
block.RegBlockMethod('InitializeConditions', @InitializeConditions);
block.RegBlockMethod('Outputs', @Outputs);
block.RegBlockMethod('Update', @Update);
block.RegBlockMethod('Derivatives', @Derivatives);

function SetInpPortFrameData(block, idx, fd)
block.InputPort(idx).SamplingMode = fd;
block.OutputPort(1).SamplingMode  = fd;

function SetOutPortDims(block, idx, di)
block.OutputPort(idx).Dimensions = di;
block.InputPort(1).Dimensions    = di;

function ProcessPrms(block)
block.AutoUpdateRuntimePrms;
 
function SetInpPortDataType(block, idx, dt)
block.InputPort(idx).DataTypeID = dt;
block.OutputPort(1).DataTypeID  = dt;
  
function SetOutPortDataType(block, idx, dt)
block.OutputPort(idx).DataTypeID  = dt;
block.InputPort(1).DataTypeID     = dt;

function SetInpPortComplexSig(block, idx, c)
block.InputPort(idx).Complexity = c;
block.OutputPort(1).Complexity  = c;
  
function DoPostPropSetup(block)
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
  
% Register all tunable parameters as runtime parameters.
block.AutoRegRuntimePrms;
 
function InitializeConditions(block)
block.ContStates.Data = [0.1;-0.2];
block.Dwork(1).Data=0.1;
block.Dwork(2).Data=0.8;

function Outputs(block)
% Output the continuous states
%block.OutputPort(1).Data = block.ContStates.Data;
block.OutputPort(1).Data = [block.Dwork(1).Data;block.Dwork(2).Data];
%[block.ContStates.Data(1); block.ContStates.Data(2)];

function Update(block)
xk_minus_1 = block.Dwork(1).Data;
xk = block.Dwork(2).Data;
k = block.CurrentTime / block.SampleTimes(1);
Ts = block.SampleTimes(1);
%Update the discrete states
new_xk = xk + 0.1 * xk_minus_1 * sin(k * Ts);
block.Dwork(1).Data = xk;
block.Dwork(2).Data = new_xk;

function Derivatives(block)
x1 = block.ContStates.Data(1);
x2 = block.ContStates.Data(2);
xk = block.Dwork(1).Data;
u = block.InputPort(1).Data;
% Define the continuous state derivatives
block.Derivatives.Data(1) = -x1+x2;
block.Derivatives.Data(2) = x1-x1*x2+u;%+ xk;% + u;
    

