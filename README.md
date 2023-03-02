# :camel: WENO
Official PyTorch implementation of our NeurIPS 2022 paper: **[Bi-directional Weakly Supervised Knowledge Distillation for Whole Slide Image Classification](https://arxiv.org/abs/2210.03664)**. We propose an end-to-end weakly supervised knowledge distillation framework (**WENO**) for WSI classification, which integrates a bag classifier and an instance classifier in a knowledge distillation framework to mutually improve the performance of both classifiers. WENO is a plug-and-play framework that can be easily applied to any existing attention-based bag classification methods.

<p align="center">
  <img src="https://github.com/miccaiif/WENO/blob/main/figure3.jpg" width="640">
</p>


# Notes

# Why do we need Whole Slide Image (WSI) Classification?
WSI contains histopathological images which plays crucial role in cancer diagnosis and prognosis prediction. 

# Challenges in deep learning development
1. WSI is often of huge resolution 100k*100k which needs to be tiled into smaller patches before feeding into nn. 
2. Patch-level annotation is time-consuming and labor-intensive, therefore the dataset often only contains slide-level label and lacks instance-level label

# Common Solution - Multi-Instance Labelling (MIL)
Each WSI is considered as a 'bag', patches are considered as instances. Negative bag means all instances are negative but positive bag means in the bag, there is at least one positive instance. \

Typically, MIL perform two tasks: \
- Bag Classification
Bag classification is a more common approach as ground truth labels are often given at bag-level. This appraoch first extracts feature of each instance in a bag then aggregates the instance-level feature to bag-level feature using trainable attention mechanism. As we have bag-level labels, bag classifier is trained in supervised manner. The attention scores used to form bag-level prediction is used to evaluate the contribution of each instance. Thus, attention scores are used for instance classification. \

However, this approach suffers from two challenges:
1. Poor instance classification
Positive instances have different difficulties to be identified. As bag-level label will be easily satisfied by identifying easy positive instance, the bag-level classifier is unable to recognize difficult instance thus making it a poor instance classifier. 
2. Bias of the bag classifier
The trained bag-classifier has problem generalizing bags with only hard instances. 

- Instance Classification
Instance-based approach train an instance classifier then aggregate its prediction to form a bag prediction. However, as this approach lacks instance-level labels, it needs to select some instances from positive bags to form pseudo positive instance-level label. This results in noises which limit the performance of trained instance classifier. 
