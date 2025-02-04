# :camel: WENO
Official PyTorch implementation of our NeurIPS 2022 paper: **[Bi-directional Weakly Supervised Knowledge Distillation for Whole Slide Image Classification](https://arxiv.org/abs/2210.03664)**. We propose an end-to-end weakly supervised knowledge distillation framework (**WENO**) for WSI classification, which integrates a bag classifier and an instance classifier in a knowledge distillation framework to mutually improve the performance of both classifiers. WENO is a plug-and-play framework that can be easily applied to any existing attention-based bag classification methods.

# Notes

## Why do we need Whole Slide Image (WSI) Classification?
WSI contains histopathological images which plays crucial role in cancer diagnosis and prognosis prediction. 

## Challenges in deep learning development
1. WSI is often of huge resolution 100k*100k which needs to be tiled into smaller patches before feeding into nn. 
2. Patch-level annotation is time-consuming and labor-intensive, therefore the dataset often only contains slide-level label and lacks instance-level label

## Common Solution - Multi-Instance Labelling (MIL)
Each WSI is considered as a 'bag', patches are considered as instances. Negative bag means all instances are negative but positive bag means in the bag, there is at least one positive instance. 

Typically, MIL perform two tasks: 
1. Bag Classification

Bag classification is a more common approach as ground truth labels are often given at bag-level. This appraoch first extracts feature of each instance in a bag then aggregates the instance-level feature to bag-level feature using trainable attention mechanism. As we have bag-level labels, bag classifier is trained in supervised manner. The attention scores used to form bag-level prediction is used to evaluate the contribution of each instance. Thus, attention scores are used for instance classification. 

However, this approach suffers from two challenges:
  - Poor instance classification

  Positive instances have different difficulties to be identified. As bag-level label will be easily satisfied by identifying easy positive instance, the bag-level classifier is unable to recognize difficult instance thus making it a poor instance classifier. 
  - Bias of the bag classifier

  The trained bag-classifier has problem generalizing bags with only hard instances. 

2. Instance Classification

Instance-based approach train an instance classifier then aggregate its prediction to form a bag prediction. However, as this approach lacks instance-level labels, it needs to select some instances from positive bags to form pseudo positive instance-level label. This results in noises which limit the performance of trained instance classifier. 

## Solution: Weakly Supervised Knowledge Distillation (WENO)
WENO integrates bag and instance classifier in a knowledge distillation framework to mutually improve the performance of both classifiers by effectively transfering knowledge between them. 

<p align="center">
  <img src="https://github.com/DannyWu-KCL/WENO/blob/main/figure2.png" width="640">
</p>

(a) the teacher network is trained in advance and it keeps unchanged during training the student. Knowledge is distilled from the teacher to the student. In recent self-knowledge distillation 

(b) such as DINO [3], the teacher has the same architecture with the student and it is not trainable but updated from the student. Two-way knowledge transfer exists between the teacher and the student. 

(c) the teacher is a bag-classifier and it is also trained with weak slide-level labels. Knowledge is distilled from teacher to student by providing pseudo instance
labels using attention scores of the teacher and knowledge transfer from the student to the teacher is achieved by sharing instance feature extractors between them.

<p align="center">
  <img src="https://github.com/DannyWu-KCL/WENO/blob/main/figure3.jpg" width="640">
</p>

## Novelty of this paper

- Normalized Teachers' attention scores as soft pseudo labels of the instances in the positive bags to train student's network (instance- classifier)
- Train teacher and student networks mutually. They share an unique feature extractor but have separte classifier layers. Teacher's network will be updated first by the labels on the bag. Then the attention scores generated by teacher's network will be normalized and pass to student's network as ground truth which help mitigate the noisy pseudo label that instance-classifier might face.
- Bag classifier have trouble recognizing hard positive samples as there is no incentives for bag-classifier to learn all postivie labels. To mitigate this problem, WENO introduces hard positive instance mining (HPM) module to force bag-classifier learn difficult positive instances. It is achieved by student's network recognizing easy instances and mask it for teacher's network to force teacher's network learn difficult positive instances.

## Contribution of this paper

This paper proposed an effective framework to integrate bag and instance classifier. By training two networks alternatively with communication channel between networks, this framework is able to alleviate the challenges such as noisy pseudo label for instance-classifier and bag-classifier's inability to recognize difficult postive instances. 

## Results

<p align="center">
  <img src="https://github.com/DannyWu-KCL/WENO/blob/main/figure4.PNG" width="640">
</p>