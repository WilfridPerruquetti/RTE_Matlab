#define S_FUNCTION_NAME  hybrid_Ex1
#define S_FUNCTION_LEVEL 2

#include "simstruc.h"
#include "math.h"

#define NCONTSTATES 2
#define NINPUTS 1
#define NOUTPUTS 4
#define NDWORKS 2

/* Function: mdlInitializeSizes ==============================================
 * Abstract:
 *    Setup sizes of the various vectors.
 */
static void mdlInitializeSizes(SimStruct *S)
{
    ssSetNumContStates(S, NCONTSTATES);
    ssSetNumDiscStates(S, 0);
    
    ssSetNumInputPorts(S, 1);
    ssSetInputPortWidth(S, 0, NINPUTS);
    ssSetInputPortDirectFeedThrough(S, 0, 1);
    
    ssSetNumOutputPorts(S, 1);
    ssSetOutputPortWidth(S, 0, NOUTPUTS);
    
    ssSetNumDWork(S, NDWORKS);
    
    ssSetDWorkWidth(S, 0, 1);
    ssSetDWorkDataType(S, 0, SS_DOUBLE);
    
    ssSetDWorkWidth(S, 1, 1);
    ssSetDWorkDataType(S, 1, SS_DOUBLE);
    
    ssSetNumSampleTimes(S, 2);
    
    ssSetNumRWork(S, 0);
    ssSetNumIWork(S, 0);
    ssSetNumPWork(S, 0);
    ssSetNumModes(S, 0);
    ssSetNumNonsampledZCs(S, 0);
    ssSetOperatingPointCompliance(S, USE_DEFAULT_OPERATING_POINT);
    /* Set this S-function as runtime thread-safe for multicore execution */
    ssSetRuntimeThreadSafetyCompliance(S, RUNTIME_THREAD_SAFETY_COMPLIANCE_TRUE);
    ssSetOptions(S, SS_OPTION_EXCEPTION_FREE_CODE);
}

/* Function: mdlInitializeSampleTimes ========================================
 * Abstract:
 *    Specify the sample time.
 */
static void mdlInitializeSampleTimes(SimStruct *S)
{
    ssSetSampleTime(S, 0, CONTINUOUS_SAMPLE_TIME);
    ssSetOffsetTime(S, 0, 0.0);

    ssSetSampleTime(S, 1, 0.5);
    ssSetOffsetTime(S, 1, 0.0);
    ssSetModelReferenceSampleTimeDefaultInheritance(S);
}

/* Function: mdlInitializeConditions ========================================
 * Abstract:
 *    Initialize the states.
 */
#define MDL_INITIALIZE_CONDITIONS
static void mdlInitializeConditions(SimStruct *S)
{
    real_T *x0 = ssGetContStates(S);
    real_T *dw1 = ssGetDWork(S, 0);
    real_T *dw2 = ssGetDWork(S, 1);
    
    x0[0] = 0.1;
    x0[1] = 0.2;
    dw1[0] = 1.0;
    dw2[0] = -2.0;
}

/* Function: mdlOutputs =======================================================
 * Abstract:
 *    Compute the outputs.
 */
static void mdlOutputs(SimStruct *S, int_T tid)
{
    const real_T *x = ssGetContStates(S);
    const real_T *dw1 = ssGetDWork(S, 0);
    const real_T *dw2 = ssGetDWork(S, 1);
    real_T *y = ssGetOutputPortRealSignal(S, 0);
    
    y[0] = x[0];
    y[1] = x[1];
    y[2] = dw1[0];
    y[3] = dw2[0];
}

/* Function: mdlUpdate =======================================================
 * Abstract:
 *    Update the discrete states.
 */
#define MDL_UPDATE
static void mdlUpdate(SimStruct *S, int_T tid)
{
    real_T *dw1 = ssGetDWork(S, 0);
    real_T *dw2 = ssGetDWork(S, 1);
    real_T t = ssGetT(S);
    
    UNUSED_ARG(tid); /* not used in single tasking mode */

    if (ssIsSampleHit(S, 1, tid)) {// Update at sample hit
        real_T xkminus1 = dw1[0];
        real_T xk = dw2[0];
        dw1[0] = xk;
        dw2[0] = xk + 0.01 * xkminus1 * sin(t);
    }

}

/* Function: mdlDerivatives ==================================================
 * Abstract:
 *    Compute the derivatives.
 */
#define MDL_DERIVATIVES
static void mdlDerivatives(SimStruct *S)
{
    const real_T *x = ssGetContStates(S);
    const real_T *dw1 = ssGetDWork(S, 0);
    const real_T *u = (const real_T*) ssGetInputPortSignal(S, 0);
    real_T *dx = ssGetdX(S);
    real_T t = ssGetT(S);
    
    dx[0] = x[1];
    dx[1] = -100 * x[0] - 14 * x[1] - x[0] * x[1] + sin(t) * dw1[0] + u[0];
}

/* Function: mdlTerminate =====================================================
 * Abstract:
 *    No termination needed.
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
 
