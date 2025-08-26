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

## Usage
The codes for using our methods for tactile image data and realizing our results are explained below. The folder `ksvdbox13` for training ksvd dictionary was downloaded from [here](https://csaws.cs.technion.ac.il/~ronrubin/software.html). This folder is included in the repository at `SPTS/Data_Analysis/Dictionary_Learning`.

### Data folders
Our data files are located in `SPTS/Data_Analysis`. Each data folder is explained below.
* `/Measurements_Collected` contains both raster and compressive scans for 17 daily objects;
* `/Application_Data` contains both compressive scans we collected for Rapid Contact Localization `/ball_bouncing` and the demo video with the robot arm `/robort_arm`.
* 
### Compressed and Raster Data Acquisition

## Applications


## Helper Functions
The folder `SPTS/Data_Analysis/utilities/` contains helper functions used by scrips described above.
* `OMP.m` Orthognal Matching Pursuit algorithm used throughout the project.
* `SRCAccuracy.m` performs classifications on a input frame using sparse recovery per each object. Classification is assigned to the object whose sparse recovery representation matches the input frame the most, and check if this classification agrees with the ground truth. Returns binary results.
* `SupportAccuracy.m` 
* `centerOfMass.m` 
* `downSample.m` 
* `transpose_Ay.m` 

## Citation

## Acknowledgement
We sincerely appreciate Prof. Jeremy Brown for his advice on this work. We also many many thanks Dr. Ron Rubinstein for his code for training the ksvd dictionary.

## Contact
If you have any questions or inquiries, please feel free to contact:
Arik Slepyan aslepya1@jh.edu:
Wanting Xing: wxing2@jh.edu :
Xuanming Zhang: xzhan221@jh.edu.
