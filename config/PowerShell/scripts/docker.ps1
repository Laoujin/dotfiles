function DockerCompose-Up-And-Build {
  docker-compose up -d --build
}

Set-Alias d docker
Set-Alias dc docker-compose
Set-Alias dcub DockerCompose-Up-And-Build
