# Reinforcement Learning with Q-Learning and Deep Q-Learning

## Overview
This notebook explores reinforcement learning using **Q-Learning** and **Deep Q-Learning (DQN)** on control problems from Gymnasium. It begins with tabular Q-Learning on environments with continuous state spaces by discretizing observations, and then moves to neural-network-based value approximation for more scalable reinforcement learning.

Throughout the notebook, experiments are performed to understand how exploration, state representation, and Deep Q-Learning techniques affect training stability and performance.

---

## 1. Imports and Utility Functions
The notebook begins by installing and importing the required libraries, including Gymnasium, PyTorch, NumPy, Matplotlib, Ray/RLlib, and utilities for rendering trained agents.

A helper function is defined to render complete episodes and visualize the behavior of learned policies.

---

## 2. Q-Learning on CartPole
This section applies Q-Learning to the **CartPole-v1** environment.

Unlike a simple discrete GridWorld, CartPole has a continuous state consisting of variables such as cart position, velocity, pole angle, and angular velocity. Since a traditional Q-table requires discrete states, the continuous observations are converted into discrete bins.

Topics explored include:
- Tabular Q-Learning
- Continuous-state discretization
- Q-table construction
- Epsilon-greedy exploration
- Discounted future rewards
- Learning-rate-based Q-value updates
- Epsilon decay
- Monitoring cumulative episode rewards

### Conclusion
We observed that Q-Learning can still be applied to continuous-state problems when the state space is discretized. However, the quality of the learned policy depends strongly on the discretization resolution and exploration strategy.

Using too few bins loses important state information, while too many bins greatly increase the size of the Q-table and require substantially more experience.

---

## 3. Exploration and Epsilon Decay
An epsilon-greedy policy is used to balance exploration and exploitation.

The agent initially explores heavily with a high epsilon value. During training, epsilon gradually decreases until it reaches a small minimum value, causing the agent to rely increasingly on its learned Q-values.

Topics explored include:
- Exploration vs. exploitation
- Initial and final epsilon
- Epsilon decay schedules
- Random action selection
- Greedy action selection

### Conclusion
Exploration is especially important during early training because the agent has not yet learned reliable Q-values. Gradually reducing epsilon allows the agent to transition from discovering useful behaviors to exploiting the knowledge it has accumulated.

---

## 4. Q-Learning on LunarLander
The tabular Q-Learning approach is also tested on the **LunarLander-v3** environment.

This environment has a larger and more complex state space than CartPole, making discretization significantly more challenging.

Topics explored include:
- Applying the same Q-Learning framework to a different environment
- Comparing state and action spaces
- Increasing Q-table dimensionality
- Limitations of discretization in complex environments

### Conclusion
The LunarLander experiment highlights an important limitation of tabular Q-Learning: as the number of state dimensions increases, discretization causes the Q-table to grow extremely quickly.

This motivates replacing explicit Q-tables with function approximators such as neural networks.

---

## 5. Deep Q-Learning
This section introduces **Deep Q-Learning (DQL/DQN)** as an extension of traditional Q-Learning.

Instead of storing a separate Q-value for every discrete state-action pair, a neural network learns a function that maps a state to estimated Q-values for all possible actions.

Topics explored include:
- Neural-network approximation of Q-values
- Deep Q-Networks
- Experience replay
- Replay buffers
- Mini-batch learning
- Target networks
- Soft target-network updates
- Epsilon-greedy action selection
- Temporal-difference targets

### Conclusion
Deep Q-Learning removes the need to explicitly discretize large continuous state spaces. Neural networks can generalize between similar states and provide Q-value estimates even for observations that were not encountered exactly during training.

However, directly combining Q-Learning with a neural network can be unstable. Experience replay and a separate target network are therefore important components for improving training stability.

---

## 6. Experience Replay
Past transitions are stored in a replay buffer and randomly sampled during training.

A stored experience contains information such as:

`(state, action, reward, next_state, done)`

Instead of training only on the most recent transition, the network learns from random mini-batches of previously collected experiences.

### Conclusion
Experience replay improves data efficiency because experiences can be reused multiple times. Random sampling also reduces the strong correlation between consecutive transitions, which helps stabilize neural-network training.

---

## 7. Target Network
Deep Q-Learning uses a second neural network to compute more stable learning targets.

The main Q-network is optimized frequently, while the target network changes more slowly through target-network updates.

### Conclusion
Using the same rapidly changing network both to predict Q-values and construct their targets creates a moving-target problem. A separate target network reduces this instability and makes DQN training more reliable.

---

## 8. Training and Policy Evaluation
The learned policies are evaluated using cumulative episode reward. Training statistics are recorded and smoothed to visualize how agent performance changes over time.

After training, episodes can be rendered to visually inspect the behavior learned by the agent.

Topics explored include:
- Episode returns
- Smoothed learning curves
- Environment solution thresholds
- Policy evaluation
- Rendering trained agents

### Conclusion
Reward curves provide a quantitative view of learning progress, while rendered episodes provide a qualitative way to verify whether the learned behavior is sensible.

---

## Learning Outcomes
By completing this notebook, the following skills were developed:

- Implementing tabular Q-Learning
- Applying Q-Learning to continuous-state environments through discretization
- Designing epsilon-greedy exploration strategies
- Understanding the tradeoff between discretization accuracy and Q-table size
- Applying reinforcement learning to CartPole and LunarLander
- Understanding why tabular methods struggle with high-dimensional state spaces
- Using neural networks to approximate Q-values
- Understanding experience replay and target networks
- Training and evaluating Deep Q-Learning agents
- Visualizing reinforcement-learning performance and learned policies

This notebook provides a practical progression from classical tabular Q-Learning to Deep Q-Learning while demonstrating why neural function approximation becomes necessary as reinforcement-learning problems grow in complexity.
