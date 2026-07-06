# Reinforcement Learning with Markov Decision Processes, Dynamic Programming, Monte Carlo Methods, and Q-Learning

## Overview

This notebook introduces the fundamental concepts of **Reinforcement Learning (RL)** through a simple grid-world environment. It gradually builds from the mathematical formulation of **Markov Decision Processes (MDPs)** to planning algorithms based on **Dynamic Programming**, and finally to **model-free learning** using **Monte Carlo methods** and **Q-Learning**.

Throughout the notebook, an agent learns how to navigate toward a goal while maximizing long-term rewards, illustrating the core ideas behind modern reinforcement learning.

---

## 1. Imports

This section imports the required libraries used throughout the notebook.

### Packages Used

* **NumPy** for numerical computations
* **Matplotlib** for visualization
* **Gymnasium** for creating and interacting with reinforcement learning environments

### Conclusion

This section prepares the programming environment for the reinforcement learning experiments.

---

## 2. Markov Decision Processes (MDPs)

The notebook begins by introducing the reinforcement learning problem as a **Markov Decision Process (MDP)**.

An agent interacts with the environment by repeatedly:

1. Observing its current state
2. Choosing an action
3. Receiving a reward
4. Transitioning to a new state

The objective is to maximize the cumulative future reward.

### Topics Explored

* States and actions
* Rewards
* State transitions
* Episodes
* Discounted return

### Environment

The notebook uses a simple grid-world where:

* A blue agent starts from an initial position.
* A red square represents the goal.
* Each action moves the agent in one of four directions.
* The episode terminates once the goal is reached.

### Tasks

* Analyze why giving only a terminal reward is not ideal.
* Modify the reward structure to encourage shorter paths.

### Conclusion

The MDP framework provides the mathematical foundation for reinforcement learning by describing how agents interact with uncertain environments.

---

## 3. Computing Policies and Value Functions with Dynamic Programming

This section introduces **Dynamic Programming (DP)** for computing value functions when the environment dynamics are fully known.

Policies describe how an agent selects actions, while value functions estimate the expected future reward from each state.

### Topics Explored

* Policies
* State-value function (V(s))
* Action-value function (Q(s,a))
* Bellman Expectation Equation
* Policy evaluation

### Experiments

The notebook investigates how changing:

* the discount factor ((\gamma))
* the policy

affects the computed value function.

### Tasks

* Explore different discount factors.
* Compare deterministic and random policies.
* Compute action-value functions.

### Conclusion

Dynamic programming computes exact value functions by repeatedly applying the Bellman equations, assuming complete knowledge of the environment.

---

## 4. Acting Optimally

This section extends policy evaluation to finding the **optimal policy**.

Rather than evaluating a fixed policy, the goal is to determine the policy that maximizes the expected discounted return.

### Topics Explored

* Optimal policy
* Optimal value function
* Bellman Optimality Equation
* Policy improvement

### Tasks

* Verify the relationship between (V^*) and (Q^*).
* Recover the optimal state-value function from the optimal action-value function.

### Conclusion

The Bellman Optimality Equation allows an agent to determine the best possible action in every state when the environment model is known.

---

## 5. Learning Value Functions from Monte Carlo Samples

Real-world environments are often unknown, making dynamic programming impractical.

This section introduces **Monte Carlo learning**, where value functions are estimated directly from sampled episodes rather than known transition probabilities.

### Topics Explored

* Sampling complete episodes
* Estimating returns
* Monte Carlo policy evaluation
* Sample averaging

### Experiments

The notebook compares estimated value functions with the optimal values computed previously.

### Tasks

* Analyze Monte Carlo estimation errors.
* Investigate convergence of learned value functions.
* Study episode length during learning.

### Conclusion

Monte Carlo methods eliminate the need for an environment model by learning directly from experience, although they often require many episodes to converge.

---

## 6. Q-Learning

The notebook concludes with **Q-Learning**, one of the most widely used reinforcement learning algorithms.

Unlike Monte Carlo methods, Q-Learning updates value estimates after every interaction with the environment, allowing learning to occur continuously.

### Topics Explored

* Temporal Difference (TD) learning
* Q-Learning update rule
* Learning rate
* Discount factor
* Off-policy learning

### Learning Process

For each interaction:

1. Observe the current state.
2. Select an action.
3. Receive a reward.
4. Observe the next state.
5. Update the Q-value using the Bellman target.

### Tasks

* Implement the Q-Learning update equation.
* Compare learned Q-values with the optimal solution.
* Analyze convergence and policy performance.

### Conclusion

Q-Learning combines dynamic programming ideas with sampled experience, enabling agents to learn near-optimal behavior without knowing the environment dynamics.

---

# Final Conclusion

This notebook introduces the core progression of reinforcement learning algorithms, beginning with **Markov Decision Processes** and advancing toward practical learning algorithms.

Starting from exact planning methods based on complete knowledge of the environment, it demonstrates how **Dynamic Programming** computes optimal value functions and policies. It then transitions to **Monte Carlo methods**, which learn from sampled experience, before introducing **Q-Learning**, an efficient temporal-difference algorithm capable of learning directly through interaction.

Together, these methods illustrate the evolution from **model-based planning** to **model-free reinforcement learning**, highlighting how intelligent agents can learn to make optimal decisions under uncertainty.

Compared to the previous notebook on **SLAM** and **Generative Models**, this notebook shifts the focus from perception and representation learning to **sequential decision making**, showing how agents learn optimal behavior through interaction with their environment.
