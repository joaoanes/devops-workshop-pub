#!/bin/bash

terraform output -json student_credentials | jq > creds.json