function SfuncI1Level2(block)
    % Level 2 MATLAB S-function for calculating the integral using trapezoidal rule
    % Register number of input and output ports
    setup(block);

% Initialize function to set up the basic block parameters
function setup(block)
    % Register number of ports
    block.NumInputPorts = 1;
    block.NumOutputPorts = 1;
    
    % Set input/output port properties
    block.SetPreCompInpPortInfoToDynamic;
    block.SetPreCompOutPortInfoToDynamic;

    % Input is scalar
    block.InputPort(1).Dimensions = 1;
    block.InputPort(1).DirectFeedthrough = false;
    
    % Output is scalar (Integral)
    block.OutputPort(1).Dimensions = 1;
    
    % Register the parameters.
    block.NumDialogPrms     = 1;

    % Set sample time
    ParamI1 = block.DialogPrm(1).Data; % Retrieve parameters
    block.SampleTimes = [ParamI1.Ts 0]; % Discrete sample time

    % Block simState compliance
    block.SimStateCompliance = 'DefaultSimState';
    block.OperatingPointCompliance = 'Default';

    % Register functions
    block.RegBlockMethod('PostPropagationSetup', @DoPostPropSetup); 
    block.RegBlockMethod('InitializeConditions', @InitializeConditions);
    block.RegBlockMethod('Outputs', @Outputs);
    block.RegBlockMethod('Update', @Update);

function DoPostPropSetup(block)
% Number of discrete states (N + 2 where N is stored samples, plus the integral)
    ParamI1 = block.DialogPrm(1).Data; % Retrieve ParamI1
    N = ParamI1.N;
    block.NumDworks = 1;
    block.Dwork(1).Name = 'x'; % Discrete state (input samples and integral)
    block.Dwork(1).Dimensions = N + 2;
    block.Dwork(1).DatatypeID = 0; % Double
    block.Dwork(1).Complexity = 'Real';

function InitializeConditions(block)
    % Initialize all states to zero
    block.Dwork(1).Data = zeros(block.Dwork(1).Dimensions, 1);

% Update discrete state (update input samples and compute integral)
function Update(block)
    % Retrieve parameters
    ParamI1 = block.DialogPrm(1).Data; 
    Ts = ParamI1.Ts;
    P = ParamI1.P;
    N = ParamI1.N;

    t = block.CurrentTime;
    idx = round(t / Ts) + 1;
    
    % Store input sample
    if t <= N * Ts
        block.Dwork(1).Data(idx) = block.InputPort(1).Data;
    end
    
    % Compute integrand and tau
    integrand = zeros(idx, 1);
    tau = linspace(0, 1, idx);
    for i = 1:idx
        integrand(i) = P(tau(i)) * block.Dwork(1).Data(i);
    end
    
    % Compute integral using trapezoidal rule
    if idx == 1
        Integral = 0;
    else
        Integral = trapz(tau, integrand);
    end
    % Store the computed integral in the last element of the state vector
    block.Dwork(1).Data(N + 2) = Integral;

% Output the integral
function Outputs(block)
    block.OutputPort(1).Data = block.Dwork(1).Data(end);