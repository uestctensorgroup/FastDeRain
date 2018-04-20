FastDeRain
==
The Matlab implementation and video results of FastDeRain

Brief description
--

This folder contains the implementation of the algorithm for video rain streaks removal named FastDeRain.

### Main files:
|File name|Description|
|---|---|
|Demo_FastDerain.m|Demo of FastDeRain, implemented on **CPU**|
|Demo_FastDerain_GPU_version.m|Demo of FastDeRain, implemented on **GPU**|
|Demo_FastDerain_Oblique.m|Demo of FastDeRain for **oblique rain streaks**, implemented on **GPU**|

Refference
--
An early material of the this menthod is:\
Tai-Xiang Jiang, Ting-Zhu Huang, Xi-Le Zhao, Liang-Jian Deng, Yao Wang; ''A Novel Tensor-Based Video Rain Streaks Removal Approach via Utilizing Discriminatively Intrinsic Priors'' The IEEE Conference on Computer Vision and Pattern Recognition (CVPR), 2017, pp. 4057-4066\
[[PDF](http://openaccess.thecvf.com/content_cvpr_2017/papers/Jiang_A_Novel_Tensor-Based_CVPR_2017_paper.pdf)]

The preprint of the extended journal version:\
Tai-Xiang Jiang, Ting-Zhu Huang, Xi-Le Zhao, Liang-Jian Deng, Yao Wang; “Fastderain: A novel video rain streak removal method using
directional gradient priors,” ArXiv e-prints, 2018.
[[arXiv]( https://arxiv.org/abs/1803.07487)]  [[PDF]( https://arxiv.org/pdf/1803.07487)]  

If you use this code, please cite

      @InProceedings{Jiang_2017_CVPR,
         author    = {Jiang, Tai-Xiang and Huang, Ting-Zhu and Zhao, Xi-Le and Deng, Liang-Jian and Wang, Yao},
         title     = {A Novel Tensor-Based Video Rain Streaks Removal Approach via Utilizing Discriminatively Intrinsic Priors},
         booktitle = {The IEEE Conference on Computer Vision and Pattern Recognition (CVPR)},
         month     = {July},
         pages     = {2818-2827},
         doi       = {10.1109/CVPR.2017.301},
         year      = {2017}}

      @article{Jiang2018FastDeRain,
         author    = {Jiang, Tai-Xiang and Huang, Ting-Zhu and Zhao, Xi-Le and Deng, Liang-Jian and Wang, Yao},
         title     = {FastDeRain: A Novel Video Rain Streak Removal Method Using Directional Gradient Priors},
         journal   = {ArXiv e-prints},
         eprint    = {1803.07487},
         year      = {2018},
         url       = {https://arxiv.org/pdf/1803.07487.pdf}}

Meanwhile, our method for single image rain streaks removal are detailed in this article:\
Liang-Jian Deng, Ting-Zhu Huang, Xi-Le Zhao, and Tai-Xiang Jiang; "A directional global sparse model for single image rain removal." Applied Mathematical Modelling (2018).\
Corresponding codes are compressed in the file "UGSM_v3.0.zip".

      @article{deng2018directional,
         title     = {A directional global sparse model for single image rain removal},
         author    = {Deng, Liang-Jian and Huang, Ting-Zhu and Zhao, Xi-Le and Jiang, Tai-Xiang},
         journal   = {Applied Mathematical Modelling},
         volume    = {59},
         pages     = {662 -- 679},
         year      = {2018},
         publisher = {Elsevier}
         doi       = {10.1016/j.apm.2018.03.001}}



(The .p files will be replaced by .m files as soon as possible.)\

Contact
--
|Author|Tai-Xiang Jiang|
|---|---
|E-mail|Taixiangjiang@gmail.com

Date: 03/03/2018
