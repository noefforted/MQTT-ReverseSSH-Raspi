#!/bin/bash
ssh -o "StrictHostKeyChecking=no" -R 5050:localhost:1883 ubuntu@13.213.41.188 -i ./key/AWS-Widya.pem