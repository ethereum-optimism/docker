#!/bin/bash

SERVICES=$SERVICES \
    gomplate -f nginx.template.conf > /etc/nginx/nginx.conf
