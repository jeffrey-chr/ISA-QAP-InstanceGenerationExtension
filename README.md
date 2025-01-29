# ISA-QAP-InstanceGenerationGenetic

Contains generators used in the expanded instance space

## Evolved

Given a distance matrix from an existing instance, evolves parameters for a flow generator to produce instances near a particular point in the instance space.

## Flowcluster

Combine a Hypercube or Terminal-type distance matrix with a flow matrix based on clusters of facilities with large flows between them, in various patterns. 

## Recombine

Referred to as "Hybrid" instances in our paper, combine distance and flow generators from different classes to create a new QAP instance. (We do not combine specific instances since this would limit our options to instances of the same size.)