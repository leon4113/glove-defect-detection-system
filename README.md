---

# Glove Defect Detection System

## Overview

This project aims to develop a glove defect detection system using image processing, computer vision, and pattern recognition techniques. The system is designed to detect common defects in different types of gloves—latex, fabric, and leather—by highlighting them and categorizing the type of defect.

## Table of Contents

1. [Introduction](#introduction)
2. [Technologies Used](#technologies-used)
3. [Features](#features)
4. [Installation](#installation)
5. [Usage](#usage)
6. [System Design](#system-design)
7. [Results](#results)

## Introduction

Gloves are used primarily for protection, but defects in gloves can compromise their effectiveness and lead to serious consequences such as injury or infection. This project addresses this issue by creating a system that can automatically detect defects in gloves using advanced image processing techniques.

## Technologies Used

- **Programming Language**: MATLAB
- **Key Techniques**:
  - Grayscale Conversion
  - Median Filtering
  - Thresholding
  - Region Filling
  - Object Removal (`bwareaopen`)
- **Detection Algorithms**: Custom algorithms to detect knocking, stain, tear, dirt, rough texture, weak seams, loose threads, and scarring.

## Features

- **Defect Detection**: Identifies various defects in gloves and categorizes them.
- **Types of Gloves Supported**: Latex, Fabric, Leather.
- **Graphical User Interface (GUI)**: Allows users to interact with the system easily.
- **Customizable Detection Parameters**: Adjust parameters for different glove types for better accuracy.

## Installation

To use this system, follow these steps:

1. **Install MATLAB**: Ensure MATLAB is installed on your system.
2. **Clone the Repository**: Download or clone this repository to your local machine.
3. **Run the Main Script**: Open MATLAB, navigate to the project directory, and run the main script to start the system.

```bash
git clone [repository link]
cd [project-directory]
matlab -r "run('main_script.m')"
```

## Usage

1. Launch the system through MATLAB.
2. Use the GUI to select the type of glove image you want to test.
3. The system will process the image and highlight any defects found, categorizing them by type.

## System Design

The system is designed with a modular approach, consisting of the following components:

1. **Pre-Processing**: Converts images to grayscale, applies median filtering, thresholding, region filling, and removes small objects.
2. **Detection**: Uses specific algorithms for each type of defect based on the properties of the gloves.
3. **User Interface**: A GUI built in MATLAB to make the system user-friendly.

### Pre-Processing Techniques

- **Grayscale**: Converts color images to grayscale.
- **Median Filtering**: Reduces noise while preserving edges.
- **Thresholding**: Converts images to binary format.
- **Region Filling**: Fills in gaps in detected regions.
- **Object Removal**: Removes small objects based on area.

### Detection Algorithms

- Detects defects such as knocking, stains, tears, dirt, rough texture, weak seams, loose threads, and scarring.
- Uses properties like circularity, area, perimeter, solidity, and extent to identify defects.

## Results

The system successfully detects various defects in glove samples, with accurate identification of tears, dirt, rough texture, and other issues across different glove types. Detailed results are discussed in the project documentation.

---
