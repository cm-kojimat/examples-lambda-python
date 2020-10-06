resource random_string container_name {
  length  = 8
  special = false
}

resource docker_container examples_lambda_python {
  image = "lambci/lambda:build-python3.8"
  name  = random_string.container_name.result

  command = [
    "pip",
    "install",
    "-r",
    "requirements.txt",
    "-t",
    "/var/task/layer/python"
  ]

  volumes {
    host_path      = abspath("${path.module}/../../src/")
    container_path = "/var/task/"
  }

  volumes {
    host_path      = abspath("${path.module}/layer/python/")
    container_path = "/var/task/layer/python/"
  }
}
