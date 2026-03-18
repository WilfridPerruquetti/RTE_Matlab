
// #define S_FUNCTION_NAME  SfuncI1Level2
// #define S_FUNCTION_LEVEL 2
// 
// #include "simstruc.h"
// 
// /* Function to compute the trapezoidal integral */
// real_T compute_trapz(SimStruct *S, real_T *x, int idx, real_T *P) {
//     real_T Integral = 0.0;
//     if (idx == 1) {
//         return 0.0;
//     }
// 
//     /* Compute the integrand */
//     real_T tau[100]; /* Assuming max 100 points */
//     real_T integrand[100]; /* Store the integrand values */
// 
//     for (int i = 0; i < idx; i++) {
//         tau[i] = (real_T)i / (real_T)(idx - 1);
//         integrand[i] = P[i] * x[i];
//     }
// 
//     /* Trapezoidal integration */
//     for (int i = 0; i < idx - 1; i++) {
//         Integral += (tau[i + 1] - tau[i]) * (integrand[i] + integrand[i + 1]) / 2.0;
//     }
//     return Integral;
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
//     int_T N = (int_T) mxGetPr(ssGetSFcnParam(S, 0))[0];
//     real_T *P = mxGetPr(ssGetSFcnParam(S, 2));
// 
//     /* Get input */
//     real_T *u = (real_T*) ssGetInputPortRealSignal(S, 0);
//     real_T *x = (real_T*) ssGetDWork(S, 0);
// 
//     /* Current index based on time */
//     int_T idx = (int_T)(t / Ts) + 1;
// 
//     /* Store the input sample if within the time interval */
//     if (t <= N * Ts) {
//         x[idx - 1] = u[0];
//     }
// 
//     /* Compute the trapezoidal integral */
//     real_T Integral = compute_trapz(S, x, idx, P);
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