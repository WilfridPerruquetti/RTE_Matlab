function Hybrid(block)
setup(block);

function setup(block)
% Register the number of ports.
block.NumInputPorts  = 1;
block.NumOutputPorts = 1; 
% Set up the port properties to be inherited or dynamic.
block.SetPreCompInpPortInfoToDynamic;
block.SetPreCompOutPortInfoToDynamic;
% Override the input port properties.
block.InputPort(1).Dimensions = 1;
block.InputPort(1).DatatypeID  = 0;  % double
block.InputPort(1).Complexity  = 'Real';
% Override the output port properties.
block.OutputPort(1).Dimensions  = 4;
block.OutputPort(1).DatatypeID  = 0; % double
block.OutputPort(1).Complexity  = 'Real';
% Register the parameters.
block.NumDialogPrms     = 0;
% Set up the continuous states.
block.NumContStates = 2;
% Register the sample times.
%  [0 offset]            : Continuous sample time
%  [positive_num offset] : Discrete sample time
%  [-1, 0]               : Inherited sample time
%  [-2, 0]               : Variable sample time
block.SampleTimes = [0 0];
  
block.OperatingPointCompliance = 'Default';

% Register methods
block.RegBlockMethod('PostPropagationSetup', @DoPostPropSetup); 
block.RegBlockMethod('InitializeConditions', @InitializeConditions);
block.RegBlockMethod('Outputs', @Outputs);
block.RegBlockMethod('Update', @Update);
block.RegBlockMethod('Derivatives', @Derivatives);
block.RegBlockMethod('Terminate', @Terminate);
   
function DoPostPropSetup(block)
block.NumDworks = 2;

block.Dwork(1).Name            = 'xkminus1';
block.Dwork(1).Dimensions      = 1;
block.Dwork(1).DatatypeID      = 0;      % double
block.Dwork(1).Complexity      = 'Real'; % real
block.Dwork(1).UsedAsDiscState = true;
  
block.Dwork(2).Name            = 'xk';
block.Dwork(2).Dimensions      = 1;
block.Dwork(2).DatatypeID      = 0;      % double
block.Dwork(2).Complexity      = 'Real'; % real
block.Dwork(2).UsedAsDiscState = true;

function InitializeConditions(block)
block.ContStates.Data = [0.1;0.2];
block.Dwork(1).Data = 1;
block.Dwork(2).Data = -2;   

function Outputs(block)
block.OutputPort(1).Data = [block.ContStates.Data;block.Dwork(1).Data;block.Dwork(2).Data]; 

function Update(block)
dperiod=0.5;
doffset=0;
t=block.CurrentTime;
  if t==0 
      block.Dwork(1).Data =block.Dwork(1).Data;
      block.Dwork(2).Data =block.Dwork(2).Data;
    elseif abs(round((t-doffset)/dperiod)-(t-doffset)/dperiod) < 1e-6
        xkminus1=block.Dwork(1).Data;
        xk=block.Dwork(2).Data;
        %x_{k+1} = x_k + 0.01 x_{k-1} \sin(k T_s),
        block.Dwork(1).Data = xk;
        block.Dwork(2).Data = xk+0.01*xkminus1*sin(t);
    else
  block.Dwork(1).Data =block.Dwork(1).Data;
  block.Dwork(2).Data =block.Dwork(2).Data;% This is not a sample hit, so return an empty 
  end

function Derivatives(block)
x1 = block.ContStates.Data(1);
x2 = block.ContStates.Data(2);
xk = block.Dwork(1).Data;
u = block.InputPort(1).Data;
t = block.CurrentTime;
% Define the continuous state derivatives
block.Derivatives.Data(1) = x2;
block.Derivatives.Data(2) = -100*x1 -14*x2 -x1*x2 + sin(t)*xk + u;
    
function Terminate(block)
% No termination needed
 
