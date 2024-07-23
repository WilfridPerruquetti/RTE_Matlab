#define S_FUNCTION_NAME  hybrid2
#define S_FUNCTION_LEVEL 2

#include "simstruc.h"
#include <math.h>

#define Ts 0.1

#define CONTINUOUS_STATES 2
#define DISCRETE_STATES 2
#define NUM_INPUTS 1
#define NUM_OUTPUTS 4

#define U(element) (*uPtrs[element])

/* Function: mdlInitializeSizes ===============================================
 * Abstract:
 *    The sizes information is used by Simulink to determine the S-function
 *    block's characteristics (number of inputs, outputs, states, etc.).
 */
static void mdlInitializeSizes(SimStruct *S)
{
    ssSetNumContStates(S, CONTINUOUS_STATES);
    ssSetNumDiscStates(S, DISCRETE_STATES);
    ssSetNumInputPorts(S, 1);
    ssSetNumOutputPorts(S, 1);

    ssSetInputPortWidth(S, 0, NUM_INPUTS);
    ssSetInputPortDirectFeedThrough(S, 0, 1);

    ssSetOutputPortWidth(S, 0, NUM_OUTPUTS);

    ssSetNumSampleTimes(S, 2);

    ssSetNumRWork(S, 0);
    ssSetNumIWork(S, 0);
    ssSetNumPWork(S, 0);
    ssSetNumModes(S, 0);
    ssSetNumNonsampledZCs(S, 0);

    ssSetOptions(S, 0);
}

/* Function: mdlInitializeSampleTimes =========================================
 * Abstract:
 *    Two sample times are set here:
 *    1. Continuous sample time
 *    2. Discrete sample time of 0.1 seconds
 */
static void mdlInitializeSampleTimes(SimStruct *S)
{
    ssSetSampleTime(S, 0, CONTINUOUS_SAMPLE_TIME);
    ssSetSampleTime(S, 1, Ts);
    ssSetOffsetTime(S, 0, 0.0);
    ssSetOffsetTime(S, 1, 0.0);
}

/* Function: mdlInitializeConditions ==========================================
 * Abstract:
 *    Initialize both the continuous and discrete states
 */
#define MDL_INITIALIZE_CONDITIONS
static void mdlInitializeConditions(SimStruct *S)
{
    real_T *xC = ssGetContStates(S);
    real_T *xD = ssGetDiscStates(S);

    xC[0] = 0.0;  /* x1 */
    xC[1] = 0.0;  /* x2 */
    
    xD[0] = 0.0;  /* x_k */
    xD[1] = 0.0;  /* x_{k-1} */
}

/* Function: mdlOutputs =======================================================
 * Abstract:
 *    Compute the outputs y = (x1, x2, x_{k-1}, x_k)
 */
static void mdlOutputs(SimStruct *S, int_T tid)
{
    real_T *y = ssGetOutputPortRealSignal(S, 0);
    real_T *xC = ssGetContStates(S);
    real_T *xD = ssGetDiscStates(S);

    y[0] = xC[0];  /* x1 */
    y[1] = xC[1];  /* x2 */
    y[2] = xD[1];  /* x_{k-1} */
    y[3] = xD[0];  /* x_k */
}

/* Function: mdlUpdate ========================================================
 * Abstract:
 *    Update discrete states x_k every 0.1 seconds
 */
#define MDL_UPDATE
static void mdlUpdate(SimStruct *S, int_T tid)
{
    if (ssIsSampleHit(S, 1, tid)) {
        real_T *xD = ssGetDiscStates(S);
        int_T k = ssGetT(S) / Ts;  /* Get the current time step k */
        
        real_T x_k_minus_1 = xD[1];
        real_T x_k = xD[0];
        
        xD[1] = x_k;  /* x_{k-1} = x_k */
        xD[0] = x_k + 2 * x_k_minus_1 * sin(k * Ts);  /* Update x_k */
    }
}

/* Function: mdlDerivatives ===================================================
 * Abstract:
 *    Compute the derivatives for continuous states
 */
#define MDL_DERIVATIVES
static void mdlDerivatives(SimStruct *S)
{
    real_T *dx = ssGetdX(S);
    real_T *xC = ssGetContStates(S);
    real_T *xD = ssGetDiscStates(S);
    InputRealPtrsType uPtrs = ssGetInputPortRealSignalPtrs(S, 0);

    dx[0] = xC[1];  /* dx1/dt = x2 */
    dx[1] = xC[0] * xC[1] + xD[0] + U(0);  /* dx2/dt = x1 * x2 + x_k + u */
}

/* Function: mdlTerminate =====================================================
 * Abstract:
 *    No cleanup is necessary
 */
static void mdlTerminate(SimStruct *S)
{
    /* No termination required */
}

#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
#include "simulink.c"      /* MEX-file interface mechanism */
#else
#include "cg_sfun.h"       /* Code generation registration function */
#endif