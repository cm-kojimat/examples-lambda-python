resource random_string container_name {
  length  = 8
  special = false
}

resource docker_container example_lambda_python {
  image = "lambci/lambda:build-python3.8"
  name  = random_string.container_name.result

  command = [
    "pip",
    "install",
    "-r",
    "requirements.txt",
    "-t",
    "/var/task/layer"
  ]

  volumes {
    host_path      = abspath("${path.module}/../../src/")
    container_path = "/var/task/"
  }

  volumes {
    host_path      = abspath("${path.module}/layer/")
    container_path = "/var/task/layer/"
  }
}
