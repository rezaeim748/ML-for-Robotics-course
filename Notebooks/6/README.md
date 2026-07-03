# SLAM and Generative Models for Noise Reduction (Autoencoder & VAE)

## Overview
This notebook explores two important topics in robotics and machine learning:

- **Simultaneous Localization and Mapping (SLAM)** for robot perception and mapping in noisy environments
- **Deep learning-based denoising** using **Autoencoders** and **Variational Autoencoders (VAEs)**

The first part focuses on how a robot can estimate its position while building a map from noisy sensor observations. The second part explores how neural networks can learn compact latent representations and use them to remove noise from images or generate new samples.

---

## 1. Install Packages
This section installs all required libraries for simulation, visualization, and deep learning.

### Packages Used
- **NumPy** for numerical operations
- **Matplotlib** for plotting and animation
- **MuJoCo** for physics simulation
- **PyTorch / TorchRL** for neural networks
- **Gymnasium** for reinforcement learning environments

### Conclusion
This section prepares the environment for robotics simulations and deep learning experiments.

---

## 2. Imports and Utility Functions
This section imports the required libraries and defines helper functions used throughout the notebook.

### Topics Explored
- Scientific computing with NumPy
- Visualization with Matplotlib
- Animation using `FuncAnimation`
- Helper functions for adding Gaussian noise

### Conclusion
These utilities provide the foundation for both the SLAM simulation and neural network experiments.

---

## 3. SLAM (Simultaneous Localization and Mapping)
This section introduces the SLAM problem in robotics.

A robot moving in an unknown environment must:
1. Estimate its own position (**localization**)
2. Build a map of landmarks around it (**mapping**)

This is difficult because both movement and sensor measurements contain noise.

### Topics Explored
- Robot pose estimation
- Landmark detection
- Noisy perception and motion updates
- Mapping observed features over time

### Environment Setup
The notebook creates:
- A circular environment with landmarks
- A moving robot with a field of view
- Noisy perception measurements
- Noisy pose updates

### Key Challenges
- Sensor noise causes inaccurate landmark detection
- Motion noise causes drift in robot position
- Multiple observations of the same landmark must be associated correctly

### Conclusion
SLAM allows a robot to continuously refine both its map and position despite uncertainty.

---

## 4. SLAM Implementation
A custom `SLAM` class is implemented to manage localization and map creation.

### Core Components
- **Map storage** for detected landmarks
- **Nearest neighbour search** for matching observed landmarks to existing map points
- **Data association** to determine whether a landmark is new or previously seen
- **Map update** to improve landmark estimates

### Topics Explored
- Euclidean distance computation
- Nearest neighbour search
- Landmark fusion
- Error accumulation in localization

### Tasks
1. Implement nearest neighbour search.
2. Define a threshold to decide whether a perception belongs to an existing landmark.
3. Improve data association to reduce duplicate landmarks.

### Conclusion
Good data association is critical in SLAM; incorrect associations quickly degrade map quality.

---

## 5. Learning to Remove Noise
This section transitions from classical robotics to machine learning.

Instead of manually modeling noise, we train neural networks to learn how to remove noise from corrupted inputs.

The notebook uses the **MNIST handwritten digit dataset**.

### Goal
Train a model that receives:
- A noisy image of a digit

and outputs:
- A clean reconstruction of the digit

### Topics Explored
- Supervised denoising
- Neural network compression
- Latent representation learning

### Conclusion
Deep learning can learn noise removal directly from data without manually designing filters.

---

## 6. Denoising Autoencoder
This section implements a **Denoising Autoencoder (DAE)**.

An autoencoder consists of two parts:

### Encoder
Compresses input image into a low-dimensional latent vector.

### Decoder
Reconstructs the image from the latent vector.

The bottleneck forces the model to keep only important information.

### Topics Explored
- Encoder-decoder architecture
- Latent bottleneck
- Reconstruction loss
- Noise suppression through learned compression

### Training
The model is trained on:
- Noisy MNIST images as input
- Clean MNIST images as target

### Conclusion
The denoising autoencoder learns to ignore random noise and preserve digit structure.

---

## 7. Denoising Results
After training, the notebook visualizes:

- Original image
- Noisy image
- Reconstructed image

### Observations
- Major digit structure is preserved
- Small noise patterns are removed
- Reconstruction improves as training progresses

### Conclusion
The model successfully learns a robust compressed representation of digits.

---

## 8. Latent Space Analysis
This section visualizes the latent space learned by the autoencoder.

Since the latent dimension is set to **2**, each image becomes a point in 2D space.

### Topics Explored
- Latent embeddings
- Cluster formation by digit class
- Similarity between digit shapes

### Observations
Digits with similar shapes tend to cluster together.

Examples:
- Some digits are clearly separated
- Similar digits overlap in latent space (e.g. 3, 5, 8)

### Conclusion
The latent space captures semantic similarity between handwritten digits.

---

## 9. Generating Images from Latent Space
The decoder is used independently to generate images from sampled latent vectors.

### Topics Explored
- Random latent sampling
- Decoding latent vectors into images
- Interpolation between digits

### Conclusion
The decoder can generate plausible digit images from latent vectors, but generation quality depends heavily on latent structure.

---

## 10. Variational Autoencoders (VAE)
This section introduces **Variational Autoencoders (VAEs)**.

Unlike standard autoencoders, VAEs do not map each input to a single point.

Instead, each input maps to:
- A mean vector (**μ**)
- A variance vector (**σ²**)

Together they define a probability distribution in latent space.

### Key Idea
Latent vectors are encouraged to follow a standard Gaussian:

z ~ N(0, I)

This makes sampling smooth and structured.

### Topics Explored
- Probabilistic latent spaces
- Reparameterization trick
- KL-divergence regularization
- Generative modeling

### Conclusion
VAEs create a structured latent space suitable for generation.

---

## 11. Training the VAE
The VAE is trained using two losses:

### Reconstruction Loss
Measures how well reconstructed images match original images.

### KL Loss
Encourages latent distributions to remain close to a standard Gaussian.

Total loss:

Loss = Reconstruction + KL

### Conclusion
This balances reconstruction quality and latent space regularization.

---

## 12. VAE Latent Space
The notebook visualizes the VAE latent space and compares it with the standard autoencoder.

### Observations
Compared to the autoencoder:
- Latent points are more smoothly distributed
- Clusters overlap more
- Distribution resembles a Gaussian cloud

### Conclusion
The VAE latent space is more continuous and easier to sample from.

---

## 13. VAE Reconstruction
The trained VAE reconstructs images from encoded latent vectors.

### Observations
- Reconstructions are slightly blurrier than standard autoencoders
- Global digit structure is preserved
- Fine details are smoother

### Conclusion
The VAE sacrifices sharpness for better generative properties.

---

## 14. Image Generation with VAE
Random samples are drawn from the latent Gaussian distribution and decoded.

The notebook also sweeps over a 2D latent grid to observe how digits change smoothly across space.

### Topics Explored
- Random generation
- Latent interpolation
- Smooth transitions between digit classes

### Observations
Nearby latent points generate visually similar digits.

### Conclusion
This demonstrates why VAEs are powerful generative models.

---

# Final Conclusion
This notebook combines **robotics** and **deep learning** approaches for handling uncertainty and noise.

In the SLAM section, uncertainty comes from noisy movement and sensor measurements, requiring careful estimation and data association.

In the deep learning section, denoising autoencoders and VAEs learn compact latent representations that remove noise and enable image generation.

Together, these methods illustrate two complementary approaches to dealing with imperfect real-world data:
- **Classical probabilistic estimation (SLAM)**
- **Learned representation modeling (Autoencoders / VAEs)**

This notebook focuses on **uncertainty handling**, whether through geometric mapping or learned latent spaces. Also, compared to the previous notebook, this one leans more into **representation learning and generative modeling**.
