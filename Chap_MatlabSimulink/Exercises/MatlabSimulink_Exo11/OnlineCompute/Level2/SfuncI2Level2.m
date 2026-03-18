function SfuncI2Level2(block)
    % Level 2 MATLAB S-function for integral approximation with Q function and trapezoidal rule
    % Register number of input and output ports
    setup(block);

% Initialize the block's basic parameters
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

    % Retrieve parameters (T, Ts, k, Q) from the block dialog
    ParamI2 = block.DialogPrm(1).Data; 
    
    % Set sample time
    block.SampleTimes = [ParamI2.Ts 0]; % Discrete sample time

    % Block simState compliance
    block.SimStateCompliance = 'DefaultSimState';
    block.OperatingPointCompliance = 'Default';

    % Register methods
    block.RegBlockMethod('PostPropagationSetup', @DoPostPropSetup); 
    block.RegBlockMethod('InitializeConditions', @InitializeConditions);
    block.RegBlockMethod('Outputs', @Outputs);
    block.RegBlockMethod('Update', @Update);

function DoPostPropSetup(block)
    % Number of discrete states (N + 2 where N is stored samples, plus the integral)
    ParamI2 = block.DialogPrm(1).Data; 
    N = round(ParamI2.T / ParamI2.Ts); 
    block.NumDworks = 1;
    block.Dwork(1).Name = 'x'; % Discrete state (input samples and integral)
    block.Dwork(1).Dimensions = N + 2;
    block.Dwork(1).DatatypeID = 0; % Double
    block.Dwork(1).Complexity = 'Real';

% Initialize discrete states
function InitializeConditions(block)
    % Initialize all states to zero
    block.Dwork(1).Data = zeros(block.Dwork(1).Dimensions, 1);

% Update discrete states
function Update(block)
    % Retrieve parameters
    ParamI2 = block.DialogPrm(1).Data;
    Ts = ParamI2.Ts;
    T = ParamI2.T;
    Q = ParamI2.Q;
    k = ParamI2.k;
    N = round(T / Ts);

    t = block.CurrentTime;
    idx = round(t / Ts) + 1;
    
    % Stack and update samples
    if t <= T
        block.Dwork(1).Data(idx) = block.InputPort(1).Data;
        len = idx;
        Tlen = (idx - 1) * Ts;
        tau = linspace(0, t, len);
    else
        for i = 1:N
            block.Dwork(1).Data(i) = block.Dwork(1).Data(i + 1);
        end
        block.Dwork(1).Data(N + 1) = block.InputPort(1).Data;
        len = N + 1;
        Tlen = T;
        tau = linspace(t - T, t, len);
    end

    % Compute integrand
    integrand = zeros(len, 1);
    for i = 1:len
        integrand(i) = Q(tau(i), t, T) * block.Dwork(1).Data(i);
    end

    % Trapezoidal rule
    if idx == 1
        Integral = 0;
    else
        Integral = (1 / T^k) * (T / (2 * N)) * sum(integrand(1:end-1) + integrand(2:end));
    end
    block.Dwork(1).Data(N + 2) = Integral;

% Output the integral value
function Outputs(block)
    block.OutputPort(1).Data = block.Dwork(1).Data(end);





