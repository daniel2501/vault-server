#!/usr/bin/env bash

export TF_VAR_os_user_password=$(pass tfts/os_password)
export TF_VAR_ts_admin_password=$(pass tfts/ts_admin_password)

echo -e "Running:\nterraform $1"
terraform $1

unset TF_VAR_os_user_password
unset TF_VAR_ts_admin_password
