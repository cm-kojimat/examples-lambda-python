#!/usr/bin/env node

import * as path from "path";

import * as cdk from "@aws-cdk/core";
import * as lambda from "@aws-cdk/aws-lambda";
import { PythonFunction } from "@aws-cdk/aws-lambda-python";

async function ExamplesLambdaPython(
  scope: cdk.Construct,
  id: string,
  props?: cdk.StackProps
) {
  const stack = new cdk.Stack(scope, id, props);

  new PythonFunction(stack, "MyFunction", {
    entry: path.resolve(__dirname, "../src"),
    index: "examples_lambda_python/index.py",
    runtime: lambda.Runtime.PYTHON_3_8,
  });
}

const app = new cdk.App();
ExamplesLambdaPython(app, "AwsCdkStack");
