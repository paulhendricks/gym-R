#' Create a GymClient instance.
#'
#' This function instantiates a GymClient instance to integrate with an OpenAI Gym server.
#'
#' @param remote_base The URL of the OpenAI  gym server. This value is usually "http://127.0.0.1:5000".
#' @return An instance of class "GymClient"; this object has "remote_base" as an attribute.
#' @export
create_GymClient <- function(remote_base) {
  structure(list(remote_base = remote_base), class = "GymClient")
}

#' Represent a GymClient instance on the command line.
#'
#' @param x An instance of class "GymClient"; this object has "remote_base" as an attribute.
#' @param ... Further arguments passed to or from other methods.
#' @return x A GymClient instance.
#' @export
print.GymClient <- function(x, ...) {
  cat("<GymClient: ", x$remote_base, ">\n", sep = "")
  invisible(x)
}

#' Create an instance of the specified environment.
#'
#' @param x An instance of class "GymClient"; this object has "remote_base" as an attribute.
#' @param env_id A short identifier (such as "3c657dbc") for the created environment instance. The instance_id is used in future API calls to identify the environment to be manipulated.
#' @return A short identifier (such as "3c657dbc") for the created environment instance. The instance_id is used in future API calls to identify the environment to be manipulated.
#' @export
env_create <- function(x, env_id) {
  route <- "/v1/envs/"
  data <- list(env_id = env_id)
  response <- post_request(x, route, data)
  instance_id <- response[["instance_id"]]
  instance_id
}

#' List all environments running on the server.
#'
#' @param x An instance of class "GymClient"; this object has "remote_base" as an attribute.
#' @return A list mapping instance_id to env_id e.g. \code{list("3c657dbc" = "CartPole-v0")} for every env on the server.
#' @export
env_list_all <- function(x) {
  route <- "/v1/envs/"
  response <- get_request(x, route)
  all_envs <- response[["all_envs"]]
  all_envs
}

#' Reset the state of the environment and return an initial observation.
#'
#' @param x An instance of class "GymClient"; this object has "remote_base" as an attribute.
#' @param instance_id A short identifier (such as "3c657dbc") for the environment instance.
#' @return The initial observation of the space.
#' @export
env_reset <- function(x, instance_id) {
  route <- paste0("/v1/envs/", instance_id, "/reset/", sep = "")
  response <- post_request(x, route)
  observation <- response[["observation"]]
  observation
}

#' Step though an environment using an action.
#'
#'
#' @param x An instance of class "GymClient"; this object has "remote_base" as an attribute.
#' @param instance_id A short identifier (such as "3c657dbc") for the environment instance.
#' @param action An action to take in the environment.
#' @param render Whether to render the environment. Defaults to FALSE.
#' @return A list consisting of the following: action; an action to take in the environment, observation; an agent's observation of the current environment, reward; the amount of reward returned after previous action, done; whether the episode has ended, and info; a list containing auxiliary diagnostic information.
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

#' Get information (name and dimensions/bounds) of the environments's action space.
#'
#' @param x An instance of class "GymClient"; this object has "remote_base" as an attribute.
#' @param instance_id A short identifier (such as "3c657dbc") for the environment instance.
#' @return A list containing "name" (such as "Discrete"), and additional dimensional info (such as "n") which varies from space to space.
#' @export
env_action_space_info <- function(x, instance_id) {
  route <- paste0("/v1/envs/", instance_id, "/action_space/", sep = "")
  response <- get_request(x, route)
  info <- response[["info"]]
  info
}

#' Sample an action from the environments's action space.
#'
#' @param x An instance of class "GymClient"; this object has "remote_base" as an attribute.
#' @param instance_id A short identifier (such as "3c657dbc") for the environment instance.
#' @return An action sampled from a space (such as "Discrete"), which varies from space to space.
#' @export
env_action_space_sample <- function(x, instance_id) {
  route <- paste0("/v1/envs/", instance_id, "/action_space/sample", sep = "")
  response <- get_request(x, route)
  action <- response[["action"]]
  action
}

#' Evaluate whether an action is a member of an environments's action space.
#'
#' @param x An instance of class "GymClient"; this object has "remote_base" as an attribute.
#' @param instance_id A short identifier (such as "3c657dbc") for the environment instance.
#' @param action An action to take in the environment.
#' @return A boolean atomic vector of length one indicating if the action is a member of an environments's action space.
#' @export
env_action_space_contains <- function(x, instance_id, action) {
  route <- paste0("/v1/envs/", instance_id, "/action_space/contains/",
                  action, "/", sep = "")
  response <- get_request(x, route)
  member <- response[["member"]]
  member
}

#' Get information (name and dimensions/bounds) of the environment's observation space.
#'
#' @param x An instance of class "GymClient"; this object has "remote_base" as an attribute.
#' @param instance_id A short identifier (such as "3c657dbc") for the environment instance.
#' @return A list containing "name" (such as "Discrete"), and additional dimensional info (such as "n") which varies from space to space.
#' @export
env_observation_space_info <- function(x, instance_id) {
  route <- paste0("/v1/envs/", instance_id, "/observation_space/", sep = "")
  response <- get_request(x, route)
  info <- response[["info"]]
  info
}

#' Start monitoring.
#'
#' @param x An instance of class "GymClient"; this object has "remote_base" as an attribute.
#' @param instance_id A short identifier (such as "3c657dbc") for the environment instance.
#' @param directory The directory to write the training data to. Defaults to FALSE.
#' @param force Clear out existing training data from this directory (by deleting every file prefixed with "openaigym"). Defaults to NULL.
#' @param resume Retain the training data already in this directory, which will be merged with our new data. Defaults to FALSE.
#' @return NULL.
#' @export
env_monitor_start <- function(x, instance_id, directory, force = FALSE,
                              resume = FALSE) {
  route <- paste0("/v1/envs/", instance_id, "/monitor/start/", sep = "")
  data <- list(directory = directory, force = force,
               resume = resume)
  response <- post_request(x, route, data)
  invisible()
}

#' Flush all monitor data to disk.
#'
#' @param x An instance of class "GymClient"; this object has "remote_base" as an attribute.
#' @param instance_id A short identifier (such as "3c657dbc") for the environment instance.
#' @return NULL.
#' @export
env_monitor_close <- function(x, instance_id) {
  route <- paste0("/v1/envs/", instance_id, "/monitor/close/", sep = "")
  response <- post_request(x, route)
  invisible()
}

#' Flush all monitor data to disk.
#'
#' @param x An instance of class "GymClient"; this object has "remote_base" as an attribute.
#' @param instance_id A short identifier (such as "3c657dbc") for the environment instance.
#' @return NULL.
#' @export
env_close <- function(x, instance_id) {
  route <- paste0("/v1/envs/", instance_id, "/close/", sep = "")
  response <- post_request(x, route)
  invisible()
}

#' Flush all monitor data to disk.
#'
#' @param x An instance of class "GymClient"; this object has "remote_base" as an attribute.
#' @param training_dir A directory containing the results of a training run.
#' @param api_key Your OpenAI API key.
#' @param algorithm_id An arbitrary string indicating the paricular version of the algorithm (including choices of parameters) you are running.
#' @return NULL.
#' @export
upload <- function(x, training_dir, api_key = NULL, algorithm_id = NULL) {
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

#' Request a server shutdown.
#'
#' @param x An instance of class "GymClient"; this object has "remote_base" as an attribute.
#' @return NULL Currently used by the integration tests to repeatedly create and destroy fresh copies of the server running in a separate thread.
#' @export
shutdown_server <- function(x) {
  route <- "/v1/shutdown/"
  response <- post_request(x, route)
  invisible()
}
