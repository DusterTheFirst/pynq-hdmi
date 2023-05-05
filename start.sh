#!/bin/bash

set -euxo pipefail

vivado -source rebuild.tcl -nolog -nojournal
