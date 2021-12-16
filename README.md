## Adaptive structure discovery for multimedia analysis using multiple features
Multi-feature learning has been a fundamental research problem in multimedia analysis. Most existing multi-feature learning methods exploit graph, which must be computed beforehand, as input to uncover data distribution. These methods have two major problems confronted. First, graph construction requires calculating similarity based on nearby data pairs by a fixed function, e.g., the RBF kernel, but, the intrinsic correlation among different data pairs varies constantly. Therefore, feature learning based on such pre-computed graphs may degrade, especially when there is dramatic correlation variation between nearby data pairs. Second, in most existing algorithms, each single-feature graph is computed independently and then combine them for learning, which ignores the correlation between multiple features. In this paper, a new unsupervised multi-feature learning method is proposed to make the best utilization of the correlation among different features by jointly optimizing data correlation from multiple features in an adaptive way. As opposed to computing the affinity weight of data pairs by a fixed function, the weight of affinity graph is learned by a well-designed optimization problem. Additionally, the affinity graph of data pairs from different features are optimized in a global level to better leverage the correlation among different channels. In this way, the adaptive approach correlates the features of all features for a better learning process. Experimental results on real world datasets demonstrate that our approach outperforms the state-of-the-art algorithms on leveraging multiple features for multimedia analysis.

## Citation
We appreciate it if you cite the following paper:
```
@Article{zhantcybASMV,
  author =  {Kun Zhan and Xiaojun Chang and Junpeng Guan and Ling Chen and Zhigang Ma and Yi Yang},
  title =   {Adaptive structure discovery for multimedia analysis using multiple features},
  journal = {IEEE Transactions on Cybernetics},
  year =    {2019},
  volume =  {49},
  number =  {5},
  pages =   {1826--1834}
 }
```
<a href="https://doi.org/10.1109/TCYB.2018.2815012"><img src="https://zenodo.org/badge/DOI/10.1109/TCYB.2017.2751646.svg" alt="DOI"></a>

## Contact
http://www.escience.cn/people/kzhan

If you have any questions, feel free to contact me. (Email: `ice.echo#gmail.com`)