title=Model Registry tech demo 20231121
date=2023-11-21
type=post
tags=blog
status=published
~~~~~~

<div class="row justify-content-center text-center py-3">
 <div class="col-lg-6">
  <div class="ratio ratio-16x9">
   <iframe src="https://www.youtube.com/embed/grXnjGtDFXg" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
  </div>
 </div>
</div>

This is a [technical demo](https://en.wikipedia.org/wiki/Technology_demonstration) from the [Model Registry](https://github.com/opendatahub-io/model-registry) team of [Open Data Hub](https://opendatahub.io).

Content:
 - model-registry-operator
 - Notebook → Model Registry
 - DS Pipeline → Model Registry
 - Model Registry → Serving
 - One More Thing...
 - Conclusions

This post does not go into details of context and background of the Model Registry, for which we invite you to checkout [this document](https://docs.google.com/document/d/1T3KfOqIfJohp0s1koQ2XrJJQQhj7TECO-m2xPsW59_c/edit?usp=sharing) instead.

## model-registry-operator

We can use the [Model Registry Operator](https://github.com/opendatahub-io/model-registry-operator) to install the Model Registry in our Kubernetes platform.
Installing the operator is easy, following a few steps as detailed in the README.

First, we install a Custom Resource Definition for our Model Registry:

![](model-registry-tech-demo-20231121/Screenshot%202023-12-02%20at%2020.54.21%20(2).png)

Then, we deploy the `model-registry-operator` which at present sits in its own namespace:

![](model-registry-tech-demo-20231121/Screenshot%202023-12-02%20at%2020.58.10%20(2).png)

Finally, we create a Model Registry instance:

![](model-registry-tech-demo-20231121/Screenshot%202023-12-02%20at%2021.01.57%20(2).png)

With an instance of Model Registry now available, we can move to perform some ML training using Notebook in order to later index the resulting models on this model registry instance.

## Notebook → Model Registry

For the scope of this technical demo of Model Registry, we will be training and making inference with the [MNIST dataset](https://en.wikipedia.org/wiki/MNIST_database), serving as an "hello world" style of example for neural network usages.

We are given some training data set to perform training: given the following image, the training label is defined as '3':

![](model-registry-tech-demo-20231121/Screenshot%202023-12-02%20at%2021.14.11%20(2).png)

So, given the following image from the test data set, we would like our ML model (once trained) to successfully predict the label '4':

![](model-registry-tech-demo-20231121/Screenshot%202023-12-02%20at%2021.15.26%20(2).png)

### Notebook → Model Registry: First model version

We can start training a first version of our neural network:

![](model-registry-tech-demo-20231121/Screenshot%202023-12-02%20at%2021.17.03%20(2).png)

And after some quick dry-run to check the prediction seems reasonable:

![](model-registry-tech-demo-20231121/Screenshot%202023-12-02%20at%2021.17.32%20(2).png)

We can store the trained ML model in an S3-compatible bucket:

![](model-registry-tech-demo-20231121/Screenshot%202023-12-02%20at%2021.19.46%20(2).png)

And index the model in our Model Registry:

![](model-registry-tech-demo-20231121/Screenshot%202023-12-02%20at%2021.19.53%20(2).png)

### Notebook → Model Registry: Second model version

For the scope of this technical demo, we can now train a second version of our ML model, by defining instead a convolutional neural network:

![](model-registry-tech-demo-20231121/Screenshot%202023-12-02%20at%2021.22.50%20(2).png)

We can perform again some quick dry-run to check the prediction seems reasonable, store the trained model in the S3 bucket, and index the model in the Model Registry:

![](model-registry-tech-demo-20231121/Screenshot%202023-12-02%20at%2021.24.43%20(2).png)

We can notice in the outputs the entities created on the Model Registry.

### Notebook → Model Registry: REST APIs

We don't have yet a GUI web application to display the metadata in our Model Registry, but we can perform this exercise by making use of the REST APIs from the command line.

We can display the known RegisteredModel, in this case we called our RegisteredModel `MNIST` (as we've been using the MNIST dataset):

```
MR_HOSTNAME=...

curl --silent -X 'GET' \
  "$MR_HOSTNAME/api/model_registry/v1alpha1/registered_models?pageSize=100&orderBy=ID&sortOrder=DESC&nextPageToken=" \
  -H 'accept: application/json' | jq .items
```

![](model-registry-tech-demo-20231121/Screenshot%202023-12-02%20at%2021.29.58%20(2).png)

We can display the two versions we have just indexed, which are referencing as well the models as Stored in S3:

```
curl --silent -X 'GET' \
  "$MR_HOSTNAME/api/model_registry/v1alpha1/model_versions?pageSize=100&orderBy=ID&sortOrder=DESC&nextPageToken=" \
  -H 'accept: application/json' | jq .items
```

![](model-registry-tech-demo-20231121/Screenshot%202023-12-02%20at%2021.32.42%20(2).png)

And we can display details for the ModelArtifact corresponding to the latter version:

```
curl --silent -X 'GET' \
  "$MR_HOSTNAME/api/model_registry/v1alpha1/model_versions/4/artifacts" \
  -H 'accept: application/json' | jq .items
```

![](model-registry-tech-demo-20231121/Screenshot%202023-12-02%20at%2021.33.59%20(2).png)

We can move now to Data Science Pipeline.

## DS Pipeline → Model Registry

We can create a Data Science Pipeline (DSP) which performs analogous steps in training, validating, storing and indexing the ML model:

![](model-registry-tech-demo-20231121/Screenshot%202023-12-02%20at%2021.40.37%20(2).png)

We can create a DSP Run, possibly using specific parameters which influence the model training and validation; since the trained model matches the requirements defined in the pipeline, this run successfully completed, the model is stored once again on a S3-compatible bucket and the metadata are indexed on the Model Registry. We have now 3 versions of our ML model:

![](model-registry-tech-demo-20231121/Screenshot%202023-12-02%20at%2021.52.50%20(2).png)

We have now a bunch of of ModelVersion(s) available on the Model Registry, ready to be deployed for inference using Model Serving.

## Model Registry → Serving

We can use the following REST API to create an entity for InferenceService on the Model Registry:

```
curl -X 'POST' \
  $MR_HOSTNAME'/api/model_registry/v1alpha1/serving_environments/1/inference_services' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "name": "mnist-e2e",
  "modelVersionId": "4",
  "runtime": "mmserver1",
  "registeredModelId": "2",
  "servingEnvironmentId": "1",
  "state": "DEPLOYED"
}'
```

![](model-registry-tech-demo-20231121/Screenshot%202023-12-02%20at%2022.05.03%20(2).png)

It's important to note the Model Registry is *not* an active orchestrator; what actually happens behind the scene is that the K8s Model Controller performs a reconciliation loop and based on the metadata we just created on the Model Registry, create a CR for ModelMesh in order to deploy our ML for Inference:

![](model-registry-tech-demo-20231121/Screenshot%202023-12-02%20at%2022.09.01%20(2).png)

We can as well undeploy the InferenceService by changing flipping the status on the Model Registry; in this case the same reconcilation loop will trigger again, but will proceed accordingly to remove the ModelMesh CR for Serving:

```
curl -X 'PATCH' \
  "$MR_HOSTNAME/api/model_registry/v1alpha1/inference_services/6" \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "modelVersionId": "4",
  "runtime": "mmserver1",
  "state": "UNDEPLOYED"
}'
```

![](model-registry-tech-demo-20231121/Screenshot%202023-12-02%20at%2022.13.00%20(2).png)

## One More Thing...

To wrap-up this technical exercise, we can re-deploy once more our trained ML model and noting the inference service endpoint:

![](model-registry-tech-demo-20231121/Screenshot%202023-12-02%20at%2022.16.26%20(2).png)

As we can use it to deploy some Intelligent Application on Kubernetes:

![](model-registry-tech-demo-20231121/Screenshot%202023-12-02%20at%2022.21.41%20(2).png)

Which in this case is a (very raw cut!) PoC application exercising our ML inference endpoint on ModelMesh for Model Serving; as we draw by hand:

![](model-registry-tech-demo-20231121/Screenshot%202023-12-02%20at%2022.23.00%20(2).png)

We will get back an array of probabilities; since index 2 is the most probable, our intelligent application is predicting we have drawn the `number: 2` thanks to the model we just trained, indexed and deployed, all while making use of Model Registry!

## Conclusions

In this short technical demo we have explored some of the capabilites of the Model Registry by making an end-to-end demo.

We have installed the model-registry-operator in order to deploy our instance of Model Registry.

We have performed a couple of training of ML neural networks, stored them in an S3 bucket and indexed those model in the Model Registry. We have also performed analogously from the perspective of Data Science Pipelines, which may include parametrization, model validation, etc.

We have seen how Model Registry is *not* an active orchestrator but a metadata repository; following established Kubernetes best-practices a reconciliation loop from the Model Controller make sure to enact the correct CustomResource deployment and update in the cluster. This mechanism is used to govern deployment of ML models which the Model Registry have previously maintained index, per the previous steps.

Finally, we have seen how to leverage the Inference endpoint of the deployed ML model to drive the end-to-end workload of intelligent application on top of Kubernetes!

If you found this content interesting, don't hesitate to join the conversation:
- https://github.com/kubeflow/kubeflow/issues/7396 
- https://www.kubeflow.org/docs/about/community/#kubeflow-community-call
