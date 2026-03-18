#define S_FUNCTION_NAME  SfuncI2Level2
#define S_FUNCTION_LEVEL 2

#include "simstruc.h"

/* Function: mdlInitializeSizes =========================================
 * Abstract:
 *    Specify the number of input and output ports and other basic properties.
 */
static void mdlInitializeSizes(SimStruct *S)
{
    /* Number of parameters (T, Ts, k, Q) */
    ssSetNumSFcnParams(S, 1);

    /* Input ports */
    if (!ssSetNumInputPorts(S, 1)) return;
    ssSetInputPortWidth(S, 0, 1); /* Scalar input */
    ssSetInputPortDirectFeedThrough(S, 0, 0); /* No direct feedthrough */

    /* Output ports */
    if (!ssSetNumOutputPorts(S, 1)) return;
    ssSetOutputPortWidth(S, 0, 1); /* Scalar output (integral) */

    /* Set number of discrete states (N + 2 for input samples and integral) */
    ssSetNumDWork(S, 1);
    ssSetDWorkWidth(S, 0, ssGetSFcnParam(S, 0) + 2); /* N + 2 */
    ssSetDWorkDataType(S, 0, SS_DOUBLE);

    /* Sample times */
    ssSetNumSampleTimes(S, 1);

    /* SimState compliance */
    ssSetSimStateCompliance(S, USE_DEFAULT_SIM_STATE);
}

/* Function: mdlInitializeSampleTimes =====================================
 * Abstract:
 *    Specify the sample time for the block.
 */
static void mdlInitializeSampleTimes(SimStruct *S)
{
    real_T *ParamI2 = mxGetPr(ssGetSFcnParam(S, 0)); /* Retrieve the parameter data */
    ssSetSampleTime(S, 0, ParamI2[1]); /* Set sample time to Ts */
    ssSetOffsetTime(S, 0, 0.0);
}

/* Function: mdlInitializeConditions =====================================
 * Abstract:
 *    Initialize the discrete states.
 */
#define MDL_INITIALIZE_CONDITIONS
static void mdlInitializeConditions(SimStruct *S)
{
    real_T *x = ssGetDWork(S, 0);
    int_T N = ssGetDWorkWidth(S, 0);

    /* Initialize all states to zero */
    for (int i = 0; i < N; i++) {
        x[i] = 0.0;
    }
}

/* Function: mdlOutputs ===================================================
 * Abstract:
 *    Calculate the output (integral value) for the block.
 */
static void mdlOutputs(SimStruct *S, int_T tid)
{
    real_T *x = ssGetDWork(S, 0);
    real_T *y = ssGetOutputPortRealSignal(S, 0);

    /* Output the integral value */
    y[0] = x[ssGetDWorkWidth(S, 0) - 1]; /* Last element in the discrete states is the integral */
}

/* Function: mdlUpdate ===================================================
 * Abstract:
 *    Update the discrete states with new input data.
 */
#define MDL_UPDATE
static void mdlUpdate(SimStruct *S, int_T tid)
{
    real_T *x = ssGetDWork(S, 0);
    InputRealPtrsType uPtrs = ssGetInputPortRealSignalPtrs(S, 0);

    real_T *ParamI2 = mxGetPr(ssGetSFcnParam(S, 0));
    real_T Ts = ParamI2[1];
    real_T T = ParamI2[0];
    real_T Q = ParamI2[2];
    real_T k = ParamI2[3];
    int_T N = (int_T)(T / Ts);
    
    real_T t = ssGetT(S);
    int_T idx = (int_T)(t / Ts) + 1;

    if (t <= T) {
        /* Stack and update samples */
        x[idx - 1] = *uPtrs[0];
    } else {
        /* Shift samples */
        for (int i = 0; i < N; i++) {
            x[i] = x[i + 1];
        }
        x[N] = *uPtrs[0];
    }

    /* Compute the integral using trapezoidal rule */
    real_T integral = 0.0;
    real_T tau;
    int_T len = (t <= T) ? idx : N + 1;
    real_T Tlen = (t <= T) ? (idx - 1) * Ts : T;

    for (int i = 0; i < len; i++) {
        tau = (t <= T) ? (i * Ts) : (t - T + i * Ts);
        integral += Q * x[i]; /* Here we assume Q is a constant */
    }

    integral *= (1 / pow(T, k)) * (T / (2 * N));

    /* Update the integral value in the last state */
    x[N + 1] = integral;
}

/* Function: mdlTerminate =================================================
 * Abstract:
 *    Perform any necessary clean up.
 */
static void mdlTerminate(SimStruct *S)
{
    /* No clean up required */
}

/* Required S-function trailer */
#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
#include "simulink.c"      /* MEX-file interface mechanism */
#else
#include "cg_sfun.h"       /* Code generation interface mechanism */
#endif


// #define S_FUNCTION_NAME  SfuncI2
// #define S_FUNCTION_LEVEL 2
// 
// #include "simstruc.h"
// 
// /* Function to compute the trapezoidal integral */
// real_T compute_trapz(SimStruct *S, real_T *x, int len, real_T *tau, real_T T, real_T t, real_T k, real_T (*Q)(real_T, real_T, real_T)) {
//     real_T Integral = 0.0;
// 
//     /* Compute integrand */
//     real_T integrand[100]; /* Assuming max 100 points */
//     for (int i = 0; i < len; i++) {
//         integrand[i] = Q(tau[i], t, T) * x[i];
//     }
// 
//     /* Trapezoidal integration */
//     for (int i = 0; i < len - 1; i++) {
//         Integral += (tau[i + 1] - tau[i]) * (integrand[i] + integrand[i + 1]) / 2.0;
//     }
// 
//     return (1.0 / pow(T, k)) * (T / (2 * len)) * Integral;
// }
// 
// /* Initialization */
// static void mdlInitializeSizes(SimStruct *S)
// {
//     ssSetNumSFcnParams(S, 1);  /* Number of expected parameters */
//     ssSetNumContStates(S, 0);  /* Number of continuous states */
//     ssSetNumDiscStates(S, 0);  /* Number of discrete states */
// 
//     /* Input and Output */
//     if (!ssSetNumInputPorts(S, 1)) return;
//     ssSetInputPortWidth(S, 0, 1);
//     ssSetInputPortDirectFeedThrough(S, 0, 1);
// 
//     if (!ssSetNumOutputPorts(S, 1)) return;
//     ssSetOutputPortWidth(S, 0, 1);
// 
//     ssSetNumSampleTimes(S, 1); /* Number of sample times */
// 
//     /* Define DWork vector for storing states */
//     int_T N = (int_T)mxGetPr(ssGetSFcnParam(S, 0))[0]; /* N is passed as a parameter */
//     ssSetNumDWork(S, 1);
//     ssSetDWorkWidth(S, 0, N + 2); /* N samples plus integral */
//     ssSetDWorkDataType(S, 0, SS_DOUBLE); /* Double precision */
// }
// 
// /* Initialize sample times */
// static void mdlInitializeSampleTimes(SimStruct *S)
// {
//     real_T Ts = mxGetPr(ssGetSFcnParam(S, 1))[0];
//     ssSetSampleTime(S, 0, Ts);
//     ssSetOffsetTime(S, 0, 0.0);
// }
// 
// /* Output function */
// static void mdlOutputs(SimStruct *S, int_T tid)
// {
//     real_T *y = ssGetOutputPortRealSignal(S, 0);
//     real_T *x = (real_T*) ssGetDWork(S, 0);
//     int_T N = (int_T) mxGetPr(ssGetSFcnParam(S, 0))[0];
// 
//     /* Return the integral stored at x[N+2] */
//     y[0] = x[N+1];
// }
// 
// /* Update function */
// static void mdlUpdate(SimStruct *S, int_T tid)
// {
//     real_T t = ssGetT(S);
//     real_T Ts = mxGetPr(ssGetSFcnParam(S, 1))[0];
//     real_T T = mxGetPr(ssGetSFcnParam(S, 2))[0];
//     real_T k = mxGetPr(ssGetSFcnParam(S, 3))[0];
//     int_T N = (int_T) mxGetPr(ssGetSFcnParam(S, 0))[0];
//     real_T *Q = mxGetPr(ssGetSFcnParam(S, 4));
// 
//     /* Get input */
//     real_T *u = (real_T*) ssGetInputPortRealSignal(S, 0);
//     real_T *x = (real_T*) ssGetDWork(S, 0);
// 
//     /* Current index based on time */
//     int_T idx = (int_T)(t / Ts) + 1;
// 
//     /* Store input sample and shift history */
//     if (t <= T) {
//         x[idx - 1] = u[0];
//     } else {
//         for (int i = 0; i < N; i++) {
//             x[i] = x[i + 1];
//         }
//         x[N] = u[0];
//     }
// 
//     /* Compute the trapezoidal integral */
//     real_T tau[100];
//     for (int i = 0; i < idx; i++) {
//         tau[i] = (t <= T) ? (i * Ts) : (t - T + i * Ts);
//     }
// 
//     real_T Integral = compute_trapz(S, x, idx, tau, T, t, k, Q);
//     x[N + 1] = Integral; /* Store integral */
// }
// 
// /* Termination function */
// static void mdlTerminate(SimStruct *S)
// {
// }
// 
// /* Required S-function trailer */
// #ifdef MATLAB_MEX_FILE
// #include "simulink.c"      /* MEX-file interface mechanism */
// #else
// #include "cg_sfun.h"       /* Code generation registration function */
// #endif