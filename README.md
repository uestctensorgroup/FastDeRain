FastDeRain
==
|Author|Tai-Xiang Jiang|
|---|---
|E-mail|Taixiangjiang@gmail.com

Use of these codes is free for research purposes only.

The Matlab implementation of FastDeRain:\
**FastDeRain: A novel video rain streak removal method using directional gradient priors**, ***IEEE Transactions on Image Processing***, 2018. [[pdf](https://ieeexplore.ieee.org/document/8531762/)]

and DIP:\
**A Novel Tensor-Based Video Rain Streaks Removal Approach via Utilizing Discriminatively Intrinsic Priors**, ***CVPR*** 2017. [[PDF](http://openaccess.thecvf.com/content_cvpr_2017/papers/Jiang_A_Novel_Tensor-Based_CVPR_2017_paper.pdf)]

--\
Updating: A lite version has been released

[[Google Cloud](https://drive.google.com/file/d/1_m4oaNY0i7uOCJAIKgI0MkMWVExEwQyo/view?usp=sharing)]  [[Baidu Yun](https://pan.baidu.com/s/1Oa9wUh0eGif4_RYjU7NcoQ)] key: eukg
--

Brief description
--

This folder contains the implementation of the algorithm for video rain streaks removal named FastDeRain.

### Main file:
|File name|Description|
|---|---|
|Demo.m|Demo of the conparison including:|
||FastDeRain ***TIP2018*** implemented on **GPU** (it's easy to transfer the code to a CPU version)|
|| DIP ***CVPR 2017*** implemented on **GPU**(it's easy to transfer the code to a CPU version)|
|| MS-CSC ***CVPR 2018*** partially implemented on **GPU**) |
|| SPAC-CNN ***CVPR 2018*** implemented on **GPU** (MatConNet)|
|| DDN ***CVPR 2017*** single image method (MatConNet) |
|| TCL ***TIP 2015***|

### Other file:
1. [A brief collection of works on image and video rain removal](https://github.com/TaiXiangJiang/FastDeRain/blob/master/state-of-the-art%20deraining%20methods.md)
2. File "[UGSM_v3.0.zip](https://github.com/TaiXiangJiang/FastDeRain/blob/master/UGSM_v2.0.zip)": our method for single image rain streaks removal in this article:\
Liang-Jian Deng, Ting-Zhu Huang, Xi-Le Zhao, and Tai-Xiang Jiang; "A directional global sparse model for single image rain removal." Applied Mathematical Modelling (2018).\
3. File "[yard.mp4](https://github.com/TaiXiangJiang/FastDeRain/blob/local/yard.mp4)" : the rainy video captured by Liang-Jian Deng.



Date: 20/Nov./2018




If you use this code, please cite

      @article{jiang2018fastderain,
            title={Fastderain: A novel video rain streak removal method using directional gradient priors},
            author={Jiang, Tai-Xiang and Huang, Ting-Zhu and Zhao, Xi-Le and Deng, Liang-Jian and Wang, Yao},
            journal={IEEE Transactions on Image Processing},
            volume={28},
            number={4},
            pages={2089--2102},
            year={2018},
            publisher={IEEE}}

      @InProceedings{Jiang_2017_CVPR,
         author    = {Jiang, Tai-Xiang and Huang, Ting-Zhu and Zhao, Xi-Le and Deng, Liang-Jian and Wang, Yao},
         title     = {A Novel Tensor-Based Video Rain Streaks Removal Approach via Utilizing Discriminatively Intrinsic Priors},
         booktitle = {Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition (CVPR)},
         month     = {July},
         pages     = {2818-2827},
         doi       = {10.1109/CVPR.2017.301},
         year      = {2017}}

