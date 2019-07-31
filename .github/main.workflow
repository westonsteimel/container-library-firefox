workflow "Build and Push Dockerfiles" {
  on = "schedule(0 1 * * *)"
  resolves = ["Push Firefox beta to DockerHub", "Push Firefox nightly to DockerHub", "Push Firefox latest to DockerHub", "Push Firefox stable to DockerHub"]
}

action "Login DockerHub" {
  uses = "actions/docker/login@86ff551d26008267bb89ac11198ba7f1d807b699"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "Build Firefox nightly" {
  uses = "actions/docker/cli@86ff551d26008267bb89ac11198ba7f1d807b699"
  args = "build -t \"${DOCKER_USERNAME}/firefox:nightly\" nightly"
  secrets = ["DOCKER_USERNAME"]
  needs = ["Login DockerHub"]
}

action "Build Firefox beta" {
  uses = "actions/docker/cli@86ff551d26008267bb89ac11198ba7f1d807b699"
  args = "build -t \"${DOCKER_USERNAME}/firefox:beta\" beta"
  secrets = ["DOCKER_USERNAME"]
  needs = ["Login DockerHub"]
}

action "Build Firefox stable" {
  uses = "actions/docker/cli@86ff551d26008267bb89ac11198ba7f1d807b699"
  args = "build -t \"${DOCKER_USERNAME}/firefox:stable\" -t \"${DOCKER_USERNAME}/firefox:latest\"  stable"
  secrets = ["DOCKER_USERNAME"]
  needs = ["Login DockerHub"]
}

action "Push Firefox beta to DockerHub" {
  uses = "actions/docker/cli@86ff551d26008267bb89ac11198ba7f1d807b699"
  needs = ["Build Firefox beta"]
  args = "push \"${DOCKER_USERNAME}/firefox:beta\" "
  secrets = ["DOCKER_USERNAME"]
}

action "Push Firefox nightly to DockerHub" {
  uses = "actions/docker/cli@86ff551d26008267bb89ac11198ba7f1d807b699"
  needs = ["Build Firefox nightly"]
  args = "push \"${DOCKER_USERNAME}/firefox:nightly\""
  secrets = ["DOCKER_USERNAME"]
}

action "Push Firefox stable to DockerHub" {
  uses = "actions/docker/cli@86ff551d26008267bb89ac11198ba7f1d807b699"
  needs = ["Build Firefox stable"]
  args = "push \"${DOCKER_USERNAME}/firefox:latest\""
  secrets = ["DOCKER_USERNAME"]
}

action "Push Firefox latest to DockerHub" {
  uses = "actions/docker/cli@86ff551d26008267bb89ac11198ba7f1d807b699"
  needs = ["Build Firefox stable"]
  args = "push \"${DOCKER_USERNAME}/firefox:latest\""
  secrets = ["DOCKER_USERNAME"]
}
