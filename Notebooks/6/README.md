# SLAM and Generative Models for Noise Reduction (Autoencoder & VAE)

## Overview
This notebook explores two important topics in robotics and machine learning:

- **Simultaneous Localization and Mapping (SLAM)** for robot perception and mapping in noisy environments
- **Deep learning-based denoising** using **Autoencoders** and **Variational Autoencoders (VAEs)**

The first part focuses on how a robot can estimate its position while building a map from noisy sensor observations. The second part explores how neural networks can learn compact latent representations and use them to remove noise from images or generate new samples.

## 1. Install Packages
This section installs all required libraries for simulation, visualization, and deep learning.

## 2. Imports and Utility Functions
Imports required libraries and helper functions for simulation and visualization.

## 3. SLAM (Simultaneous Localization and Mapping)
Introduces localization and mapping under noisy sensor observations.

### Key Concepts
- Robot pose estimation
- Landmark detection
- Noisy perception and motion updates
- Mapping observed features over time

## 4. SLAM Implementation
Custom SLAM class implementation.

### Core Components
- Map storage
- Nearest neighbour search
- Data association
- Map update

## 5. Learning to Remove Noise
Introduces denoising with neural networks using MNIST.

## 6. Denoising Autoencoder
Encoder-decoder architecture for noise removal.

### Key Concepts
- Latent bottleneck
- Reconstruction loss
- Learned compression

## 7. Denoising Results
Visualization of original, noisy, and reconstructed images.

## 8. Latent Space Analysis
Visualizes 2D latent embeddings and clustering behavior.

## 9. Generating Images from Latent Space
Uses decoder to generate images from latent vectors.

## 10. Variational Autoencoders (VAE)
Introduces probabilistic latent spaces.

### Key Concepts
- Mean and variance vectors
- Reparameterization trick
- KL divergence regularization

## 11. Training the VAE
Uses reconstruction loss + KL loss.

## 12. VAE Latent Space
Shows structured Gaussian-like latent distribution.

## 13. VAE Reconstruction
Compares reconstructions with standard autoencoders.

## 14. Image Generation with VAE
Samples from latent Gaussian to generate digits.

# Final Conclusion
This notebook combines classical probabilistic robotics (SLAM) with modern deep learning (Autoencoders and VAEs) to handle uncertainty and noise in real-world data.
