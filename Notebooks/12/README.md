# Reinforcement Learning from Images: DQN, VAE Latents, and Perception-Based State

## Overview

This notebook explores **reinforcement learning directly from visual observations** using the Gymnasium **CarRacing-v3** environment. The central challenge is converting high-dimensional image observations into representations that a reinforcement-learning agent can use effectively.

Three different approaches are investigated and compared:

1. **End-to-end Image DQN** — learning Q-values directly from raw image observations.
2. **VAE-DQN** — learning a low-dimensional latent representation with a Variational Autoencoder and training DQN on that representation.
3. **Perception-DQN** — constructing a compact, interpretable state representation from domain knowledge and training a small DQN on these features.

The notebook therefore investigates an important question in visual reinforcement learning: **Should an agent learn directly from pixels, learn its own representation, or use task-specific perceptual features?**

---

## 1. Environment and Action Space

The experiments use the **CarRacing-v3** environment with discrete actions.

An action wrapper restricts the available actions so that the reinforcement-learning agent operates on a simplified discrete action space suitable for DQN.

The environment provides image observations of size `96 × 96 × 3`, meaning that the agent initially receives thousands of pixel values instead of a compact numerical state.

### Conclusion

Visual observations contain much more information than the agent actually needs for driving. This makes state representation a central challenge: useful driving information must somehow be extracted from high-dimensional images.

---

## 2. End-to-End DQN from Images

The first approach trains a **Deep Q-Network directly on image observations**.

A convolutional neural network processes the image and learns visual features jointly with the Q-value function. The final network outputs one Q-value for each available action.

The agent uses standard DQN components including:

- Convolutional feature extraction
- Experience replay
- Target network
- Epsilon-greedy exploration
- Temporal-difference learning
- Periodic target-network updates

### Conclusion

End-to-end learning has the advantage that no manually designed state representation is required. In principle, the neural network can discover whatever visual features are useful for driving.

However, the Q-network must simultaneously learn **how to understand the image** and **how to control the vehicle**, which can make learning slow and data-intensive.

---

## 3. Experience Replay and DQN Training

Transitions are stored in a replay buffer in the form of image observations, actions, rewards, next observations, and termination indicators.

Mini-batches are sampled from this replay buffer to update the Q-network.

The temporal-difference target follows the standard DQN structure:

`target = reward + γ max_a Q_target(next_state, a)`

for non-terminal transitions.

### Conclusion

Experience replay allows visual experiences to be reused during training and reduces correlations between consecutive observations.

The target network provides a more stable learning target and helps prevent the Q-network from chasing rapidly changing predictions.

---

## 4. Representation Learning with a Variational Autoencoder

The second approach separates **visual representation learning** from **control**.

A **Variational Autoencoder (VAE)** is trained to compress each `96 × 96 × 3` image into a much smaller latent representation.

The VAE contains:

- A convolutional encoder
- Latent mean and log-variance
- Reparameterization
- A low-dimensional latent vector
- A decoder that reconstructs the original image

The VAE loss combines:

- Reconstruction loss
- KL-divergence regularization

### Conclusion

The VAE transforms a high-dimensional image into a compact latent state, reducing the dimensionality of the input that must be handled by the reinforcement-learning algorithm.

Unlike end-to-end DQN, perception and control are partially separated: the VAE learns the representation, while the Q-network learns how to act from that representation.

---

## 5. VAE-DQN Agent

A `VAEDQNAgent` extends the DQN architecture by inserting the VAE between the image observation and the Q-network.

The process becomes:

**image → VAE encoder → latent state → Q-network → action**

The Q-network is therefore a relatively small multilayer perceptron operating on the latent representation instead of directly processing images.

The VAE and DQN are updated separately from samples stored in the replay buffer.

### Conclusion

Compressing observations can make the control problem substantially smaller. The Q-network no longer needs to process thousands of raw pixel values and can instead operate on a compact latent state.

However, a VAE is trained to reconstruct images rather than specifically preserve information that is important for maximizing reward.

---

## 6. Visualizing VAE Representations

The notebook evaluates the learned VAE representation by recording:

- Environment frames
- Reconstructed images
- Latent-state values

The original observation, VAE reconstruction, and latent representation are visualized together during an episode.

### Conclusion

Visualizing reconstructions helps determine whether the VAE has learned meaningful visual structure.

Inspecting the latent representation can also reveal whether particular latent dimensions correspond to relevant aspects of driving behavior or environmental state.

---

## 7. Limitations of VAE-Based State Representations

Although the VAE reduces dimensionality, several potential problems remain.

The representation is optimized for **image reconstruction**, not directly for control. As a result, the latent space may preserve visually important information that is irrelevant to driving while discarding subtle information that is important for action selection.

The representation also changes while the VAE is being trained, meaning that the state representation seen by the DQN can evolve during reinforcement-learning training.

### Conclusion

A compact representation is not automatically a useful control representation.

For reinforcement learning, the most useful latent state should preserve information that is relevant to predicting rewards and selecting actions, not merely information needed to reconstruct the input image.

---

## 8. Perception-Based State Representation

The third approach again separates **perception from control**, but the representation is no longer learned.

Instead, a perception pipeline is designed from first principles using domain knowledge about what information matters for driving.

The system extracts a compact and interpretable state vector from each image.

The state includes:

- Forward ray distances
- Side ray distances
- Speed
- Steering
- Gyroscope information

### Conclusion

This approach dramatically reduces the dimensionality of the control problem while ensuring that the state contains features that are directly relevant to driving.

Unlike VAE latents, each state dimension also has a clear physical interpretation.

---

## 9. Ray-Based Track Perception

The perception system detects the car and casts rays toward the track boundaries.

Pixels are classified to identify features such as grass and the vehicle itself. Rays measure the normalized distance from the car to the surrounding track boundaries.

Several forward and side rays provide information about the local road geometry.

### Conclusion

Ray casting converts complex visual information about the road into a small set of meaningful geometric measurements.

Instead of asking the neural network to discover track boundaries from raw pixels, the perception system explicitly provides this information to the controller.

---

## 10. Extracting Vehicle Information from the HUD

Additional driving information is extracted directly from the visual HUD.

The perception pipeline identifies indicators corresponding to:

- Speed
- Steering
- Gyroscope values

These values are combined with the ray measurements to construct the final low-dimensional state.

### Conclusion

Combining track geometry with vehicle-state information produces a compact representation that contains both environmental and control-relevant information.

This allows the reinforcement-learning network to focus primarily on learning the relationship between state and action.

---

## 11. Perception-DQN Agent

A `PerceptionDQNAgent` uses the handcrafted state encoder before applying DQN.

The architecture becomes:

**image → perception encoder → compact state → small MLP → Q-values**

Because the state representation is already low-dimensional, the Q-network can be much smaller than the end-to-end convolutional network.

The extracted state features are stored in the replay buffer together with the original transitions.

### Conclusion

The perception-based agent reduces the learning burden on the neural network.

Instead of simultaneously learning visual perception and control, DQN only needs to learn the control policy from a compact set of driving-relevant features.

---

## 12. Visualizing the Perception State

The notebook visualizes the handcrafted representation by displaying:

- The environment observation
- The ray-casting overlay
- The numerical state vector

During evaluation, the ray measurements and vehicle-state values can be observed as the agent drives.

### Conclusion

Unlike learned latent representations, the handcrafted state is directly interpretable.

The visualization makes it possible to inspect what the agent perceives and determine whether errors originate from the perception system or from the learned control policy.

---

## 13. Comparing the Three Representations

The notebook compares learning curves for:

- **Image DQN**
- **VAE-DQN**
- **Perception-DQN**

This comparison investigates how the choice of state representation affects reinforcement-learning performance and convergence.

The three methods represent different levels of prior knowledge:

**raw pixels → learned latent representation → handcrafted task-specific representation**

### Conclusion

The comparison highlights the trade-off between generality and task-specific structure.

End-to-end learning requires the least manual feature engineering but places the largest learning burden on the neural network. VAE-based learning reduces dimensionality automatically but does not guarantee that the latent variables are control-relevant. Handcrafted perception provides compact and interpretable features but requires domain knowledge and task-specific engineering.

---

## Learning Outcomes

By completing this notebook, the following skills were developed:

- Understanding the challenges of reinforcement learning from visual observations
- Training DQN agents from image inputs
- Using convolutional neural networks for visual state processing
- Understanding the role of state representation in reinforcement learning
- Building and training a Variational Autoencoder
- Using VAE latent representations as states for DQN
- Understanding reconstruction loss and KL-divergence in VAEs
- Visualizing latent representations and reconstructed observations
- Identifying limitations of reconstruction-based representations for control
- Designing task-specific perception pipelines
- Extracting track geometry using ray casting
- Extracting driving information from visual observations
- Training DQN on compact handcrafted states
- Comparing raw-pixel, learned-latent, and perception-based state representations
- Understanding the trade-off between representation generality, interpretability, and learning efficiency

This notebook provides a practical comparison of three approaches to **reinforcement learning from images**, demonstrating how state representation can strongly influence the difficulty of the learning problem. It progresses from fully end-to-end visual reinforcement learning to learned latent states and finally to compact perception-based representations designed specifically for the control task.
