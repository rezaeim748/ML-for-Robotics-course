# Perception in Robotics: Sensor Noise, Object Detection, and Kalman Filtering

## Overview
This notebook explores fundamental perception challenges in robotics, focusing on how robots sense and interpret their environment from imperfect sensor data. It covers two main areas: state estimation under noise using the Kalman filter, and visual object detection and tracking in a simulated MuJoCo scene.

The notebook begins with a theoretical introduction to perception in robotics, then builds up from a 1D Kalman filter implementation to a full 2D object tracker that fuses visual detections with a motion model.

---

## 1. Install Packages
The notebook installs the required packages for physics simulation and image processing.

### Conclusion
This section prepares the environment for running MuJoCo simulations and computer vision experiments using OpenCV and mediapy.

---

## 2. Imports and Utility Functions
This section imports the required libraries and defines helper functions used throughout the notebook.

### Topics Explored
- MuJoCo simulation setup and rendering
- OpenCV for image processing
- Episode rendering helper (`render_episode`)

### Conclusion
The imports and utility functions provide the foundation for running both physics-based simulations and visual perception experiments.

---

## 3. Perception in Robotics
This section introduces the concept of perception in robotics and explains why it is a critical component of learning-based control systems.

Two paradigms are contrasted: learning from raw high-dimensional sensor inputs such as images, versus learning from compact, pre-processed state representations.

### Topics Explored
- Sensors in robotics (cameras, LiDAR, radar, touch)
- Noisy sensor data and its causes
- Partial observation and its challenges
- Sensor fusion and filtering as mitigation strategies

### Conclusion
Perception provides the raw sensory data that enables a robot to navigate and make decisions. Real-world sensors are always imperfect, making noise handling and partial observation key challenges in any robotic system.

---

## 4. Kalman Filter
This section introduces the Kalman filter as a principled algorithm for estimating the state of a system from incomplete and noisy measurements. A full Python implementation is provided and applied to two scenarios.

### Topics Explored
- Kalman filter parameters: initial state, initial covariance, measurement matrix, measurement noise covariance, transition matrix, and process noise covariance
- Predict step: propagating the state forward using the motion model
- Update step: fusing the predicted state with a new measurement using the Kalman gain
- 1D uncertainty propagation: estimating position and velocity from noisy scalar measurements
- 2D trajectory tracking: filtering a noisy figure-eight path and visualizing estimated vs. ground-truth positions

### Tasks
1. Experiment with filter parameters to build intuition for their effect on the estimate.
2. Analyze what the transition matrix assumes about the motion model (constant velocity, no acceleration).
3. Reason about what happens when measurements stop entirely — the filter dead-reckons using the predict step alone, but uncertainty grows over time.

### Conclusion
The Kalman filter provides an optimal state estimate by combining a motion model with noisy measurements. It handles missing observations gracefully in the short term but degrades as prediction uncertainty accumulates without updates.

---

## 5. Object Detection and Tracking
This section builds a visual perception pipeline for detecting and tracking a moving red cylinder in a MuJoCo scene, even when it is partially occluded by static obstacles.

Two classical detection methods are compared under two lighting conditions, then the better-performing detector is combined with the Kalman filter for tracking.

### Scene Setup
- **`static_light`**: Constant illumination; contains a small static red cube as a distractor.
- **`dynamic_light`**: Moving light source (shifting shadows) and an additional green box not present in the reference background.

The target is a red cylinder that travels left and right behind three gray occluder pillars.

### Detection Methods

**Color-based segmentation** converts each frame to HSV and applies a hue threshold to isolate red pixels. It is robust to lighting changes as long as the target color is distinctive, but it cannot distinguish the red cylinder from other red objects in the scene.

**Background differencing** computes the absolute difference between the current frame and a reference background image, then thresholds and morphologically cleans the result. It reliably captures any moving object, but it fails when illumination changes (shadows shift pixel values) or when new objects appear that were not in the reference frame.

### Topics Explored
- HSV color space and thresholding
- Background subtraction with morphological post-processing
- Contour extraction and bounding box computation
- Minimum area thresholding to suppress small distractors
- Assumptions and failure modes of each detection approach

### Kalman Tracking
Color-mask detections from the dynamic-light scene are fed as measurements into a 2D Kalman tracker (state: x, y, ẋ, ẏ). The tracker smooths raw noisy detections, and during occlusions it coasts forward using the predict step alone.

The final plot compares raw detections, Kalman estimates, and the projected ground-truth pixel coordinates over all frames.

### Tasks
1. Compare both detection methods across both scenes; identify which method is more reliable in each condition and explain the failure modes.
2. Tune `COLOR_TRACK_MIN_AREA` to reject the small red cube while keeping the cylinder; discuss limitations of a fixed threshold and propose countermeasures.
3. Implement the Kalman update step and analyze when filtering helps (occlusions, jitter) and when it struggles (long gaps, sharp turns, false detections).
4. *(Optional)* Apply a modern deep-learning detector or segmenter (e.g., YOLO or SAM 3) to an object of your choice.

### Conclusion
No single detection method is universally robust. Color segmentation handles lighting variation but cannot separate same-colored distractors; background differencing generalizes across object types but breaks under illumination changes. Combining a robust detector with a Kalman filter improves both smoothness and resilience to short occlusions, but performance still degrades under extended gaps or a poorly matched motion model.

---

# Final Conclusion
This notebook demonstrates two fundamental perception problems in robotics: estimating state from noisy sensor measurements and detecting and tracking objects in visual scenes. The Kalman filter provides a principled solution to the first problem by fusing a motion model with measurements. Classical detection methods address the second, each with assumptions that can be violated by real-world conditions. The combined pipeline — detect, then filter — shows how perception and state estimation work together to support reliable robot behavior, while also exposing the limits of hand-engineered methods when those assumptions break down.
