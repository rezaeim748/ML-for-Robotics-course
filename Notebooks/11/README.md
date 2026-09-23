# Model-Based Reinforcement Learning and Policy Distillation

## Overview

This notebook explores **Model-Based Reinforcement Learning (MBRL)**, where an agent learns a predictive model of the environment dynamics and uses that model for planning and decision-making.

The notebook applies MBRL to a custom MuJoCo CartPole environment. A neural network is trained as a forward dynamics model, while a Cross-Entropy Method (CEM) planner uses the learned model to select actions. The notebook then introduces **policy distillation**, transferring the behavior of the computationally expensive planning agent into a simpler neural-network policy.

Finally, a hybrid planning and policy-learning agent is explored to combine the data efficiency of model-based methods with the faster inference of learned policies.

---

## 1. Imports and Environment Setup

The notebook begins by importing the required libraries, including:

- Gymnasium
- MuJoCo
- PyTorch
- TorchRL
- NumPy
- Matplotlib
- MediaPy

A custom `MujocoCartPoleEnv` environment is implemented with configurable physical parameters such as cart mass, pole mass, pole length, gravity, and simulation timestep.

A helper function is also provided for rendering complete episodes and evaluating cumulative return.

---

## 2. Model-Based Reinforcement Learning

Model-Based Reinforcement Learning differs from model-free reinforcement learning by explicitly learning or using a model of the environment dynamics.

Instead of learning behavior entirely through trial and error, the agent predicts how the environment will respond to possible actions and uses these predictions to plan ahead.

The basic workflow is:

**collect transitions → learn dynamics model → predict future states → plan actions → interact with environment → update model**

### Conclusion

MBRL can make more efficient use of collected data because the learned model allows the agent to simulate possible future outcomes without executing every candidate action in the real environment.

However, planning can be computationally expensive, and inaccurate learned models can lead the planner toward poor decisions.

---

## 3. Objective Function

A quadratic cost function is defined to measure how far a predicted trajectory deviates from a desired state.

Different state variables can be assigned different weights, allowing the planner to prioritize particular aspects of the system.

The planner attempts to find actions that minimize this trajectory cost.

### Conclusion

The objective function connects model predictions to decision making. Once future trajectories can be predicted, their costs can be compared to determine which actions are preferable.

---

## 4. Learning the Forward Dynamics Model

A neural network is implemented as a **forward dynamics model**.

The model receives:

- Current state
- Current action

and predicts the next state.

Rather than predicting the next state completely from scratch, the network predicts a change that is added to the current state through a residual connection.

The model is trained using previously collected state transitions.

### Conclusion

Learning the environment dynamics transforms the reinforcement-learning problem partly into a supervised-learning problem.

Given examples of `(state, action, next_state)`, the neural network learns to approximate how the physical system evolves over time.

---

## 5. Replay Buffer and Supervised Model Learning

Transitions collected while interacting with the environment are stored in a replay buffer.

Mini-batches are sampled from this buffer and used to train the forward model with **Mean Squared Error (MSE)** between the predicted and actual next states.

The model is periodically updated using multiple gradient steps.

### Conclusion

The replay buffer allows collected experience to be reused for training the dynamics model, improving data efficiency.

However, minimizing one-step MSE does not necessarily guarantee accurate long-term trajectories. Small prediction errors can accumulate when the learned model is repeatedly applied during planning.

---

## 6. Planning with the Learned Model

After an initial data-collection period, the agent begins selecting actions using a planner rather than random exploration.

The learned world model is wrapped using TorchRL components, and a **Cross-Entropy Method (CEM) planner** searches for promising action sequences.

The planner evaluates candidate actions by predicting their consequences with the learned dynamics model and comparing their trajectory costs.

### Conclusion

Planning allows the agent to use its learned knowledge of the environment to reason about future consequences before taking an action.

This can substantially improve data efficiency, although evaluating many candidate trajectories makes planning computationally expensive.

---

## 7. Training the MBRL Agent

The MBRL agent initially takes random actions to collect enough transition data for learning.

After the initialization period, the forward model is trained periodically and the CEM planner begins using the learned model for action selection.

Episode length and cumulative reward are recorded during training.

### Conclusion

The experiment demonstrates the characteristic trade-off of model-based reinforcement learning: fewer environment interactions may be required to learn useful behavior, but each action can require considerably more computation because planning must be performed online.

---

## 8. Model-Based vs. Model-Free Reinforcement Learning

The notebook considers the differences between MBRL and previously studied model-free algorithms such as:

- DQN
- REINFORCE
- Actor-Critic methods

The comparison focuses particularly on:

- Data efficiency
- Wall-clock training time
- Computational requirements
- Inference speed

### Conclusion

Model-based approaches can be more data efficient because they reuse a learned model for planning. Model-free approaches avoid this planning overhead and can therefore be computationally cheaper once a policy has been learned.

This motivates combining the advantages of both approaches.

---

## 9. Limitations of MSE-Based Dynamics Learning

The notebook also considers potential problems with training the forward model purely using MSE.

A dynamics model optimized for one-step prediction accuracy is not necessarily optimized for producing trajectories that are useful for maximizing reward.

Prediction errors can accumulate over multiple simulated steps, especially in regions where little training data has been collected.

### Conclusion

Accurate one-step state prediction and good control performance are related but not identical objectives.

A model can achieve relatively low prediction error while still making mistakes that significantly affect planning and reward optimization.

---

## 10. Policy Distillation

The second major part of the notebook introduces **Policy Distillation**.

Policy distillation transfers behavior from a high-performing but computationally expensive **teacher policy** into a simpler **student policy**.

In this notebook:

- The MBRL planner acts as the teacher.
- A neural network acts as the student.

The goal is to preserve useful planning behavior while reducing the computational cost of action selection.

---

## 11. Deterministic Neural Network Policy

A small deterministic neural network is defined to map observations directly to actions.

Unlike the CEM planner, this policy does not need to simulate thousands of candidate trajectories whenever an action is required.

Instead, action selection requires only a forward pass through the neural network.

### Conclusion

A neural-network policy can provide substantially faster inference than online planning.

The challenge is transferring enough of the planner's behavior into the policy without losing too much control performance.

---

## 12. Distilling the MBRL Planner

States are sampled from the MBRL agent's replay buffer.

For each state, the CEM planner generates an action. These state-action pairs are then used as supervised training examples for the student policy.

The student network minimizes the MSE between:

**planner action → neural-network policy action**

### Conclusion

Policy distillation converts the behavior generated by an expensive planning procedure into a direct state-to-action mapping.

This allows knowledge acquired through model-based planning to be deployed through a computationally cheaper policy.

---

## 13. Comparing Planner and Policy Inference

The notebook proposes comparing the inference time of:

- The CEM planner
- The distilled neural-network policy

The planner repeatedly evaluates candidate future trajectories, whereas the neural network directly computes an action from the current state.

### Conclusion

This comparison highlights the trade-off between sophisticated online planning and fast policy execution.

Planning can exploit the learned dynamics model directly, while a distilled policy sacrifices online planning in exchange for much faster inference.

---

## 14. Hybrid Policy and Planning Agent

The final section explores a **PolicyPlanningAgent** that simultaneously learns:

- A forward dynamics model
- A deterministic policy

The learned policy is used together with model-based trajectory prediction. Candidate action sequences are generated and evaluated through the learned dynamics model, while the policy helps guide future actions.

The forward model and policy are updated at different intervals using experience stored in the replay buffer.

### Conclusion

The hybrid approach attempts to combine the strongest properties of model-based and model-free reinforcement learning.

The learned dynamics model provides data-efficient planning, while the neural-network policy can provide faster action generation and guide the planning process toward promising trajectories.

---

## 15. Performance and Inference-Time Evaluation

The hybrid agent is evaluated using both control performance and computation time.

The notebook tracks:

- Episode score
- Episode length
- Average action inference time
- Start of model learning

Episodes can then be rendered using either the planner or the learned policy.

### Conclusion

Evaluating both reward and inference time is important because a controller that performs well but requires excessive computation may not be suitable for real-time applications.

The experiments therefore demonstrate the broader trade-off between **sample efficiency, computational cost, and policy performance**.

---

## Learning Outcomes

By completing this notebook, the following skills were developed:

- Understanding the principles of Model-Based Reinforcement Learning
- Distinguishing model-based and model-free RL
- Building a custom MuJoCo control environment
- Learning a forward dynamics model using supervised learning
- Using replay buffers for dynamics-model training
- Understanding the limitations of one-step MSE prediction
- Using learned models for trajectory prediction
- Planning actions with the Cross-Entropy Method
- Understanding the data-efficiency advantages of MBRL
- Understanding the computational cost of online planning
- Implementing policy distillation
- Training a deterministic policy to imitate a planning agent
- Comparing planner and neural-network inference time
- Combining learned policies with model-based planning
- Evaluating reinforcement-learning agents in terms of both performance and computational efficiency

This notebook provides a practical introduction to **Model-Based Reinforcement Learning**, progressing from learning environment dynamics and planning with a world model to policy distillation and hybrid policy-planning approaches. It highlights the central trade-off between the data efficiency of model-based methods and the computational efficiency of direct neural-network policies.
