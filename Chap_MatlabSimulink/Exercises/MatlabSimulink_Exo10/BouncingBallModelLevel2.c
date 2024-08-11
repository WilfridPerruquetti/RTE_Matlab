#define S_FUNCTION_NAME  bouncing_ball_sfunc
#define S_FUNCTION_LEVEL 2

#include "simstruc.h"

/* Parameters */
#define G_IDX 0
#define E_IDX 1
#define NPARAMS 2

/* Continuous states */
#define Y_IDX 0
#define V_IDX 1

/* Initial conditions */
#define Y0_IDX 0
#define V0_IDX 1
#define NSTATES 2

/* Function: mdlInitializeSizes ===============================================*/
static void mdlInitializeSizes(SimStruct *S) {
    ssSetNumContStates(S, 2);
    ssSetNumDiscStates(S, 0);
    ssSetNumInputs(S, 0);
    ssSetNumOutputs(S, 2);
    ssSetNumSampleTimes(S, 1);
    ssSetNumRWork(S, 0);
    ssSetNumIWork(S, 0);
    ssSetNumPWork(S, 0);
    ssSetNumModes(S, 0);
    ssSetNumNonsampledZCs(S, 0);
    
    ssSetNumSFcnParams(S, NPARAMS);
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
        return;
    }
}

/* Function: mdlInitializeSampleTimes =========================================*/
static void mdlInitializeSampleTimes(SimStruct *S) {
    ssSetSampleTime(S, 0, CONTINUOUS_SAMPLE_TIME);
    ssSetOffsetTime(S, 0, 0.0);
}

/* Function: mdlInitializeConditions ==========================================*/
#define MDL_INITIALIZE_CONDITIONS
static void mdlInitializeConditions(SimStruct *S) {
    real_T *x0 = ssGetContStates(S);
    x0[Y_IDX] = mxGetPr(ssGetSFcnParam(S, Y0_IDX))[0];
    x0[V_IDX] = mxGetPr(ssGetSFcnParam(S, V0_IDX))[0];
}

/* Function: mdlDerivatives ===================================================*/
#define MDL_DERIVATIVES
static void mdlDerivatives(SimStruct *S) {
    real_T *dx = ssGetdX(S);
    real_T *x = ssGetContStates(S);
    real_T g = mxGetPr(ssGetSFcnParam(S, G_IDX))[0];

    dx[Y_IDX] = x[V_IDX];
    dx[V_IDX] = -g;
}

/* Function: mdlOutputs =======================================================*/
#define MDL_OUTPUTS
static void mdlOutputs(SimStruct *S, int_T tid) {
    real_T *y = ssGetOutputPortRealSignal(S,0);
    real_T *x = ssGetContStates(S);

    y[0] = x[Y_IDX];
    y[1] = x[V_IDX];
}

/* Function: mdlUpdate ========================================================*/
#define MDL_UPDATE
static void mdlUpdate(SimStruct *S, int_T tid) {
    real_T *x = ssGetContStates(S);
    real_T e = mxGetPr(ssGetSFcnParam(S, E_IDX))[0];

    if (x[Y_IDX] <= 0 && x[V_IDX] < 0) {
        x[V_IDX] = -e * x[V_IDX];
    }
}

/* Function: mdlTerminate =====================================================*/
static void mdlTerminate(SimStruct *S) {
    /* No termination needed */
}

/* Required S-function trailer */
#ifdef  MATLAB_MEX_FILE
#include "simulink.c"      /* MEX-file interface mechanism */
#else
#include "cg_sfun.h"       /* Code generation registration function */
#endif