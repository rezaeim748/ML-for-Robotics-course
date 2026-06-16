# Robotics Control with MuJoCo: PID and LQR for Cart-Pole Stabilization

## Overview
This notebook introduces fundamental control concepts through simulation in MuJoCo. Using a cart-pole (inverted pendulum) system, it explores how different control strategies can stabilize unstable dynamic systems.

The notebook begins with basic simulation setup, then progresses through classical control methods such as PID and Linear Quadratic Regulator (LQR). Experiments are performed to observe how controller parameters and model assumptions affect system stability and performance.

---

## 1. Imports and Setup
The notebook starts by importing the required libraries for numerical computation, visualization, and physics simulation.

---

## 2. MuJoCo Simulation Environment
This section introduces MuJoCo and explains its role in simulating physical systems with realistic dynamics.

A simulation environment is created for a cart-pole system, including physical properties such as mass, gravity, and pole length.

### Topics Explored
- Physics-based simulation  
- Dynamic systems modeling  
- Cart-pole environment setup  
- State representation  

### Conclusion
The simulation environment provides a realistic platform for testing control strategies on unstable systems.

---

## 3. PID Control Basics
This section introduces the Proportional–Integral–Derivative (PID) controller, one of the most widely used feedback control methods.

The individual effects of proportional, integral, and derivative terms are explored to understand how each contributes to system behavior.

### Topics Explored
- Proportional control  
- Integral control  
- Derivative control  
- Error-based feedback  

### Conclusion
PID control demonstrates how feedback can gradually correct system errors and improve stability.

---

## 4. PID Control for Inverted Pendulum
In this section, PID control is applied to the cart-pole problem.

Different gain values are tested to find configurations capable of balancing the pole in its unstable upright position.

### Topics Explored
- Gain tuning  
- Closed-loop control  
- Stability analysis  
- Pole balancing  

### Conclusion
Balancing an inverted pendulum requires careful tuning. Poor gains lead to oscillations or failure, while well-tuned parameters stabilize the system successfully.

---

## 5. Controller Performance Evaluation
A quadratic cost function is introduced to quantitatively evaluate controller performance.

The cost penalizes both deviation from target states and excessive control effort.

### Topics Explored
- Cost functions  
- State error penalty  
- Control effort penalty  
- Performance comparison  

### Conclusion
The cost function provides an objective way to compare controllers, where lower cost indicates better control quality.

---

## 6. LQR Control
This section introduces the Linear Quadratic Regulator (LQR), an optimal control technique for linear systems.

The system dynamics are linearized around the equilibrium point, and an optimal feedback gain is computed.

### Topics Explored
- State-space models  
- Linearization  
- Optimal control  
- Gain computation  

### Conclusion
LQR produces a more systematic controller design by mathematically balancing performance and control effort.

---

## 7. Stability and Controllability Analysis
The system matrices are analyzed using eigenvalues and controllability concepts.

These properties determine whether the system is stable and whether all states can be controlled.

### Topics Explored
- Eigenvalue analysis  
- Open-loop stability  
- Controllability matrix  
- System behavior  

### Conclusion
The cart-pole system is naturally unstable in open loop, but full controllability enables stabilization through feedback control.

---

## 8. Model Misspecification
This section investigates how controller performance changes when the assumed model differs from the true physical system.

Parameters such as mass, pole length, and gravity are modified to test robustness.

### Topics Explored
- Modeling errors  
- Parameter uncertainty  
- Robustness analysis  
- Controller sensitivity  

### Conclusion
Controllers designed using imperfect models may still work within some error range, but large mismatches can significantly reduce stability and performance.

---

# Final Conclusion
This notebook demonstrates how unstable dynamic systems can be controlled using feedback control methods. Starting from PID control and progressing to LQR, the experiments show the importance of controller design, gain tuning, and accurate system modeling.

The results highlight that while simple controllers can stabilize the system with careful tuning, optimal methods such as LQR provide more principled and often more reliable solutions.