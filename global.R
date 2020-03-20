
# This is the global library for the cultivation_app.
# All variables in this files are shared among all session.
#
# Author: Joeri Jongbloets <j.a.jongbloets@uva.nl>
# Author: Hugo Pineda <hugo.pinedahernandez@student.uva.nl>
#

APP_VERSION <- "0.1.0"

# load settings
source(here::here("settings.R"))

# load overall dependencies
source(file.path(lib.dir, "dependencies.R"))
source(file.path(lib.dir, "estimate_r.R"))

# load data
source(file.path(data.dir, "ecdc.R"))
df.ecdc <- load_ecdc()
