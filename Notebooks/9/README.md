# Policy Gradient Methods: REINFORCE, PPO, and SAC

## Overview

This notebook explores **policy-based reinforcement learning**, focusing on methods that directly learn and optimize a policy instead of first learning a value function and deriving a policy from it.

The notebook begins with a from-scratch implementation of the **REINFORCE algorithm** using PyTorch and applies it to the continuous-control **Hopper** environment. It then discusses Actor-Critic methods and introduces more advanced policy-gradient algorithms, particularly **Proximal Policy Optimization (PPO)** and **Soft Actor-Critic (SAC)**.

The experiments demonstrate how policy-gradient methods handle continuous action spaces and how more advanced algorithms improve the stability and efficiency limitations of basic REINFORCE.

---

## 1. Imports and Utility Functions

The notebook begins by installing and importing the required reinforcement-learning and deep-learning libraries, including:

- Gymnasium
- MuJoCo
- PyTorch
- NumPy
- Matplotlib
- Ray RLlib
- Ray Tune

A utility function is also implemented for rendering complete episodes and visualizing the behavior of trained agents.

---

## 2. Policy Gradients and REINFORCE

The first major section introduces **Policy Gradient methods**.

Unlike value-based approaches such as Q-Learning, which learn a value function and use it to select actions, Policy Gradient methods directly parameterize the policy:

`πθ(a|s)`

and optimize its parameters to maximize expected cumulative reward.

The REINFORCE algorithm estimates the policy gradient using sampled trajectories:

`∇θ J(θ) = Eπθ[Σt ∇θ log πθ(at|st) Gt]`

where `Gt` represents the return obtained after taking an action.

### Conclusion

REINFORCE provides a straightforward way to directly optimize a policy using complete sampled trajectories. Actions associated with larger returns are made more probable, allowing the agent to gradually learn better behavior.

Unlike Q-Learning, this approach naturally supports continuous action spaces by representing the policy as a probability distribution.

---

## 3. Continuous Policy Network

A neural network is implemented to represent the policy for continuous actions.

The network first extracts shared features from the observation and then produces two outputs:

- **Action mean**
- **Action standard deviation**

These parameters define a Normal distribution:

`a ~ N(μθ(s), σθ(s))`

The agent samples actions from this distribution rather than always selecting a single deterministic action.

### Conclusion

Representing the policy as a probability distribution provides a natural exploration mechanism. Instead of using an explicit epsilon-greedy strategy, the agent explores by sampling different actions from its learned action distribution.

---

## 4. Implementing the REINFORCE Agent

A custom `ReinforceAgent` is implemented using PyTorch.

During each episode, the agent stores:

- Log probabilities of selected actions
- Rewards received from the environment

After the episode finishes, discounted returns are calculated backward through the trajectory:

`Gt = rt + γGt+1`

The policy is then updated using a loss based on the action log probabilities and their corresponding returns.

Topics explored include:

- Monte Carlo policy-gradient estimation
- Discounted returns
- Log probabilities
- Stochastic action sampling
- Gradient-based policy optimization
- Adam optimization

### Conclusion

REINFORCE learns from complete episodes rather than performing a Q-value update after every individual transition.

Actions that contribute to high future returns receive stronger positive updates, while actions associated with poor returns are discouraged.

---

## 5. Training REINFORCE on Hopper

The REINFORCE implementation is applied to the **Hopper-v4** MuJoCo environment.

Hopper is a continuous-control task where the agent must learn motor actions that allow a simulated robot to move while maintaining balance.

The observation and action dimensions are obtained directly from the environment and used to construct the policy network.

Training performance is monitored using cumulative episode return and a moving window of recent scores.

Topics explored include:

- Continuous-control reinforcement learning
- MuJoCo environments
- Episode-based policy updates
- Cumulative return
- Training termination based on performance

### Conclusion

The Hopper experiment demonstrates how policy-gradient methods can directly learn continuous control policies.

However, basic REINFORCE can require many trajectories and its training can be unstable because its gradient estimates depend directly on sampled episode returns.

---

## 6. Evaluating Training Performance

Episode returns are stored throughout training and plotted to analyze learning progress.

A Gaussian smoothing filter is applied to the reward curve to make the overall learning trend easier to observe.

After training, the learned policy can also be rendered in the environment.

### Conclusion

Cumulative return provides a quantitative measure of policy improvement, while rendering an episode gives a qualitative view of the behavior learned by the agent.

---

## 7. REINFORCE vs. Q-Learning and DQN

The notebook proposes comparisons between REINFORCE and previously studied value-based methods.

Important comparisons include:

- REINFORCE exploration vs. epsilon-greedy exploration
- Policy-based vs. value-based learning
- Continuous vs. discrete action handling
- Training stability
- Sample efficiency
- REINFORCE vs. DQN convergence behavior

### Conclusion

REINFORCE and Q-Learning approach reinforcement learning differently. Q-Learning estimates action values and derives a policy from them, whereas REINFORCE directly optimizes the policy.

REINFORCE naturally supports stochastic continuous policies, but its Monte Carlo gradient estimates can have high variance and require substantial interaction with the environment.

---

## 8. Actor-Critic Methods

The notebook introduces **Actor-Critic (AC)** as an extension of basic policy-gradient learning.

Actor-Critic separates learning into two components:

- **Actor:** learns the policy and selects actions.
- **Critic:** estimates how good states or actions are.

Instead of relying only on the complete episode return, the critic can provide an advantage estimate:

`A(st,at) = rt+1 + γV(st+1) - V(st)`

This tells the actor whether an action performed better or worse than expected.

### Conclusion

Actor-Critic combines policy-based and value-based learning.

Using a critic provides more informative feedback to the policy than relying only on complete episode returns, which can reduce variance and improve learning efficiency compared with basic REINFORCE.

---

## 9. Advanced Policy Gradient Methods

The notebook then introduces more advanced reinforcement-learning algorithms designed to improve upon basic policy-gradient approaches.

Two important algorithms are discussed:

- **Proximal Policy Optimization (PPO)**
- **Soft Actor-Critic (SAC)**

Both methods are widely used for continuous-control reinforcement-learning problems.

---

## 10. Proximal Policy Optimization (PPO)

PPO improves policy-gradient training by restricting how much the policy can change during a single update.

Its clipped objective prevents excessively large policy updates that could destroy previously learned behavior.

The notebook uses **Ray RLlib** to configure and train PPO on the Hopper environment.

Topics explored include:

- PPO training
- Clipped policy updates
- Stable policy optimization
- RLlib configuration
- Hyperparameter tuning
- Learning-rate search
- Training checkpoints

### Conclusion

PPO addresses an important weakness of basic policy-gradient methods by preventing excessively large updates.

This generally produces more controlled and stable policy improvement than unconstrained REINFORCE updates.

---

## 11. Hyperparameter Tuning with Ray Tune

The PPO experiment uses **Ray Tune** to search for suitable training configurations.

The learning rate is sampled from a logarithmic range, and multiple PPO training runs are performed.

Training automatically stops when the mean episode return reaches the specified performance threshold.

The best-performing checkpoint is then selected for evaluation.

### Conclusion

Hyperparameter tuning makes it possible to systematically compare different training configurations rather than relying on a single manually selected learning rate.

Checkpointing also allows the best trained policy to be recovered and evaluated afterward.

---

## 12. Evaluating the PPO Agent

After training, the best PPO checkpoint is loaded using RLlib.

The trained policy is used in inference mode to generate deterministic actions for the Hopper environment.

Finally, a complete episode is rendered to visualize the resulting behavior.

### Conclusion

The evaluation demonstrates the complete reinforcement-learning workflow:

**configure algorithm → train policies → compare results → select best checkpoint → run inference → visualize behavior**

---

## 13. Soft Actor-Critic (SAC)

The notebook also introduces **Soft Actor-Critic** as an advanced Actor-Critic algorithm for continuous control.

SAC encourages exploration by maximizing not only expected reward but also the **entropy of the policy**.

Higher policy entropy encourages the agent to maintain more diverse behaviors during learning.

The notebook also highlights SAC's use of two critics to help reduce Q-value overestimation.

### Conclusion

SAC combines Actor-Critic learning with entropy-based exploration, making it particularly suitable for continuous and high-dimensional control problems.

Its exploration mechanism and critic-based architecture are designed to improve sample efficiency and training robustness.

---

## Learning Outcomes

By completing this notebook, the following skills were developed:

- Understanding the difference between value-based and policy-based reinforcement learning
- Understanding the Policy Gradient objective
- Implementing REINFORCE from scratch using PyTorch
- Designing stochastic policies for continuous action spaces
- Sampling actions from learned probability distributions
- Computing discounted episode returns
- Training reinforcement-learning agents in MuJoCo environments
- Comparing REINFORCE with Q-Learning and DQN
- Understanding the motivation behind Actor-Critic methods
- Understanding advantage estimation
- Understanding the main ideas behind PPO and SAC
- Training PPO agents using Ray RLlib
- Performing hyperparameter search using Ray Tune
- Saving and evaluating reinforcement-learning checkpoints
- Visualizing the behavior of trained continuous-control agents

This notebook provides a practical progression from **basic Policy Gradient methods to modern Actor-Critic algorithms**, showing how REINFORCE establishes the foundations of direct policy optimization and how methods such as PPO and SAC address its limitations for more complex continuous-control problems.
