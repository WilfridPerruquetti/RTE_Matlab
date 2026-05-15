%% ========================================================================
%  OBSERVER TUNING: QUICK REFERENCE GUIDE
%  ========================================================================
%  A practical tool for practitioners
%% ========================================================================

% This script demonstrates the key findings from the book section
% and helps practitioners choose the right observer speed for their system

clear all; close all; clc;

fprintf('\n');
fprintf('╔══════════════════════════════════════════════════════════════════╗\n');
fprintf('║        OBSERVER TUNING GUIDELINES: Quick Reference Guide         ║\n');
fprintf('║                                                                  ║\n');
fprintf('║              Real-time estimation with saturation                ║\n');
fprintf('╚══════════════════════════════════════════════════════════════════╝\n\n');

%% CHECKLIST 1: Is your system suitable for observer-based control?
fprintf('CHECKLIST 1: System Assessment\n');
fprintf('─────────────────────────────────────────────────────────────────\n');

questions = {
    'Q1. Do you have actuator saturation (u_max < u_desired)?',
    'Q2. Do you have measurement noise in your sensors?',
    'Q3. Are there unmodeled delays or dynamics (computational, filtering)?',
    'Q4. Is your model uncertain (±20% or more in parameters)?',
    'Q5. Do you need real-time estimation (< 1 second)?',
    'Q6. Is measurement noise negligible (SNR > 60 dB)?',
    'Q7. Is actuator saturation rare (< 5% of time)?'
};

fprintf('\n');
for i = 1:length(questions)
    fprintf('%s\n', questions{i});
    fprintf('   Answer: [Yes/No]\n\n');
end

% Scoring
fprintf('\nScoring Guide:\n');
fprintf('  • If answers to Q2, Q3, Q4 are YES: → CONSERVATIVE tuning required\n');
fprintf('  • If answers to Q6, Q7 are YES: → Consider BALANCED tuning\n');
fprintf('  • If ALL Q6, Q7 answered NO: → AGGRESSIVE tuning (caution!)\n\n');

%% CHECKLIST 2: System parameters you need
fprintf('CHECKLIST 2: Required System Information\n');
fprintf('─────────────────────────────────────────────────────────────────\n');

fprintf('\n1. Plant Dynamics:\n');
fprintf('   [ ] A matrix (system dynamics)\n');
fprintf('   [ ] B matrix (input matrix)\n');
fprintf('   [ ] C matrix (measurement matrix)\n');
fprintf('   [ ] Actuator saturation limit u_max\n\n');

fprintf('2. Closed-Loop Design:\n');
fprintf('   [ ] Desired closed-loop poles (from your controller)\n');
fprintf('   [ ] Identify slowest (least negative) pole λ_cl,min\n');
fprintf('   [ ] Time constant: τ_cl = 1 / |λ_cl,min|\n\n');

fprintf('3. Sensor Characteristics:\n');
fprintf('   [ ] Measurement noise RMS (typical range: 0.1 - 10 mV)\n');
fprintf('   [ ] Sensor bandwidth\n');
fprintf('   [ ] Measurement delay (if any)\n\n');

fprintf('4. Model Uncertainty:\n');
fprintf('   [ ] Estimated parameter uncertainty (±5%, ±20%, ±50%?)\n');
fprintf('   [ ] Unmodeled dynamics (delays, friction, ...)\n\n');

%% DECISION TREE
fprintf('\nDECISION TREE: Choosing Observer Tuning\n');
fprintf('─────────────────────────────────────────────────────────────────\n\n');

fprintf('START HERE:\n\n');
fprintf('  ┌─ Is measurement noise > 1 mV RMS?\n');
fprintf('  │  ├─ YES: Has actuator saturation?\n');
fprintf('  │  │        ├─ YES: → CONSERVATIVE (2-3x)\n');
fprintf('  │  │        └─ NO:  → Try BALANCED (3-5x), then CONSERVATIVE if unstable\n');
fprintf('  │  │\n');
fprintf('  │  └─ NO:  Is your model very accurate (±5% error)?\n');
fprintf('  │         ├─ YES: → BALANCED to AGGRESSIVE (5-10x)\n');
fprintf('  │         └─ NO:  → CONSERVATIVE (2-3x)\n');
fprintf('  │\n');
fprintf('  └─ Result → Observer pole placement rule\n\n');

%% PRACTICAL TABLES
fprintf('REFERENCE TABLES\n');
fprintf('─────────────────────────────────────────────────────────────────\n\n');

fprintf('TABLE 1: Observer Pole Placement Rules\n\n');
fprintf('  ┌──────────────┬─────────────────┬──────────────┬──────────────┐\n');
fprintf('  │  Approach    │  Speed Ratio    │  τ_obs (s)   │  Noise Risk  │\n');
fprintf('  ├──────────────┼─────────────────┼──────────────┼──────────────┤\n');
fprintf('  │Conservative  │    2.0 - 3.0    │ 0.10 - 0.20  │     Low      │\n');
fprintf('  │  Balanced    │    3.0 - 5.0    │ 0.05 - 0.10  │   Medium     │\n');
fprintf('  │ Aggressive   │    5.0 - 10.0   │ 0.02 - 0.05  │     High     │\n');
fprintf('  │ Reckless     │    > 10.0       │   < 0.02     │   Very High  │\n');
fprintf('  └──────────────┴─────────────────┴──────────────┴──────────────┘\n\n');

fprintf('TABLE 2: When to Use Each Approach\n\n');
fprintf('  CONSERVATIVE (RECOMMENDED):\n');
fprintf('    ✓ Standard practice for industrial systems\n');
fprintf('    ✓ Good noise rejection (gain < 10)\n');
fprintf('    ✓ Robust to ±20% parameter uncertainty\n');
fprintf('    ✓ Safe with actuator saturation\n');
fprintf('    ✗ Slower convergence (0.1-0.2 s)\n\n');

fprintf('  BALANCED (INTERMEDIATE):\n');
fprintf('    ~ Faster than conservative (0.05-0.1 s)\n');
fprintf('    ~ Moderate noise amplification (10-20)\n');
fprintf('    ~ Requires careful validation\n');
fprintf('    ✗ Sensitive to unmodeled dynamics\n\n');

fprintf('  AGGRESSIVE (HIGH RISK):\n');
fprintf('    + Very fast observer (< 0.05 s)\n');
fprintf('    - High noise amplification (> 20)\n');
fprintf('    - Fragile with saturation\n');
fprintf('    - Requires perfect model & clean sensors\n');
fprintf('    ✗ Use only after extensive testing\n\n');

%% ANTI-WINDUP IMPLEMENTATION
fprintf('TABLE 3: Anti-Windup Implementation\n\n');

fprintf('  Method 1: Feed Saturated Input (RECOMMENDED)\n');
fprintf('  ─────────────────────────────────────────────\n');
fprintf('  \\dot{\\hat{x}} = A\\hat{x} + B u_sat + L(y - C\\hat{x})\n\n');
fprintf('  where u_sat = sat(u) = actual saturated control applied\n');
fprintf('  \n');
fprintf('  Advantages:\n');
fprintf('    ✓ Simple to implement\n');
fprintf('    ✓ Observer knows when saturation happens\n');
fprintf('    ✓ Prevents windup effectively\n');
fprintf('    ✓ Standard in industry\n\n');

fprintf('  Implementation in Matlab/Simulink:\n');
fprintf('    u_desired = -K * (x_hat - x_ref);          %% Desired control\n');
fprintf('    u_actual = saturate(u_desired, u_max);     %% Clipped control\n');
fprintf('    x_hat_dot = A*x_hat + B*u_actual + L*(y - C*x_hat);\n\n');

fprintf('  Method 2: Limit Output Innovation (SECONDARY)\n');
fprintf('  ──────────────────────────────────────────────\n');
fprintf('  \\dot{\\hat{x}} = A\\hat{x} + B u + L sat_ε(y - C\\hat{x})\n\n');
fprintf('  Advantages:\n');
fprintf('    ~ Reduces observer aggressiveness\n');
fprintf('    ~ Helps prevent windup\n\n');
fprintf('  Disadvantages:\n');
fprintf('    ✗ Less effective than Method 1\n');
fprintf('    ✗ Requires tuning additional parameter ε\n');
fprintf('    ✗ Can lose observability\n\n');

%% STEP-BY-STEP TUNING PROCEDURE
fprintf('STEP-BY-STEP TUNING PROCEDURE\n');
fprintf('─────────────────────────────────────────────────────────────────\n\n');

procedure_steps = {
    'Step 1: Measure your system characteristics',
    '        • Identify A, B, C matrices',
    '        • Measure/estimate u_max',
    '        • Measure sensor noise RMS',
    '',
    'Step 2: Design your closed-loop controller',
    '        • Choose closed-loop poles',
    '        • Compute K via pole placement or LQR',
    '        • Identify slowest CL pole λ_cl,min',
    '',
    'Step 3: START CONSERVATIVE',
    '        • Set speed ratio = 2.5',
    '        • Observer poles = 2.5 × [λ_cl,min, ...]',
    '        • Compute observer gain L via place(A'', C'', obs_poles)''',
    '',
    'Step 4: Implement anti-windup (Method 1)',
    '        • Feed saturated input u_sat to observer',
    '        • Verify implementation in simulation',
    '',
    'Step 5: Simulate with realistic conditions',
    '        • Include sensor noise',
    '        • Include actuator saturation',
    '        • Check estimation error < acceptable threshold',
    '        • Check control input is smooth (not chattering)',
    '',
    'Step 6: If performance is GOOD:',
    '        • Test with ±20% parameter perturbations',
    '        • Validate on hardware',
    '        • Done! Use this tuning',
    '',
    'Step 7: If performance is SLOW:',
    '        • Increase speed ratio to 3.5',
    '        • Repeat steps 5-6',
    '',
    'Step 8: If instability or noise issues appear:',
    '        • Go back to Step 3, reduce speed ratio to 2.0',
    '        • Revalidate',
    '',
    'Step 9: Only move to BALANCED/AGGRESSIVE if:',
    '        • Sensor noise is definitely < 0.5 mV',
    '        • Model uncertainty is < ±10%',
    '        • Saturation is rare (< 5% time)',
    '        • Hardware testing confirms stability'
};

fprintf('\n');
for i = 1:length(procedure_steps)
    fprintf('%s\n', procedure_steps{i});
end

fprintf('\n');

%% COMMON MISTAKES
fprintf('\n');
fprintf('COMMON MISTAKES TO AVOID\n');
fprintf('─────────────────────────────────────────────────────────────────\n\n');

mistakes = {
    '❌ MISTAKE 1: Placing observer poles too fast',
    '   Symptom: High-frequency noise in state estimates',
    '   Remedy: Reduce speed ratio back to 2-3',
    '',
    '❌ MISTAKE 2: Not implementing anti-windup',
    '   Symptom: Estimation error grows during saturation',
    '   Remedy: Feed saturated control signal to observer',
    '',
    '❌ MISTAKE 3: Ignoring measurement noise in design',
    '   Symptom: Poor closed-loop performance despite good simulation',
    '   Remedy: Add realistic noise model to simulation',
    '',
    '❌ MISTAKE 4: Only testing with nominal model',
    '   Symptom: System unstable when parameters change',
    '   Remedy: Always test ±20% parametric variations',
    '',
    '❌ MISTAKE 5: Using different observer and control rates',
    '   Symptom: Phase lag, instability at high frequencies',
    '   Remedy: Keep observer and control sampling rates synchronized',
    '',
    '❌ MISTAKE 6: Placing poles too close to origin',
    '   Symptom: Very slow observer, no benefit',
    '   Remedy: Ensure observer faster than slowest CL pole',
    '',
    '❌ MISTAKE 7: Aggressive tuning without validation',
    '   Symptom: Works in simulation, fails on hardware',
    '   Remedy: Always validate on actual system'
};

fprintf('\n');
for i = 1:length(mistakes)
    fprintf('%s\n', mistakes{i});
end

fprintf('\n\n');

%% SUMMARY TABLE
fprintf('SUMMARY: Which Approach Should YOU Use?\n');
fprintf('─────────────────────────────────────────────────────────────────\n\n');

fprintf('System Type                          │ Recommended Approach\n');
fprintf('────────────────────────────────────┼──────────────────────────────────\n');
fprintf('Industrial robot (+noise, +uncertain)│ CONSERVATIVE (2-3x)\n');
fprintf('Drone control (+saturation, +noise)  │ CONSERVATIVE (2-3x)\n');
fprintf('Laboratory with clean sensors        │ BALANCED (3-5x) after validation\n');
fprintf('High-speed digital control           │ BALANCED (3-5x) with care\n');
fprintf('Well-calibrated lab system           │ Can try AGGRESSIVE (5-10x)\n');
fprintf('Unknown system with lots of noise    │ CONSERVATIVE (2-3x) → BALANCED\n');
fprintf('System with model errors > ±20%      │ CONSERVATIVE (2x) - be careful!\n\n');

%% FINAL RECOMMENDATIONS
fprintf('═════════════════════════════════════════════════════════════════\n');
fprintf('FINAL RECOMMENDATIONS FOR YOUR BOOK\n');
fprintf('═════════════════════════════════════════════════════════════════\n\n');

fprintf('1. DEFAULT CHOICE: Always start with CONSERVATIVE (2-3x)\n');
fprintf('   Reason: It works in 95%% of real systems\n\n');

fprintf('2. ONLY move to BALANCED after:\n');
fprintf('   ✓ Closed-loop simulations succeed\n');
fprintf('   ✓ ±20%% parameter uncertainty handled\n');
fprintf('   ✓ Measurement noise is characterized\n');
fprintf('   ✓ Hardware testing confirms stability\n\n');

fprintf('3. NEVER use AGGRESSIVE without:\n');
fprintf('   ✓ Extensive simulation validation\n');
fprintf('   ✓ Hardware-in-the-loop testing\n');
fprintf('   ✓ Clear justification (e.g., medical device needing < 50 ms response)\n\n');

fprintf('4. ALWAYS implement anti-windup:\n');
fprintf('   ✓ Feed saturated input (Method 1) to observer\n');
fprintf('   ✓ This is NON-NEGOTIABLE for systems with actuator limits\n\n');

fprintf('5. ALWAYS validate:\n');
fprintf('   ✓ Simulation with noise and saturation\n');
fprintf('   ✓ Parametric robustness ±20%%\n');
fprintf('   ✓ Hardware testing before deployment\n\n');

fprintf('═════════════════════════════════════════════════════════════════\n');
fprintf('End of Quick Reference Guide\n');
fprintf('═════════════════════════════════════════════════════════════════\n\n');

% Offer to run testbenches
fprintf('Next Steps:\n');
fprintf('  1. Run observer_tuning_testbench.m for detailed simulation\n');
fprintf('  2. Run observer_parametric_sweep.m for trade-off analysis\n');
fprintf('  3. Adapt to your specific system and validate on hardware\n\n');
