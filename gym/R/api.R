#' TO BE EDITED.
#'
#' TO BE EDITED.
#'
#' @return TO BE EDITED.
#' @export
create_GymClient <- function(remote_base) {
  structure(list(remote_base = remote_base), class = "GymClient")
}

#' TO BE EDITED.
#'
#' TO BE EDITED.
#'
#' @return TO BE EDITED.
#' @export
print.GymClient <- function(x, ...) {
  cat("<GymClient: ", x$remote_base, ">\n", sep = "")
  invisible(x)
}

#' TO BE EDITED.
#'
#' TO BE EDITED.
#'
#' @return TO BE EDITED.
#' @export
env_create <- function(x, env_id) {
  route <- "/v1/envs/"
  data <- list(env_id = env_id)
  response <- post_request(x, route, data)
  instance_id <- response[["instance_id"]]
  instance_id
}

#' TO BE EDITED.
#'
#' TO BE EDITED.
#'
#' @return TO BE EDITED.
#' @export
env_list_all <- function(x) {
  route <- "/v1/envs/"
  response <- get_request(x, route)
  all_envs <- response[["all_envs"]]
  all_envs
}

#' TO BE EDITED.
#'
#' TO BE EDITED.
#'
#' @return TO BE EDITED.
#' @export
env_reset <- function(x, instance_id) {
  route <- paste0("/v1/envs/", instance_id, "/reset/", sep = "")
  response <- post_request(x, route)
  observation <- response[["observation"]]
  observation
}

#' TO BE EDITED.
#'
#' TO BE EDITED.
#'
#' @return TO BE EDITED.
#' @export
env_step <- function(x, instance_id, action, render = FALSE) {
  route <- paste0("/v1/envs/", instance_id, "/step/", sep = "")
  data <- list(instance_id = instance_id, action = action, render = render)
  response <- post_request(x, route, data)
  observation <- response[["observation"]]
  reward <- response[["reward"]]
  done <- response[["done"]]
  info <- response[["info"]]
  list(observation = observation,
       reward = reward,
       done = done,
       info = info)
}

#' TO BE EDITED.
#'
#' TO BE EDITED.
#'
#' @return TO BE EDITED.
#' @export
env_action_space_info <- function(x, instance_id) {
  route <- paste0("/v1/envs/", instance_id, "/action_space/", sep = "")
  response <- get_request(x, route)
  info <- response[["info"]]
  info
}

#' TO BE EDITED.
#'
#' TO BE EDITED.
#'
#' @return TO BE EDITED.
#' @export
env_action_space_sample <- function(x, instance_id) {
  route <- paste0("/v1/envs/", instance_id, "/action_space/sample", sep = "")
  response <- get_request(x, route)
  action <- response[["action"]]
  action
}

#' TO BE EDITED.
#'
#' TO BE EDITED.
#'
#' @return TO BE EDITED.
#' @export
env_action_space_contains <- function(x, instance_id, action) {
  route <- paste0("/v1/envs/", instance_id, "/action_space/contains/",
                  action, "/", sep = "")
  response <- get_request(x, route)
  member <- response[["member"]]
  member
}

#' TO BE EDITED.
#'
#' TO BE EDITED.
#'
#' @return TO BE EDITED.
#' @export
env_observation_space_info <- function(x, instance_id) {
  route <- paste0("/v1/envs/", instance_id, "/observation_space/", sep = "")
  response <- get_request(x, route)
  info <- response[["info"]]
  info
}

#' TO BE EDITED.
#'
#' TO BE EDITED.
#'
#' @return TO BE EDITED.
#' @export
env_monitor_start <- function(x, instance_id, directory, force = FALSE,
                              resume = FALSE) {
  route <- paste0("/v1/envs/", instance_id, "/monitor/start/", sep = "")
  data <- list(directory = directory, force = force,
               resume = resume)
  response <- post_request(x, route, data)
  invisible()
}

#' TO BE EDITED.
#'
#' TO BE EDITED.
#'
#' @return TO BE EDITED.
#' @export
env_monitor_close <- function(x, instance_id) {
  route <- paste0("/v1/envs/", instance_id, "/monitor/close/", sep = "")
  response <- post_request(x, route)
  invisible()
}

#' TO BE EDITED.
#'
#' TO BE EDITED.
#'
#' @return TO BE EDITED.
#' @export
env_close <- function(x, instance_id) {
  route <- paste0("/v1/envs/", instance_id, "/close/", sep = "")
  response <- post_request(x, route)
  invisible()
}

#' TO BE EDITED.
#'
#' TO BE EDITED.
#'
#' @return TO BE EDITED.
#' @export
upload <- function(x, training_dir, algorithm_id = NULL, api_key = NULL) {
  if (is.null(api_key)) {
    api_key <- Sys.getenv("OPENAI_GYM_API_KEY")
  }

  route <- "/v1/upload/"
  data = list(training_dir = training_dir,
              algorithm_id = algorithm_id,
              api_key = api_key)
  response <- post_request(x, route, data)
  invisible()
}

#' TO BE EDITED.
#'
#' TO BE EDITED.
#'
#' @return TO BE EDITED.
#' @export
shutdown_server <- function(x) {
  route <- "/v1/shutdown/"
  response <- post_request(x, route)
  invisible()
}
