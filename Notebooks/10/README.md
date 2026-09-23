# Bayesian Optimization and Controller Tuning

## Overview

This notebook explores **Bayesian Optimization (BO)** as a method for optimizing expensive black-box functions. It begins with the fundamental components of Bayesian optimization, including Gaussian Processes and acquisition functions, and then applies these ideas using both a custom implementation and the Ax optimization library.

The notebook progresses from simple one-dimensional optimization to higher-dimensional controller tuning for an inverted pendulum and finally introduces **multi-objective Bayesian optimization**.

Throughout the notebook, experiments are used to investigate how surrogate models, acquisition functions, search-space dimensionality, and multiple competing objectives affect optimization.

---

## 1. Imports and Utility Functions

The notebook begins by installing and importing the required libraries, including:

- Gymnasium
- NumPy
- SciPy
- PyTorch
- BoTorch
- GPyTorch
- Ax
- MuJoCo
- Matplotlib
- MediaPy

A helper function is also provided for rendering complete episodes and visualizing the behavior of optimized controllers.

---

## 2. Bayesian Optimization

Bayesian Optimization is introduced as a technique for optimizing **black-box functions that are expensive to evaluate**.

Instead of evaluating the objective everywhere, Bayesian optimization builds a probabilistic model of the unknown function and uses this model to decide which point should be evaluated next.

The general process is:

**evaluate points → fit surrogate model → select next candidate → evaluate candidate → update model → repeat**

### Conclusion

Bayesian optimization can reduce the number of expensive function evaluations by using information from previous observations to guide future evaluations.

This makes it particularly useful when evaluating the objective is costly or time-consuming.

---

## 3. Gaussian Processes

A **Gaussian Process (GP)** is used as the surrogate model for the unknown objective function.

The notebook implements a Gaussian Process that uses observed samples to predict:

- The expected function value
- The uncertainty of the prediction

Different kernel functions can be used to determine how strongly nearby observations influence one another.

Topics explored include:

- Gaussian Process regression
- Kernel functions
- Observation noise
- Predictive mean
- Predictive uncertainty
- Updating the surrogate model

### Conclusion

Gaussian Processes provide both predictions and uncertainty estimates. This uncertainty information is especially important for Bayesian optimization because it allows the optimizer to distinguish well-explored regions from uncertain regions.

The choice of kernel also affects assumptions about the shape and smoothness of the underlying function.

---

## 4. Acquisition Functions

Acquisition functions determine which candidate point should be evaluated next.

They use the Gaussian Process predictions to balance two competing goals:

- **Exploitation:** evaluating regions that are expected to perform well.
- **Exploration:** evaluating uncertain regions that may contain better solutions.

The notebook implements and experiments with different acquisition strategies, including **Expected Improvement** and entropy-based selection.

### Conclusion

The acquisition function controls the search behavior of Bayesian optimization.

More exploitative strategies concentrate evaluations around promising solutions, while more exploratory strategies investigate uncertain regions of the search space.

---

## 5. Custom Bayesian Optimization

A custom `BayesOpt` class combines the Gaussian Process surrogate model with an acquisition function.

The optimizer repeatedly:

1. Fits the Gaussian Process to existing observations.
2. Predicts the objective across candidate points.
3. Evaluates the acquisition function.
4. Selects the next candidate.
5. Evaluates the true objective.
6. Updates the model with the new observation.

A nonlinear one-dimensional function is used to visualize the optimization process.

### Conclusion

The experiment demonstrates how Bayesian optimization progressively improves its approximation of an unknown objective while concentrating evaluations in informative or promising regions.

Changing the Gaussian Process kernel or acquisition function can significantly alter the optimizer's behavior.

---

## 6. Bayesian Optimization with Ax

The notebook then introduces **Ax**, a library for adaptive experimentation and Bayesian optimization.

Instead of manually implementing the surrogate model and acquisition process, Ax handles much of the optimization workflow.

A one-dimensional nonlinear function is optimized by defining:

- A search space
- An objective
- A Bayesian optimization model
- Sequential optimization trials

The resulting model can also be visualized to inspect the estimated objective function.

### Conclusion

Ax provides a higher-level interface for Bayesian optimization and simplifies experiment management, candidate generation, and model-based optimization.

This makes it easier to apply Bayesian optimization to more complex problems without manually implementing every component.

---

## 7. Effect of Objective Function Complexity

The notebook investigates how changes to the objective function affect Bayesian optimization.

Experiments include:

- Increasing the frequency of periodic components
- Introducing discontinuities
- Investigating whether narrow or difficult optima can be missed

### Conclusion

Bayesian optimization performance depends on how well the surrogate model represents the underlying objective.

Functions with rapid changes or discontinuities can be more difficult for smooth Gaussian Process models to approximate, which can affect the optimizer's ability to identify the true optimum.

---

## 8. High-Dimensional Bayesian Optimization

The notebook extends Bayesian optimization from a one-dimensional example to a higher-dimensional control problem.

A state-feedback controller is defined using four gain parameters:

- Position proportional gain
- Angle proportional gain
- Position derivative gain
- Angle derivative gain

These gains determine the control action applied to the system.

### Conclusion

Higher-dimensional optimization introduces a much larger search space. Bayesian optimization provides a systematic approach for searching this space without exhaustively evaluating every possible parameter combination.

---

## 9. Controller Optimization for Inverted Pendulum

Bayesian optimization with Ax is used to tune the parameters of a controller for the **InvertedPendulum-v4** environment.

A controller evaluation function executes multiple environment runs and measures the resulting performance.

Ax searches over the four controller gains and identifies parameter combinations that produce better behavior.

Topics explored include:

- Controller parameter tuning
- Expensive policy evaluation
- Four-dimensional search spaces
- Repeated evaluation runs
- Best-parameter extraction
- Contour visualization

### Conclusion

The experiment demonstrates that Bayesian optimization can be used for controller tuning when evaluating each controller configuration requires running a simulation.

Instead of manually selecting gains, the optimizer uses observed controller performance to guide the search toward more promising parameter combinations.

---

## 10. Visualizing the Optimization Landscape

Ax contour plots are used to inspect the estimated relationship between pairs of controller parameters.

These plots show both the estimated objective landscape and the uncertainty learned by the Bayesian optimization model.

The best controller parameters can then be used to render an episode of the inverted pendulum environment.

### Conclusion

Visualization can provide insight into parameter interactions and reveal which regions of the search space appear promising.

It can also help guide adjustments to parameter ranges or future optimization experiments.

---

## 11. Multi-Objective Bayesian Optimization

The notebook introduces **multi-objective optimization**, where several objectives must be optimized simultaneously.

Unlike single-objective optimization, there may not be one solution that is best for every objective.

Instead, optimization produces a collection of solutions representing different compromises between competing objectives.

The notebook first demonstrates this using the two-objective **Branin-Currin** benchmark problem.

### Conclusion

Multi-objective optimization is useful when objectives conflict and no predefined weighting between them is available.

Rather than producing only one solution, it identifies multiple useful trade-offs.

---

## 12. Pareto Frontier

The results of multi-objective optimization are represented using a **Pareto frontier**.

A solution is Pareto-optimal when improving one objective would require making at least one other objective worse.

Ax is used to compute and visualize the Pareto-optimal solutions found during optimization.

### Conclusion

The Pareto frontier provides a clear representation of the trade-offs between competing objectives.

Each point on the frontier represents a potentially useful solution depending on how much importance is assigned to each objective.

---

## 13. Multi-Objective Controller Optimization

The final experiment applies multi-objective Bayesian optimization to controller tuning.

The controller is optimized with respect to multiple quantities, including:

- **Cumulative return**
- **Cumulative energy consumption**

This creates a trade-off between achieving good control performance and reducing the amount of control effort or energy used.

### Conclusion

Multi-objective Bayesian optimization makes it possible to search for controllers that balance performance and efficiency instead of optimizing only a single metric.

The resulting Pareto-optimal controllers represent different compromises between cumulative reward and energy consumption.

---

## Learning Outcomes

By completing this notebook, the following skills were developed:

- Understanding the motivation behind Bayesian optimization
- Understanding black-box optimization
- Using Gaussian Processes as surrogate models
- Interpreting predictive mean and uncertainty
- Understanding the role of kernels in Gaussian Processes
- Understanding exploration and exploitation
- Implementing and comparing acquisition functions
- Building a simple Bayesian optimization algorithm
- Using Ax and BoTorch for Bayesian optimization
- Applying Bayesian optimization to higher-dimensional problems
- Optimizing controller parameters in simulated environments
- Visualizing optimization landscapes using contour plots
- Understanding multi-objective optimization
- Understanding Pareto optimality and Pareto frontiers
- Optimizing competing objectives such as controller performance and energy consumption

This notebook provides a practical progression from the foundations of **Gaussian Process-based Bayesian optimization** to higher-dimensional and multi-objective optimization, demonstrating how Bayesian optimization can efficiently tune controllers and solve expensive optimization problems.
