<!-- README.md is generated from README.Rmd. Please edit that file -->
gym
===

[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/0.1.0/active.svg)](http://www.repostatus.org/#active)

`gym` provides access to the OpenAI Gym API from R.

Installation
------------

You can install:

-   the latest released version from CRAN:

    ``` r
    install.packages("gym")
    ```

-   the latest development version from Github:

    ``` r
    if (packageVersion("devtools") < 1.6) {
      install.packages("devtools")
    }
    devtools::install_github("paulhendricks/gym-R", subdir = "gym")
    ```

If you encounter a clear bug, please file a minimal reproducible example on [github](https://github.com/paulhendricks/gym-R/issues).

API
---

``` r
library(gym)

remote_base <- "http://127.0.0.1:5000"
client <- create_GymClient(remote_base)
print(client)

# Create environment
env_id <- "CartPole-v0"
instance_id <- env_create(client, env_id)
print(instance_id)

# List all environments
all_envs <- env_list_all(client)
print(all_envs)

# Set up agent
action_space_info <- env_action_space_info(client, instance_id)
print(action_space_info)
agent <- random_discrete_agent(action_space_info[["n"]])

# Run experiment, with monitor
outdir <- "/tmp/random-agent-results"
env_monitor_start(client, instance_id, outdir, force = TRUE, resume = FALSE)

episode_count <- 100
max_steps <- 200
reward <- 0
done <- FALSE

for (i in 1:episode_count) {
  ob <- env_reset(client, instance_id)
  for (i in 1:max_steps) {
    action <- env_action_space_sample(client, instance_id)
    results <- env_step(client, instance_id, action, render = TRUE)
    if (results[["done"]]) break
  }
}

# Dump result info to disk
env_monitor_close(client, instance_id)
```

People
------

-   The original author of `gym` is [Paul Hendricks](https://github.com/paulhendricks). [![Gratipay](https://img.shields.io/gratipay/JSFiddle.svg)](https://gratipay.com/~paulhendricks/)

-   The lead maintainer of `gym` is [Paul Hendricks](https://github.com/paulhendricks). [![Gratipay](https://img.shields.io/gratipay/JSFiddle.svg)](https://gratipay.com/~paulhendricks/)

License
-------

[![License](http://img.shields.io/:license-mit-blue.svg)](https://github.com/paulhendricks/gym-R/blob/master/gym/LICENSE)
