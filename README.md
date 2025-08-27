<div align="center">

# Single-Pixel Tactile Skin via Compressive Sampling

[Ariel Slepyan](https://scholar.google.com/citations?hl=en&user=8uVwi4UAAAAJ&view_op=list_works&sortby=pubdate)<sup>1</sup>†, 
[Wanting Xing](https://scholar.google.com/citations?view_op=list_works&hl=en&user=L_5PIfgAAAAJ)<sup>2</sup>†, 
[Xuanming Zhang](https://www.researchgate.net/profile/Aidan_Aug)<sup>1</sup>†, 
[Nitish Thakor](https://scholar.google.com/citations?user=SB_7Bi0AAAAJ&hl=en)<sup>1,2,3</sup>
<br />
<sup>1</sup> Department of Electrical and Computer Engineering, Johns Hopkins University, Baltimore, USA<br />
<sup>2</sup> Department of Biomedical Engineering, Johns Hopkins School of Medicine, Baltimore, USA<br />
<sup>3</sup> Department of Neurology, Johns Hopkins School of Medicine, Baltimore, USA<br />
†These authors contributed equally to this study.
</div>

## Data folders
Our data files are located in `SPTS/Data_Analysis`. Each data folder is explained below.
* `/Measurements_Collected` contains both raster and compressive scans for 17 daily objects;
* `/Application_Data` contains both compressive scans we collected for Rapid Contact Localization `/ball_bouncing` and the demo video with the robot arm `/robort_arm`.
  
## Usage
The codes for using our methods for tactile image data and realizing our results are explained below. The folder `ksvdbox13` for training ksvd dictionary was downloaded from [here](https://csaws.cs.technion.ac.il/~ronrubin/software.html). This folder is included in the repository at `SPTS/Data_Analysis/Dictionary_Learning`.
  
### Compressed and Raster Data Acquisition
All files associated with data collection is in `/Data_Collection`. To collect data, please first upload the code in`Microcontroller_Code/Receiver_Code/Receiver_Code.ino` onto each Attiny412 on the tactile sensor hardware using a USB UPDI uploader. Make sure that each Attiny412 has a different address by changing the "adrs" variable before you upload to the microcontroller. Once all Attiny412s are programmed, connect the Teensy4.1 to your computer and upload the code in `/Microcontroller_Code/Transmitter_Code/Transmitter_Code.ino`. Depending on whether you would like to collect raster scans or compressive scans, follow instuctions in the comments at the Loop function. Once the transmitter code is uploaded, immediately run the matlab script in `/Matlab_Code/DataCollection.m`, and data collections should start. You can end data collection by simply using the stop button in matlab.

### Tactile Dictionary Learning
The folder `Data_Analysis/Dictionary_Learning` is for creating the dictionary used during OMP reconstruction. For our usage, we opened ran `visualize_learnD.m`, which loads raster scan entries inside `Raster_Entries.mat` to generate the dictionary, which saves it as `dictionary.mat`. For the applications section, since objects are dropped to different locations of the sensor, we have to permute each entry in the dictionary to every possible location on the sensor. To achieve this, we ran `permutation.m` on `dictionary.mat`, and its output is saved as `permuted_dictionary.mat` in the same directory. 

### SRC Library for SRC Accuracy Measurement
Raster scans used as examples for the SRC library are located in `Data_Analysis/SRC_Library/Library_Entries`, separate for each object. There are 10 scans for each object. Library is created by appending scans for all object together, back to back, in addition to adding 10 blank frames (100*1 vector) at front as the "empty" object. The finalized library is in `Data_Analysis/SRC_Library/SRC_lib.mat`.

### Random Weights Generation
Files responsible for generating random binary weights that all Attiny412s are programmed to generate are in `Data_Analysis/Random_Weights_Generation`. The same LCG function used by every Attiny412 is defined in `lcgRandom.m`, which is called by `amatrix.m` to generate random weight sequences based on the seed and the length of the sequence wanted. For our application, to save time later on, we generated all random weights before data processing: for seeds 8-107 and for a length of 100000, so that no matter how long we collect data, we always have corresponding weights. This is automated in `generate_weights.m`, please run it before any data processing steps. 

### Support Accuracy

### SRC Accuracy

### High-Speed Projectile Tracking and Rapid Contact Localization

### Robot Arm Demonstration


### Helper Functions
The folder `SPTS/Data_Analysis/utilities/` contains helper functions used by scrips described above.
* `OMP.m` Orthognal Matching Pursuit algorithm used throughout the project.
* `SRCAccuracy.m` performs classifications on a input frame using sparse recovery per each object. Classification is assigned to the object whose sparse recovery representation matches the input frame the most, and check if this classification agrees with the ground truth. Returns binary results.
* `SupportAccuracy.m` calculates how a reconstructed frame agrees with a ground truth raster frame of the same object. Pixels are converted to binary by the threshold of 0.23 times maximum sensed pressure. Comparisions are then done by comparing the two frame pixel by pixel, checking if binary data match. Returns a value between 0 and 1. 
* `centerOfMass.m` calculates center of mass for a frame by calculating weighted averages across x and y axis. Returns coordinates.
* `downSample.m` evenly removes pixel data across a raster scanned frame, depending on how many pixels are specified to keep.
* `transpose_Ay.m` transposes and stitches A matrix and y matrix from a 3D array and 2D matrix to a 2D matrix and 1D list. This is for reconstruction.

## Citation

## Acknowledgement
We sincerely appreciate Prof. Jeremy Brown for his advice on this work. We also many many thanks Dr. Ron Rubinstein for his code for training the ksvd dictionary.

## Contact
If you have any questions or inquiries, please feel free to contact:
Arik Slepyan aslepya1@jh.edu:
Wanting Xing: wxing2@jh.edu :
Xuanming Zhang: xzhan221@jh.edu.
