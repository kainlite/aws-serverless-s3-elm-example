#!/bin/bash

aws s3 sync . s3://skynetng.pw/ --acl public-read
