# Imitation Learning and Offline Reinforcement Learning

## Overview

This notebook explores **Imitation Learning** and **Offline Reinforcement Learning**, focusing on how agents can learn from previously collected expert or mixed-quality datasets without requiring continuous interaction with the environment.

The notebook begins with **Behavior Cloning (BC)** using demonstrations from the D4RL Pen manipulation task. It then investigates the limitations of supervised imitation when demonstrations contain actions from different skill levels.

The second part introduces the central challenge of offline reinforcement learning: standard off-policy RL algorithms can overestimate actions that are outside the dataset distribution. More specialized offline RL approaches, including **Batch-Constrained Q-Learning (BCQ)** and **Conservative Q-Learning (CQL)**, are then implemented to address this problem.

---

## 1. Imports and Dataset Utilities

The notebook begins by installing and importing the required libraries, including:

- PyTorch
- Gymnasium
- MuJoCo
- Minari
- TorchRL
- Matplotlib
- MediaPy

A rendering function is provided for evaluating trained policies, and a custom `MinariReplayBuffer` converts offline Minari datasets into batches suitable for PyTorch training.

The replay buffer contains:

- Observations
- Actions
- Rewards
- Next observations
- Episode termination indicators

Reward normalization can also optionally be applied.

---

## 2. Imitation Learning

Imitation Learning trains an agent using demonstrations produced by another policy or an expert.

Instead of discovering behavior entirely through trial and error, the agent learns from recorded state-action pairs.

The notebook discusses several forms of imitation learning, including:

- Behavior Cloning
- Inverse Reinforcement Learning
- Generative Adversarial Imitation Learning

The main distinction from standard reinforcement learning is the source of supervision: imitation learning relies on demonstrated behavior, while reinforcement learning learns from interaction and reward feedback.

### Conclusion

Imitation learning can provide useful behavior much faster than learning from scratch when high-quality demonstrations are available.

Its effectiveness, however, depends strongly on the quality and coverage of the demonstration dataset.

---

## 3. Robot Learning Datasets

The notebook uses offline robot-learning datasets through **Minari**.

The initial experiment loads:

`D4RL/pen/expert-v2`

This dataset contains demonstrations for a high-dimensional robotic pen manipulation problem.

The notebook inspects:

- Action space
- Observation space
- Number of episodes
- Distribution of episode returns

### Conclusion

Offline datasets allow robot-learning algorithms to train without repeatedly interacting with a physical or simulated environment.

The return distribution also provides useful information about the quality and diversity of demonstrations contained in the dataset.

---

## 4. Behavior Cloning

The first implemented learning algorithm is **Behavior Cloning (BC)**.

Behavior cloning treats imitation learning as a supervised-learning problem:

**observation → neural network → predicted expert action**

A multilayer neural network maps observations directly to continuous actions.

Training minimizes the Mean Squared Error between predicted actions and actions recorded in the dataset.

### Conclusion

Behavior cloning provides a simple and effective way to imitate expert demonstrations.

When demonstrations are consistent and high-quality, the policy can learn good behavior quickly because it does not need to discover successful actions through exploration.

---

## 5. Behavior Cloning with Mixed-Quality Data

The notebook then proposes replacing the expert dataset with:

`D4RL/pen/cloned-v2`

This dataset contains behavior with different levels of quality.

Because behavior cloning treats every demonstrated action as a supervised target, it does not naturally distinguish between good and poor decisions.

### Conclusion

Behavior cloning can degrade significantly when demonstrations contain inconsistent behavior.

The policy attempts to imitate the entire action distribution rather than explicitly preferring actions that produce higher rewards.

This illustrates an important limitation of pure supervised imitation learning.

---

## 6. Limitations of MSE for Behavior Cloning

The notebook considers why minimizing MSE can be particularly problematic when demonstrations contain actions from different skill levels.

If different actions are observed for similar states, MSE encourages the model toward an average of those actions.

For multimodal behavior, this average may not correspond to any meaningful or successful expert behavior.

### Conclusion

A simple deterministic MSE objective assumes that there is effectively one correct action for each state.

More expressive probabilistic or multimodal policy models may better represent datasets containing several valid behaviors or demonstrations from different policies.

---

## 7. From Imitation Learning to Offline Reinforcement Learning

A natural idea is to reuse previously learned off-policy algorithms and simply replace their online replay buffer with an offline dataset.

However, offline reinforcement learning introduces a major difficulty: the agent cannot interact with the environment to verify actions that are not represented well in the dataset.

The notebook highlights **distributional shift** between:

- Actions represented in the offline dataset
- Actions proposed by the newly learned policy

### Conclusion

Standard off-policy reinforcement-learning algorithms are not automatically suitable for offline learning.

When the policy selects actions outside the dataset distribution, the critic may assign unreliable or excessively high Q-values to those actions.

---

## 8. Q-Value Overestimation in Offline RL

Offline RL must estimate the value of actions using only a fixed dataset.

If an action has little or no support in that dataset, its estimated Q-value may be inaccurate.

A learned policy that maximizes the critic can then deliberately select these incorrectly overestimated actions.

Because no new environment interaction is allowed, the agent cannot collect additional evidence to correct these errors.

### Conclusion

The combination of function approximation, policy optimization, and out-of-distribution actions can cause severe Q-value overestimation in offline reinforcement learning.

Specialized offline RL methods therefore attempt to keep the learned policy close to actions supported by the dataset or explicitly penalize uncertain Q-values.

---

## 9. Batch-Constrained Q-Learning (BCQ)

The notebook implements **Batch-Constrained Q-Learning (BCQ)**.

BCQ attempts to prevent the policy from selecting arbitrary out-of-distribution actions.

Instead, it learns the distribution of actions contained in the dataset and restricts policy improvement to actions that remain close to this distribution.

BCQ combines three main components:

- Variational Autoencoder
- Critic
- Perturbation Actor

### Conclusion

BCQ addresses offline RL distribution shift by constraining the learned policy to remain near actions represented in the dataset.

Rather than freely maximizing Q-values over the entire action space, it searches primarily among plausible dataset-supported actions.

---

## 10. Variational Autoencoder in BCQ

A **Variational Autoencoder (VAE)** is trained using observation-action pairs from the offline dataset.

Given an observation, the VAE learns to generate actions similar to those that occur in the dataset.

The VAE is trained using:

- Action reconstruction loss
- KL-divergence regularization

During action selection, multiple candidate actions can be sampled from the learned action distribution.

### Conclusion

The VAE acts as a learned model of the dataset's behavioral distribution.

By generating candidate actions that resemble dataset actions, it reduces the likelihood that the critic will be queried on completely unfamiliar actions.

---

## 11. BCQ Critic and Double Q-Learning

BCQ uses two Q-value estimates.

The target combines the minimum and maximum critic estimates using a weighting parameter before selecting the best candidate action sampled from the VAE.

The critic is trained using a Bellman target:

**reward + discounted estimated future value**

### Conclusion

Using two critics helps control Q-value overestimation.

Combined with dataset-constrained action generation, this makes the value-learning process more conservative than directly maximizing a single critic over arbitrary actions.

---

## 12. Perturbation Actor in BCQ

BCQ also contains an Actor that does not generate actions completely from scratch.

Instead, the Actor receives an action sampled from the VAE and learns a small perturbation to improve it.

Conceptually:

**dataset-like action → small learned modification → improved action**

The Actor is optimized using the critic's Q-value estimate.

### Conclusion

The perturbation model allows BCQ to improve beyond exact behavior cloning while still remaining close to the offline dataset.

This provides a compromise between simply copying demonstrated actions and unconstrained policy optimization.

---

## 13. BCQ Action Selection

During evaluation, multiple actions are sampled from the VAE for the current state.

The Actor perturbs these candidate actions, and the critic evaluates them.

The action with the highest estimated Q-value is selected.

The process can be summarized as:

**state → generate dataset-like actions → perturb actions → evaluate with critic → choose best action**

### Conclusion

BCQ performs policy improvement within a constrained region of the action space.

This directly targets one of the central problems of offline RL: unreliable value estimates for actions far outside the training distribution.

---

## 14. Conservative Q-Learning (CQL)

The final section implements **Conservative Q-Learning (CQL)**.

CQL takes a different approach to offline RL.

Instead of explicitly restricting candidate actions using a generative model, it modifies critic training so that Q-values for unsupported actions are pushed downward relative to Q-values for actions observed in the dataset.

The implemented agent contains:

- Continuous Actor
- Critic
- Target Critic
- Standard Bellman loss
- Conservative Q-value penalty

### Conclusion

CQL addresses offline distribution shift by making the critic deliberately conservative.

The goal is to prevent the learned policy from exploiting unrealistically high Q-values assigned to actions that are poorly represented in the offline dataset.

---

## 15. Conservative Q-Value Penalty

During critic training, the notebook evaluates Q-values for:

- Randomly sampled actions
- Actions generated by the current policy
- Actions actually contained in the dataset

A log-sum-exp term penalizes high Q-values for random and policy-generated actions relative to the Q-values of dataset actions.

The total critic objective combines:

**Bellman error + conservative regularization**

### Conclusion

The conservative penalty discourages the critic from assigning excessively optimistic values to unfamiliar actions.

This reduces the incentive for the Actor to exploit errors in the learned Q-function.

---

## 16. Comparing Behavior Cloning, BCQ, and CQL

The notebook presents three different approaches to learning from static datasets:

**Behavior Cloning**

Learns directly from demonstrated state-action pairs but does not explicitly use reward information to distinguish better actions.

**BCQ**

Uses reward-based value learning while constraining candidate actions to remain close to the dataset distribution.

**CQL**

Uses reward-based learning while explicitly penalizing overly optimistic Q-values for actions outside the dataset.

### Conclusion

The progression from BC to BCQ and CQL illustrates the central challenge of offline learning.

Behavior cloning avoids out-of-distribution value estimation but may imitate poor demonstrations. Standard reinforcement learning can use reward information but may exploit unreliable Q-values. Offline RL algorithms attempt to use reward information while controlling distribution shift.

---

## Learning Outcomes

By completing this notebook, the following skills were developed:

- Understanding the principles of imitation learning
- Working with offline robot-learning datasets using Minari
- Building replay buffers from static datasets
- Implementing Behavior Cloning with PyTorch
- Understanding the limitations of deterministic MSE-based imitation
- Analyzing the effect of mixed-quality demonstrations
- Understanding the difference between imitation learning and offline reinforcement learning
- Understanding distributional shift in offline RL
- Understanding Q-value overestimation for out-of-distribution actions
- Implementing Batch-Constrained Q-Learning
- Using a VAE to model dataset-supported actions
- Understanding the role of the BCQ perturbation Actor
- Using double critics for more robust value estimation
- Understanding Conservative Q-Learning
- Implementing conservative Q-value regularization
- Comparing Behavior Cloning, BCQ, and CQL

This notebook provides a practical progression from **supervised imitation learning to specialized offline reinforcement learning**, demonstrating why learning from static datasets requires more than simply applying standard off-policy RL. It highlights two major strategies for handling distribution shift: **constraining policies toward dataset-supported actions with BCQ** and **learning conservative value estimates with CQL**.
