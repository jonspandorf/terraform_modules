[
  {
    "essential": true,
    "memory": ${CONTAINER_RAM},
    "name": "${CONTAINER_NAME}",
    "cpu": ${CONTAINER_CPU},
    "image": "${REPOSITORY_URL}:${BUILD_NUMBER}",
    "workingDirectory": "/",
    "portMappings": [
        {
            "containerPort": ${CONTAINER_PORT},
            "hostPort": ${ECS_PORT}
        }
    ],
    "environment": ${ENVIRONMENT},
    "linuxParameters": {
      "initProcessEnabled": true
    }
  }
]

